# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

LocalizeAR is a sophisticated AR localization library for iOS/macOS that combines C++, Objective-C, and Swift to provide precise positioning and mapping using computer vision and sensor fusion. The project uses ARKit integration and advanced SLAM (Simultaneous Localization and Mapping) algorithms.

## Build Commands

### Swift Package Manager
```bash
# Build the package
swift build

# Build for release
swift build -c release

# Test the package
swift test

# Clean build artifacts
swift package clean

# Resolve dependencies
swift package resolve

# Update dependencies
swift package update
```

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
- `LARNavigationManager.swift`: High-level navigation coordination
- `LARNavigationGraph.swift`: Graph-based pathfinding
- `LARMKUserLocationAnnotationView.swift`: MapKit integration

#### Rendering (`/Sources/LocalizeAR/Rendering/` & `/SceneKit/`)
- `LARAnchorEntity.swift`: RealityKit entities
- `LARSCNAnchorNode.swift`: SceneKit node management

### Dependencies

#### External Frameworks (XCFrameworks)
- `g2o.xcframework`: Graph optimization for SLAM backend
- `opencv2.xcframework`: Computer vision processing

#### System Frameworks
- ARKit (iOS), OpenCL (macOS): Platform-specific AR/compute
- SceneKit, MapKit, CoreLocation: Rendering and location services
- Accelerate: High-performance computing

## Development Workflow

### Adding New Features
1. Implement core algorithms in C++ (`.Submodules/lar/`)
2. Add Objective-C bridge interfaces in `Sources/LocalizeAR-ObjC/`
3. Create Swift API wrappers in `Sources/LocalizeAR/`
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