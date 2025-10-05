# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

LocalizeAR is a sophisticated AR localization library for iOS/macOS that combines C++, Objective-C, and Swift to provide precise positioning and mapping using computer vision and sensor fusion. The project uses ARKit integration and advanced SLAM (Simultaneous Localization and Mapping) algorithms.

## Build Commands

### Recommended: Use Build Script (Handles Compiler Configuration)

The project includes a `build.sh` script that automatically configures the correct C++ compiler (Apple Clang) to avoid conflicts with Homebrew's gcc.

```bash
# Build debug version (recommended)
./build.sh

# Build and run tests
./build.sh test

# Build release version
./build.sh release

# Clean build artifacts
./build.sh clean
```

**Why use build.sh?**
- Automatically sets `CC` and `CXX` to Apple Clang
- Prevents gcc-12 conflicts from Homebrew
- Same configuration used in CI/CD
- Displays compiler versions for verification

### Swift Package Manager (Manual)

If you need to use SPM directly, set compiler environment variables first:

```bash
# Set compilers to Apple Clang (required!)
export CC=$(xcrun --find clang)
export CXX=$(xcrun --find clang++)

# Then use SPM commands
swift build
swift build -c release
swift test
swift package clean
swift package resolve
swift package update
```

**Note:** Without setting `CC` and `CXX`, SPM may use gcc-12 from Homebrew, which will fail with unrecognized flag errors.

### Example Applications
```bash
# Build LARScan (iOS example)
cd Examples/LARScan
xcodebuild -scheme LARScan -destination 'platform=iOS Simulator,name=iPhone 14'

# Build LARExplorer (macOS example)  
cd Examples/LARExplorer
xcodebuild -scheme LARExplorer -destination 'platform=macOS'

# Run tests for example apps
xcodebuild test -scheme LARScan -destination 'platform=iOS Simulator,name=iPhone 14'
```

### Submodule Management
```bash
# Initialize and update submodules (required for C++ core)
git submodule update --init --recursive

# Update to latest submodule version
git submodule update --remote .Submodules/lar
```

## Architecture

### Multi-Language Stack
The project uses a three-layer architecture:

1. **C++ Core (`LocalizeAR-CPP`)**: High-performance computer vision algorithms in `.Submodules/lar/`
2. **Objective-C Bridge (`LocalizeAR-ObjC`)**: Interface layer between C++ and Swift
3. **Swift API (`LocalizeAR`)**: Modern Swift interface for iOS/macOS applications

### Key Modules

#### Core Components
- `LARTracker.swift`: ARKit integration and real-time tracking
- `LARMap.swift`: Map data structures and location handling  
- `LARLiveMapper.swift`: Real-time mapping capabilities
- `LARARAnchor.swift`: AR anchor management

#### Navigation System (`/Sources/LocalizeAR/Navigation/`)

**New SOLID Architecture (Recommended):**
- `LARNavigationCoordinator.swift`: Facade for navigation (replaces LARNavigationManager)
- `Protocols/`: Protocol interfaces for dependency injection
  - `LARSceneRendering.swift`: SceneKit rendering operations
  - `LARMapRendering.swift`: MapKit rendering operations
  - `LARNavigationStateManaging.swift`: State management
- `Rendering/`: Concrete implementations
  - `LARSceneRenderer.swift`: SceneKit-only rendering
  - `LARMapRenderer.swift`: MapKit-only rendering
- `State/LARNavigationStateManager.swift`: Navigation state
- `Data/LARNavigationGraphAdapter.swift`: Anchor/edge data container

**Legacy (Deprecated):**
- `LARNavigationManager.swift`: Monolithic manager (use LARNavigationCoordinator instead)
- `LARNavigationGraph.swift`: Graph-based pathfinding

**MapKit Integration:**
- `LARMKUserLocationAnnotationView.swift`: User location view
- `LARMKNavigationNodeOverlay.swift`: Navigation node overlays
- `LARMKNavigationGuideNodeOverlay.swift`: Guide node overlays

#### Rendering (`/Sources/LocalizeAR/Rendering/` & `/SceneKit/`)
- `LARAnchorEntity.swift`: RealityKit entities
- `LARSCNAnchorNode.swift`: SceneKit node management

### Dependencies

#### External Packages (Swift PM)
- **Swinject** (2.8.0+): Dependency injection framework for protocol-based architecture

#### External Frameworks (XCFrameworks)
- `g2o.xcframework`: Graph optimization for SLAM backend
- `opencv2.xcframework`: Computer vision processing

#### System Frameworks
- ARKit (iOS), OpenCL (macOS): Platform-specific AR/compute
- SceneKit, MapKit, CoreLocation: Rendering and location services
- Accelerate: High-performance computing

## Experimental Development Philosophy

This project is in the experimental phase, which shapes our development approach:

### Core Principles

1. **Fail Fast, Learn Fast**: Prioritize quick iterations over perfect code. Make bold architectural changes when they improve the system fundamentally.

2. **Make It Work → Make It Right → Make It Fast**:
   - First: Get working code that demonstrates the concept
   - Second: Refactor for clean architecture and maintainability
   - Third: Profile and optimize only identified bottlenecks

3. **Aggressive Error Detection**: Unintended states should throw errors immediately, not fall back gracefully. This is not production code - we want to catch design flaws early.
   - Use `fatalError()` liberally for "impossible" states
   - Prefer `precondition()` over defensive nil checks
   - Make invalid states unrepresentable when possible

4. **Backwards Compatibility is Optional**: We can make breaking changes freely as long as:
   - We can detect regressions through testing/examples
   - The change represents a principled architectural improvement
   - We document the reasoning for future reference

### Experimental Practices

- **Bold Refactoring**: Don't hesitate to restructure entire modules if it clarifies the design
- **API Experimentation**: Try multiple API designs for the same functionality to find the best developer experience
- **Performance Last**: Focus on correctness and clarity first; optimize only when performance becomes a concrete blocker
- **Verbose Logging**: Add detailed logging to understand system behavior - remove it later if needed
- **Example-Driven Development**: Use the example apps as the primary way to validate architectural decisions

### Quality Gates

Before considering any code "stable":
1. Example applications demonstrate the feature working end-to-end
2. Error states are properly detected and reported
3. The API feels natural to use in real scenarios
4. Core algorithms are validated against test data

## Development Workflow

### Adding New Features
1. Implement core algorithms in C++ (`.Submodules/lar/`)
2. Add Objective-C bridge interfaces in `Sources/LocalizeAR-ObjC/`
3. Create Swift extensions in `Sources/LocalizeAR/`
4. Update example applications to demonstrate usage

### Testing
- Use Xcode's built-in testing for iOS/macOS specific functionality
- Example apps serve as integration tests
- C++ core has its own testing in the submodule

### Platform Considerations
- iOS: Uses ARKit for camera tracking and scene understanding
- macOS: Uses OpenCL for computational tasks, no ARKit equivalent
- Both platforms share core computer vision algorithms

## Important Files

### Configuration
- `Package.swift`: Swift Package Manager configuration with C++17 settings
- `.Submodules/lar/`: C++ core algorithms (managed as Git submodule)

### Example Usage Patterns
- `Examples/LARScan/`: iOS AR scanning application  
- `Examples/LARExplorer/`: macOS map visualization application

### Framework Integration
- Pre-built XCFrameworks in `Frameworks/` directory
- Platform-specific linker settings in `Package.swift`

## Common Development Tasks

### Updating Core C++ Library
```bash
cd .Submodules/lar
git pull origin main
cd ../..
git add .Submodules/lar
git commit -m "Update lar submodule to latest version"
```

### Working with XCFrameworks
The project uses local XCFrameworks by default. To use remote versions, uncomment the binary target URLs in `Package.swift` and comment out the local paths.

### Mixed Language Debugging
- C++ code: Debug through Objective-C bridge or use print statements
- Objective-C: Standard Xcode debugging works
- Swift: Full Xcode debugging support available

## Requirements

- **Xcode**: 13+ (for Swift 5.5+ support)  
- **Platforms**: iOS 14+, macOS 12+
- **Languages**: C++17, Objective-C, Swift 5.5+
- **Dependencies**: Git submodules must be initialized

## Architecture Notes

This is a performance-critical real-time AR system that requires:
- Careful memory management across language boundaries
- Platform-specific optimizations (ARKit vs OpenCL)
- Real-time processing constraints for AR applications
- Cross-platform compatibility between iOS and macOS
- Thread-safety

### Dependency Injection & SOLID Principles

The Swift layer uses **Swinject** for dependency injection and follows SOLID principles:

#### Using LocalizeAR with DI

```swift
import Swinject
import LocalizeAR

// In your app's assembly
class AppAssembly: Assembly {
    func assemble(container: Container) {
        // Import LocalizeAR's DI setup
        _ = Assembler([LocalizeARAssembly()], container: container)

        // Register your LARMap instance
        container.register(LARMap.self) { _ in myMapData }

        // Resolve navigation coordinator
        let coordinator = container.resolve(LARNavigationCoordinator.self)!
    }
}
```

#### Architecture Patterns Used

- **Facade Pattern**: `LARNavigationCoordinator` provides simple API
- **Protocol-Oriented Design**: All components have protocol interfaces
- **Dependency Injection**: Via Swinject (`LocalizeARAssembly`)
- **Single Responsibility**: Each component has one job
  - `LARSceneRenderer`: SceneKit rendering only
  - `LARMapRenderer`: MapKit rendering only
  - `LARNavigationStateManager`: State management only

**See `ARCHITECTURE_REFACTOR.md` for detailed documentation.**

## Troubleshooting

### Build Fails with gcc-12 Errors

**Symptoms:**
```
gcc-12: error: unrecognized command-line option '-target'
gcc-12: error: unrecognized command-line option '-fmodules'
```

**Solution:** Use the build script or set compiler environment variables:
```bash
# Option 1: Use build script (recommended)
./build.sh

# Option 2: Set environment variables
export CC=$(xcrun --find clang)
export CXX=$(xcrun --find clang++)
swift build
```

**Root Cause:** Homebrew's gcc-12 doesn't support Xcode-specific flags. SPM needs Apple Clang.

### Submodule Issues

If C++ core fails to compile:
```bash
# Ensure submodules are initialized
git submodule update --init --recursive

# Verify submodule is present
ls -la .Submodules/lar/
```

## CI/CD

GitHub Actions workflow (`.github/workflows/test.yml`) automatically:
- Uses `build.sh` for consistent builds
- Sets `CC` and `CXX` to Apple Clang
- Fetches git submodules
- Runs tests

**See `CI_CD_SETUP.md` for detailed CI/CD documentation.**