# LARExplorer TDD Architecture Plan

> **Status**: Draft v4 - Autonomous Execution Ready
> **Created**: 2026-01-04
> **Last Updated**: 2026-01-04
> **Purpose**: Test-Driven Development architecture redesign for better testability and agentic AI coding experience

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Autonomous Execution Guide](#autonomous-execution-guide)
3. [Design Principles](#design-principles)
3. [Dual-View Rendering Pattern](#dual-view-rendering-pattern)
4. [Current Architecture Analysis](#current-architecture-analysis)
5. [Architecture Comparison](#architecture-comparison)
6. [TDD Phase Breakdown](#tdd-phase-breakdown)
7. [Directory Structure](#directory-structure)
8. [Key Protocols](#key-protocols)
9. [Code Examples](#code-examples)
10. [Testing Strategy](#testing-strategy)
11. [Migration Checklist](#migration-checklist)

---

## Executive Summary

This document outlines a Test-Driven Development (TDD) approach to refactoring LARExplorer's architecture. The key goals are:

1. **Testability**: All business logic testable without UI dependencies
2. **3-View Pattern**: Each tool coordinates SceneKit (3D), MapKit (2D), and SwiftUI (Inspector)
3. **Agentic AI Friendly**: Tests verify correctness without human visual inspection
4. **Simplicity First**: Minimal abstractions, add complexity only when needed

### Core Innovation: Command Pattern for Rendering

Instead of testing "does the anchor turn green?", we test "was `highlightAnchor(id: 1, color: .green)` called?"

```
State → Rendering Commands → Visual Output
        ↑
        This is testable!
```

### Key Simplifications (v2)

| Before | After | Rationale |
|--------|-------|-----------|
| 5+ protocols | 2 core protocols | Most were premature abstractions |
| Per-tool renderers | Shared rendering services | Highlighting logic is identical across tools |
| Forced pattern for all tools | Flexible complexity | Simple tools don't need full machinery |
| "Feature" naming | "Tool" naming | Matches UI terminology |

---

## Autonomous Execution Guide

This section explains how to use Claude Code to execute phases 0-6 autonomously with minimal human intervention.

### Quick Start

**Option 1: Interactive Auto-Accept Mode (Recommended)**

```bash
cd /Users/kobejean/Developer/GitHub/lar-swift/Examples/LARExplorer
claude
```

Then in Claude Code:
1. Press **Shift+Tab** twice to enter "Auto-Accept Edit Mode"
2. Say: `Execute Phase 0 of @TDD_ARCHITECTURE_PLAN.md - commit after each major step`

**Option 2: Single Command Execution**

```bash
cd /Users/kobejean/Developer/GitHub/lar-swift/Examples/LARExplorer
claude -p "Execute Phase 0 of TDD_ARCHITECTURE_PLAN.md. Create git commits after each completed step. Run tests to verify. Continue until the phase is complete."
```

### Phase-by-Phase Prompts

Copy these prompts to execute each phase:

#### Phase 0: Test Infrastructure
```
Execute Phase 0 from TDD_ARCHITECTURE_PLAN.md:
1. Create Domain/Protocols/MapRepository.swift
2. Create Domain/Protocols/RenderingService.swift
3. Create Domain/Protocols/ToolCoordinator.swift
4. Create TestSupport/Mocks/MockMapRepository.swift
5. Create TestSupport/Mocks/MockRenderingService.swift
6. Verify: swift build succeeds
7. Commit with message: "Phase 0: Add test infrastructure protocols and mocks"

Work autonomously. Run swift build after each file to catch errors early.
```

#### Phase 1: Domain Layer
```
Execute Phase 1 from TDD_ARCHITECTURE_PLAN.md:
For each tool (AnchorEdit, EdgeEdit, GPSAlignment, Relocalization, Landmarks):
1. Write the State+Action file with reduce() returning fatalError
2. Write failing tests FIRST (RED)
3. Implement reduce() to pass tests (GREEN)
4. Run: swift test --filter Domain
5. Commit each tool: "Phase 1: Add {ToolName}State with TDD"

Work autonomously. Follow strict TDD - tests before implementation.
```

#### Phase 2: Repository Layer
```
Execute Phase 2 from TDD_ARCHITECTURE_PLAN.md:
1. Create Infrastructure/LARMapRepository.swift implementing MapRepository
2. Write integration tests in Tests/Integration/LARMapRepositoryTests.swift
3. Run: swift test --filter Integration
4. Commit: "Phase 2: Add LARMapRepository with integration tests"

Work autonomously. Use real LARMap for integration tests.
```

#### Phase 3: Tool Coordinators
```
Execute Phase 3 from TDD_ARCHITECTURE_PLAN.md:
For each tool:
1. Write failing tests for the coordinator FIRST
2. Implement the coordinator to pass tests
3. Run: swift test --filter Tool
4. Commit each: "Phase 3: Add {ToolName}Tool coordinator"

Work autonomously. Inject MockMapRepository and MockRenderingService in tests.
```

#### Phase 4: Rendering Services
```
Execute Phase 4 from TDD_ARCHITECTURE_PLAN.md:
1. Create Infrastructure/SceneRenderingService.swift
2. Create Infrastructure/MapRenderingService.swift
3. Write tests verifying command sequences (not visual output)
4. Run: swift test --filter Rendering
5. Commit: "Phase 4: Add shared rendering services"

Work autonomously. Test that correct methods are called, not visual results.
```

#### Phase 5: View Layer
```
Execute Phase 5 from TDD_ARCHITECTURE_PLAN.md:
1. Refactor ContentView.swift to pure layout
2. Create view containers (SceneContainerView, MapContainerView, etc.)
3. Create inspector views for each tool
4. Write smoke tests (app launches without crash)
5. Run: swift test --filter Smoke
6. Commit: "Phase 5: Refactor view layer"

Work autonomously. Views should be thin wrappers around coordinators.
```

#### Phase 6: E2E Integration
```
Execute Phase 6 from TDD_ARCHITECTURE_PLAN.md:
1. Write E2E tests for complete user flows:
   - Load map -> Select anchors -> Apply offset -> Verify map updated
   - Select anchors -> Create edge -> Verify edge exists
   - Load frame -> Localize -> Verify commands issued
2. Run: swift test --filter E2E
3. Commit: "Phase 6: Add end-to-end integration tests"

Work autonomously. These tests verify the full stack works together.
```

### Settings Configuration

The `.claude/settings.json` file pre-approves common operations:

```json
{
  "permissions": {
    "allow": [
      "Read", "Edit", "Write", "Glob", "Grep",
      "Bash(swift build:*)", "Bash(swift test:*)",
      "Bash(xcodebuild:*)", "Bash(./build.sh:*)",
      "Bash(git add:*)", "Bash(git commit:*)",
      "Bash(git status:*)", "Bash(git diff:*)"
    ],
    "deny": [
      "Bash(git push:*)",
      "Bash(rm -rf:*)"
    ]
  }
}
```

### Tips for Autonomous Execution

1. **Use Shift+Tab** in interactive mode to enable auto-accept for edits
2. **Git commits are gated** - Claude will ask before pushing (safety measure)
3. **Tests are the checkpoint** - If `swift test` fails, Claude will fix before continuing
4. **One phase at a time** - Each phase builds on the previous
5. **Review commits** - Use `git log --oneline` to see progress

### Verification Commands

After each phase, verify success:

```bash
# Check all tests pass
swift test

# Check build succeeds
swift build

# Review recent commits
git log --oneline -10

# Check for uncommitted changes
git status
```

---

## Design Principles

### 1. Naming: "Tool" not "Feature"

**Rationale**: Users see and select "tools" in the toolbar. The code should match the mental model.

| UI Concept | Code Name |
|------------|-----------|
| Tool picker | `ToolKind` enum |
| Active tool behavior | `AnchorEditTool`, `EdgeEditTool`, etc. |
| Tool state | `AnchorEditState` |
| Tool actions | `AnchorEditAction` |

### 2. Shared Rendering Services (Not Per-Tool)

**Problem**: Every tool needs to highlight anchors. Creating `AnchorEditSceneRenderer`, `EdgeEditSceneRenderer`, `LandmarksSceneRenderer` duplicates logic.

**Solution**: One `SceneRenderingService` that receives commands from any tool.

```
Before:
  AnchorEditTool → AnchorEditSceneRenderer → SCNView
  EdgeEditTool   → EdgeEditSceneRenderer   → SCNView
  LandmarksTool  → LandmarksSceneRenderer  → SCNView

After:
  AnchorEditTool ─┐
  EdgeEditTool   ─┼─→ SceneRenderingService → SCNView
  LandmarksTool  ─┘
```

### 3. Minimal Protocols

**Before (5+ protocols)**:
- `MapDataProviding`
- `NavigationProviding`
- `LocalizationProviding`
- `SceneCommandReceiving`
- `MapCommandReceiving`

**After (2 core protocols)**:
- `MapRepository` - All data operations (read, write, persist)
- `RenderingService` - All rendering commands (scene + map)

Additional protocols only when truly needed.

### 4. Flexible Complexity

Not all tools are equal. Match pattern complexity to tool complexity:

| Tool | Complexity | Pattern |
|------|------------|---------|
| **Explore** | Minimal | Just a coordinator, no state file |
| **Landmarks** | Low | State + Coordinator (read-only selection) |
| **AnchorEdit** | Medium | State + Action + Coordinator |
| **EdgeEdit** | Medium | State + Action + Coordinator |
| **GPSAlignment** | Medium | State + Action + Coordinator |
| **Relocalization** | High | State + Action + Coordinator + async loading |

### 5. Progressive Enhancement

Start with the simplest thing that works. Add abstractions only when:
- Tests become difficult to write
- Duplication becomes painful
- A clear pattern emerges from 3+ similar cases

---

## Dual-View Rendering Pattern

### The Core Insight

A single entity (anchor, character, vehicle) often needs to appear in **both** 3D and 2D views simultaneously. Multiple renderers should operate on the **same shared views** concurrently.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           RendererRegistry                                   │
│            (manages concurrent renderers on shared views)                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   ┌─────────────────────┐              ┌─────────────────────┐              │
│   │      SCNView        │              │      MKMapView      │              │
│   │     (singleton)     │              │     (singleton)     │              │
│   ├─────────────────────┤              ├─────────────────────┤              │
│   │ • AnchorRenderer    │◄────────────►│ • AnchorOverlay     │              │
│   │ • EdgeRenderer      │   Sync via   │ • EdgeOverlay       │              │
│   │ • LandmarkRenderer  │   shared     │ • BoundsOverlay     │              │
│   │ • SelectionRenderer │   state      │ • SelectionOverlay  │              │
│   │ • PreviewRenderer   │              │ • UserLocation      │              │
│   └─────────────────────┘              └─────────────────────┘              │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Two-Level Architecture

#### Level 1: LocalizeAR Library (Reusable 2-View Pattern)

The library provides base protocols for any app that needs synchronized 3D + 2D rendering:

```swift
// Sources/LocalizeAR/Rendering/Protocols/

/// Renders content in a SceneKit scene
public protocol LARSceneContentRenderer: AnyObject {
    var identifier: String { get }
    var isAttached: Bool { get }

    func attach(to rootNode: SCNNode)
    func detach()
    func update()
}

/// Renders content in a MapKit map
public protocol LARMapContentRenderer: AnyObject {
    var identifier: String { get }
    var isAttached: Bool { get }

    func attach(to mapView: MKMapView, coordinateConverter: LARCoordinateConverting)
    func detach()
    func update()
}

/// Coordinates rendering in BOTH views for a single feature
public protocol LARDualRenderer: AnyObject {
    var identifier: String { get }
    var sceneRenderer: LARSceneContentRenderer { get }
    var mapRenderer: LARMapContentRenderer { get }

    func update()
}

/// Manages multiple concurrent renderers on shared views
public final class LARRendererRegistry {
    public func register(_ renderer: LARDualRenderer)
    public func unregister(identifier: String)
    public func updateAll()
}
```

#### Level 2: LARExplorer App (Extended 3-View Pattern)

The app extends with tool-specific state and inspector views:

```swift
// Tool = DualRenderer + State + Inspector (3rd view)
protocol ToolCoordinator: ObservableObject {
    associatedtype State

    var state: State { get }
    var dualRenderer: LARDualRenderer { get }  // Reuses library pattern

    @ViewBuilder var inspector: some View { get }  // 3rd view

    func activate()
    func deactivate()
}
```

### Renderer Lifecycle

| Type | Lifecycle | Example |
|------|-----------|---------|
| **Persistent** | Always attached while map is loaded | Anchors, Edges, Landmarks |
| **Tool-specific** | Attached when tool is active | Selection highlights, Preview nodes |
| **Ephemeral** | Attached during specific operations | Localization result visualization |

### Concurrent Rendering Example

```swift
class AppCoordinator {
    let registry = LARRendererRegistry()

    // Persistent renderers (always on)
    let anchorRenderer = AnchorDualRenderer()
    let edgeRenderer = EdgeDualRenderer()
    let landmarkRenderer = LandmarkDualRenderer()

    // Tool-specific renderer (changes with tool)
    var toolRenderer: LARDualRenderer?

    func onMapLoaded() {
        // Register persistent renderers
        registry.register(anchorRenderer)
        registry.register(edgeRenderer)
        registry.register(landmarkRenderer)
    }

    func switchToTool(_ tool: ToolKind) {
        // Swap tool-specific renderer
        if let old = toolRenderer {
            registry.unregister(identifier: old.identifier)
        }
        toolRenderer = tool.createToolRenderer()
        if let new = toolRenderer {
            registry.register(new)
        }
    }
}
```

### Character Example (Entity in Both Views)

```swift
/// A character that appears in BOTH 3D and 2D simultaneously
final class CharacterDualRenderer: LARDualRenderer {
    let identifier = "character"

    // Shared state observed by both renderers
    @Published var position: simd_float3 = .zero
    @Published var heading: Float = 0

    lazy var sceneRenderer = CharacterSceneRenderer(source: self)
    lazy var mapRenderer = CharacterMapRenderer(source: self)

    func moveTo(_ position: simd_float3, heading: Float) {
        self.position = position
        self.heading = heading
        update()  // Updates BOTH views automatically
    }

    func update() {
        sceneRenderer.update()
        mapRenderer.update()
    }
}

// 3D representation
final class CharacterSceneRenderer: LARSceneContentRenderer {
    private weak var source: CharacterDualRenderer?
    private var node: SCNNode?

    func attach(to rootNode: SCNNode) {
        node = SCNNode(geometry: /* 3D model */)
        rootNode.addChildNode(node!)
    }

    func update() {
        node?.simdPosition = source?.position ?? .zero
        node?.eulerAngles.y = source?.heading ?? 0
    }

    func detach() {
        node?.removeFromParentNode()
        node = nil
    }
}

// 2D representation
final class CharacterMapRenderer: LARMapContentRenderer {
    private weak var source: CharacterDualRenderer?
    private var annotation: MKPointAnnotation?
    private var coordinateConverter: LARCoordinateConverting?

    func attach(to mapView: MKMapView, coordinateConverter: LARCoordinateConverting) {
        self.coordinateConverter = coordinateConverter
        annotation = MKPointAnnotation()
        mapView.addAnnotation(annotation!)
    }

    func update() {
        guard let source = source, let converter = coordinateConverter else { return }
        annotation?.coordinate = converter.coordinate(from: source.position)
    }

    func detach() {
        // Remove annotation from map
    }
}
```

### Directory Structure for Dual-View Pattern

```
Sources/LocalizeAR/
├── Rendering/
│   ├── Protocols/
│   │   ├── LARSceneContentRenderer.swift
│   │   ├── LARMapContentRenderer.swift
│   │   ├── LARDualRenderer.swift
│   │   └── LARCoordinateConverting.swift
│   ├── LARRendererRegistry.swift
│   └── Base/
│       ├── LARBaseSceneRenderer.swift      # Default implementations
│       └── LARBaseMapRenderer.swift

LARExplorer/
├── Rendering/
│   ├── Persistent/                          # Always-on renderers
│   │   ├── AnchorDualRenderer.swift
│   │   ├── EdgeDualRenderer.swift
│   │   └── LandmarkDualRenderer.swift
│   └── ToolSpecific/                        # Tool-activated renderers
│       ├── SelectionHighlightRenderer.swift
│       ├── PreviewNodeRenderer.swift
│       └── LocalizationResultRenderer.swift
```

### Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| **Renderers own their nodes/overlays** | Clean lifecycle - attach creates, detach removes |
| **Registry manages concurrency** | Single point of control for all active renderers |
| **DualRenderer syncs both views** | Entity state changes update both automatically |
| **Persistent vs Tool-specific separation** | Clear ownership and lifecycle boundaries |
| **Reusable in LocalizeAR** | Other apps can use 2-view pattern without LARExplorer |

### Testing Strategy for Renderers

```swift
// Mock for testing renderer behavior
final class MockSceneContentRenderer: LARSceneContentRenderer {
    var attachCalled = false
    var detachCalled = false
    var updateCallCount = 0

    func attach(to rootNode: SCNNode) { attachCalled = true }
    func detach() { detachCalled = true }
    func update() { updateCallCount += 1 }
}

// Test DualRenderer coordinates both
@Test func dualRenderer_update_callsBothRenderers() {
    let dual = CharacterDualRenderer()
    let mockScene = MockSceneContentRenderer()
    let mockMap = MockMapContentRenderer()

    dual.sceneRenderer = mockScene
    dual.mapRenderer = mockMap

    dual.moveTo(simd_float3(1, 0, 0), heading: 0)

    #expect(mockScene.updateCallCount == 1)
    #expect(mockMap.updateCallCount == 1)
}
```

---

## Current Architecture Analysis

### Strengths

| Aspect | Details |
|--------|---------|
| **DI Foundation** | Swinject in `AppAssembly.swift` provides dependency injection |
| **Strategy Pattern** | `ToolInteractionStrategy` protocol for click handling |
| **Reference Pattern** | `LARNavigationCoordinator` in main library shows target architecture |
| **Visualization Model** | `LocalizationVisualization.State` demonstrates shared state pattern |

### Weaknesses

| Aspect | Problem |
|--------|---------|
| **ContentView** | God object (280+ lines) with 7 injected services |
| **EditingService** | Mixes domain logic with UI rendering coordination |
| **No Domain Layer** | Business logic scattered across services |
| **Untestable** | Services depend on concrete framework types (SCNView, MKMapView) |
| **State Sync** | Manual `onChange` coordination between views |
| **No Tests** | Empty test file indicates testing was not prioritized |

### Critical Files for Refactoring

1. `/LARExplorer/Views/ContentView.swift` - God object to simplify
2. `/LARExplorer/Services/EditingService.swift` - Extract to domain layer
3. `/LARExplorer/DI/AppAssembly.swift` - Extend for new architecture
4. `/LARExplorer/Services/SceneInteractionManager.swift` - Replace with tool coordinators

---

## Architecture Comparison

Three parallel plans were evaluated. See [Architecture Comparison Details](#architecture-comparison-details) in appendix.

### Summary

| Criterion | Winner | Reason |
|-----------|--------|--------|
| **Testability** | Plan C | Pure reducer functions are trivially testable |
| **Simplicity** | Plan C | Fewer layers |
| **Migration Speed** | Plan C | ~2 weeks vs 5-7 weeks |
| **Flexibility** | Plan A/B | More extension points |

### Hybrid Approach

We take the best from each:
- **From Plan C**: Action/Reducer pattern, fast migration
- **From Plan B**: Separate State and Action types
- **From Plan A**: Coordinator as orchestration layer

**Plus simplifications**:
- Shared rendering services (not per-tool)
- Reduced protocol count
- Flexible complexity per tool

---

## TDD Phase Breakdown

### Overview

```
Phase 0: Test Infrastructure (Protocols + Mocks)
    ↓
Phase 1: Domain Layer (Pure Swift TDD)
    ↓
Phase 2: Repository Layer (Integration TDD)
    ↓
Phase 3: Tool Coordinators (Unit TDD)
    ↓
Phase 4: Shared Rendering Services (Command TDD)
    ↓
Phase 5: View Layer (Compilation + Smoke Tests)
    ↓
Phase 6: End-to-End Integration (Automated)
    ↓
Phase 7: Manual UI Testing (Human Required)
```

### Test Coverage by Phase

| Phase | Test Type | AI Verifiable? | Human Needed? |
|-------|-----------|----------------|---------------|
| 0 | Compilation | ✅ Yes | ❌ No |
| 1 | Unit (reducers) | ✅ Yes | ❌ No |
| 2 | Integration (repos) | ✅ Yes | ❌ No |
| 3 | Unit (coordinators) | ✅ Yes | ❌ No |
| 4 | Unit (rendering) | ✅ Yes | ❌ No |
| 5 | Smoke (launch) | ✅ Yes | ❌ No |
| 6 | E2E (flows) | ✅ Yes | ❌ No |
| 7 | Visual (UI) | ❌ No | ✅ Yes |

**Result**: 6 out of 7 phases are fully automatable.

---

### Phase 0: Test Infrastructure

**Goal**: Establish contracts and mocks before production code.

**Deliverables**:
- Core protocol definitions (`MapRepository`, `RenderingService`)
- Mock implementations
- Test fixtures
- NO production code yet

**Verification**: `swift build` succeeds, mocks conform to protocols.

---

### Phase 1: Domain Layer (Pure Swift TDD)

**Goal**: Implement tool state and action logic with 100% test coverage.

**TDD Cycle**:
1. Write State value type
2. Write Action enum with `reduce()` (initially `fatalError`)
3. Write tests FIRST (RED)
4. Implement `reduce()` to pass tests (GREEN)
5. Refactor if needed

**Tools to Implement** (in order of complexity):
- [ ] Explore (minimal - may skip State/Action)
- [ ] Landmarks (State + minimal Actions)
- [ ] AnchorEdit (State + Actions + Tests)
- [ ] EdgeEdit (State + Actions + Tests)
- [ ] GPSAlignment (State + Actions + Tests)
- [ ] Relocalization (State + Actions + Tests)

**Verification**: `swift test --filter Domain` passes.

---

### Phase 2: Repository Layer (Integration TDD)

**Goal**: Implement LARMap adapter with integration tests.

**Deliverables**:
- `LARMapRepository` implementing `MapRepository`
- Integration tests using real LARMap with test data

**Verification**: `swift test --filter Integration` passes.

---

### Phase 3: Tool Coordinators (Unit TDD)

**Goal**: Wire up state + actions + repository with full test coverage.

**Responsibilities**:
- Dispatch actions to reducer
- Handle side effects (async operations)
- Call repository methods
- Manage tool lifecycle (activate/deactivate)
- Issue rendering commands

**Verification**: `swift test --filter Tool` passes.

---

### Phase 4: Shared Rendering Services (Command TDD)

**Goal**: Test rendering logic without actual UI.

**Key Insight**: Test that correct commands are issued, not visual results.

**Deliverables**:
- `SceneRenderingService` (shared across all tools)
- `MapRenderingService` (shared across all tools)
- Mock implementations for testing
- Tests verifying command sequences

**Verification**: `swift test --filter Rendering` passes.

---

### Phase 5: View Layer (Compilation + Smoke Tests)

**Goal**: Thin views that wire up coordinators.

**Deliverables**:
- Simplified `ContentView` (pure layout)
- `SceneContainerView` (NSViewRepresentable)
- `MapContainerView` (NSViewRepresentable)
- `InspectorContainerView`
- `ToolbarView`

**Verification**: `swift test --filter Smoke` passes, app compiles.

---

### Phase 6: End-to-End Integration (Automated)

**Goal**: Full user flows without visual verification.

**Test Scenarios**:
- Load map → Select anchors → Apply offset → Verify map updated
- Select two anchors → Create edge → Verify edge exists
- Load frame → Perform localization → Verify commands issued

**Verification**: `swift test --filter E2E` passes.

---

### Phase 7: Manual UI Testing (Human Required)

**Goal**: Visual verification and UX refinement.

**Checklist**:
- [ ] 3D scene highlights render correctly
- [ ] 2D map overlays appear in correct positions
- [ ] Inspector controls are responsive
- [ ] Transitions between tools are smooth

---

## Directory Structure

```
LARExplorer/
├── LARExplorerApp.swift
│
├── Core/
│   ├── AppCoordinator.swift            # Tool orchestration
│   ├── AppState.swift                  # Global app state (isMapLoaded, activeTool)
│   └── DI/
│       └── AppAssembly.swift           # DI registrations
│
├── Domain/
│   ├── Models/                         # Value types (pure Swift)
│   │   ├── AnchorData.swift
│   │   ├── EdgeData.swift
│   │   └── LandmarkData.swift
│   │
│   ├── Protocols/                      # Core abstractions (minimal!)
│   │   ├── MapRepository.swift         # Data access
│   │   └── RenderingService.swift      # Rendering commands
│   │
│   └── Tools/                          # Per-tool domain logic
│       ├── AnchorEdit/
│       │   └── AnchorEditState.swift   # State + Action in one file
│       ├── EdgeEdit/
│       │   └── EdgeEditState.swift
│       ├── GPSAlignment/
│       │   └── GPSAlignmentState.swift
│       ├── Relocalization/
│       │   └── RelocalizationState.swift
│       └── Landmarks/
│           └── LandmarksState.swift
│
├── Tools/                              # Tool coordinators + inspectors
│   ├── Shared/
│   │   └── ToolCoordinator.swift       # Base protocol
│   ├── Explore/
│   │   ├── ExploreTool.swift           # Minimal coordinator
│   │   └── ExploreInspector.swift
│   ├── AnchorEdit/
│   │   ├── AnchorEditTool.swift        # Coordinator
│   │   └── AnchorEditInspector.swift   # SwiftUI view
│   ├── EdgeEdit/
│   │   ├── EdgeEditTool.swift
│   │   └── EdgeEditInspector.swift
│   ├── GPSAlignment/
│   │   ├── GPSAlignmentTool.swift
│   │   └── GPSAlignmentInspector.swift
│   ├── Relocalization/
│   │   ├── RelocalizationTool.swift
│   │   └── RelocalizationInspector.swift
│   └── Landmarks/
│       ├── LandmarksTool.swift
│       └── LandmarksInspector.swift
│
├── Infrastructure/                     # Framework adapters
│   ├── LARMapRepository.swift          # Implements MapRepository
│   ├── SceneRenderingService.swift     # Shared scene rendering
│   └── MapRenderingService.swift       # Shared map rendering
│
├── Views/                              # Thin view layer
│   ├── ContentView.swift               # Pure layout
│   ├── SceneContainerView.swift        # NSViewRepresentable
│   ├── MapContainerView.swift          # NSViewRepresentable
│   ├── InspectorContainerView.swift    # Routes to tool inspectors
│   └── ToolbarView.swift
│
├── TestSupport/                        # Test utilities (separate target)
│   ├── Mocks/
│   │   ├── MockMapRepository.swift
│   │   └── MockRenderingService.swift
│   └── Fixtures/
│       └── TestData.swift
│
└── Tests/
    ├── Domain/
    │   ├── AnchorEditStateTests.swift
    │   ├── EdgeEditStateTests.swift
    │   └── ...
    ├── Tools/
    │   ├── AnchorEditToolTests.swift
    │   └── ...
    ├── Integration/
    │   └── LARMapRepositoryTests.swift
    ├── Rendering/
    │   ├── SceneRenderingServiceTests.swift
    │   └── MapRenderingServiceTests.swift
    ├── Smoke/
    │   └── AppLaunchTests.swift
    └── E2E/
        └── UserFlowTests.swift
```

### Key Simplifications

1. **State + Action in one file** - For most tools, these are small enough to coexist
2. **No per-tool renderers** - Shared `SceneRenderingService` and `MapRenderingService`
3. **Flat tool structure** - Each tool is just `*Tool.swift` + `*Inspector.swift`
4. **2 core protocols** - `MapRepository` + `RenderingService`

---

## Key Protocols

### MapRepository (Data Layer)

```swift
/// Single protocol for all map data operations
protocol MapRepository: AnyObject {
    // MARK: - State
    var isLoaded: Bool { get }
    var loadedPublisher: AnyPublisher<Bool, Never> { get }

    // MARK: - Anchors
    func anchor(id: Int32) -> AnchorData?
    func allAnchors() -> [AnchorData]
    func updateAnchorPosition(id: Int32, offset: SIMD3<Float>)
    func deleteAnchor(id: Int32)

    // MARK: - Edges
    func edges() -> [EdgeData]
    func addEdge(from: Int32, to: Int32)
    func removeEdge(from: Int32, to: Int32)

    // MARK: - Landmarks
    func landmarks() -> [LandmarkData]
    func landmark(id: Int) -> LandmarkData?

    // MARK: - Origin & Alignment
    func origin() -> simd_float4x4
    func updateOrigin(_ transform: simd_float4x4)

    // MARK: - Persistence
    func load(from url: URL) async throws
    func save() throws
}
```

### RenderingService (Presentation Layer)

```swift
/// Unified rendering commands for both Scene and Map views
protocol RenderingService: AnyObject {
    // MARK: - Scene Rendering
    func highlightAnchors(_ ids: Set<Int32>, style: HighlightStyle)
    func clearAnchorHighlights()
    func showPreviewNodes(at positions: [Int32: SIMD3<Float>])
    func hidePreviewNodes()
    func highlightLandmarks(_ ids: Set<Int>, style: HighlightStyle)
    func clearLandmarkHighlights()

    // MARK: - Map Rendering
    func showBoundsOverlay(lower: SIMD2<Double>, upper: SIMD2<Double>)
    func clearBoundsOverlays()
    func refreshMapOverlays()

    // MARK: - Shared
    func refreshAll()
}

enum HighlightStyle {
    case selected       // User-selected items
    case preview        // Preview of pending changes
    case spatialQuery   // Landmarks in spatial query range
    case matched        // Successfully matched landmarks
    case inlier         // Inlier landmarks after RANSAC
}
```

### ToolCoordinator (Base Protocol)

```swift
/// Base protocol for all tool coordinators
protocol ToolCoordinator: AnyObject, ObservableObject {
    /// Called when this tool becomes active
    func activate()

    /// Called when switching to another tool
    func deactivate()

    /// Handle click in scene view
    func handleSceneClick(at point: CGPoint, hitAnchorId: Int32?)

    /// Handle click in map view (optional)
    func handleMapClick(at coordinate: CLLocationCoordinate2D)
}

extension ToolCoordinator {
    // Default implementation - most tools don't need map clicks
    func handleMapClick(at coordinate: CLLocationCoordinate2D) {}
}
```

---

## Code Examples

### State + Action Example (Combined File)

```swift
// Domain/Tools/AnchorEdit/AnchorEditState.swift

import simd

// MARK: - State

struct AnchorEditState: Equatable {
    var selectedAnchorIds: Set<Int32> = []
    var positionOffset: SIMD3<Float> = .zero
    var isPreviewingOffset: Bool = false

    static let initial = AnchorEditState()

    // Computed
    var hasSelection: Bool { !selectedAnchorIds.isEmpty }
    var hasOffset: Bool { positionOffset != .zero }
    var canApplyOffset: Bool { hasSelection && hasOffset }
}

// MARK: - Actions

enum AnchorEditAction: Equatable {
    // Selection
    case toggleSelection(id: Int32)
    case clearSelection

    // Offset
    case setOffset(SIMD3<Float>)
    case setPreviewingOffset(Bool)

    // Side effects (handled by coordinator)
    case applyOffset
    case deleteSelected
}

// MARK: - Reducer

extension AnchorEditAction {
    func reduce(_ state: AnchorEditState) -> AnchorEditState {
        var new = state

        switch self {
        case .toggleSelection(let id):
            if new.selectedAnchorIds.contains(id) {
                new.selectedAnchorIds.remove(id)
            } else {
                new.selectedAnchorIds.insert(id)
            }

        case .clearSelection:
            new.selectedAnchorIds.removeAll()
            new.isPreviewingOffset = false

        case .setOffset(let offset):
            new.positionOffset = offset

        case .setPreviewingOffset(let previewing):
            new.isPreviewingOffset = previewing

        case .applyOffset, .deleteSelected:
            // Side effects - state unchanged, coordinator handles
            break
        }

        return new
    }
}
```

### Tool Coordinator Example

```swift
// Tools/AnchorEdit/AnchorEditTool.swift

import Combine

@MainActor
final class AnchorEditTool: ToolCoordinator, ObservableObject {
    @Published private(set) var state = AnchorEditState.initial

    private let mapRepository: MapRepository
    private let renderingService: RenderingService

    init(mapRepository: MapRepository, renderingService: RenderingService) {
        self.mapRepository = mapRepository
        self.renderingService = renderingService
    }

    // MARK: - ToolCoordinator

    func activate() {
        state = .initial
        updateRendering()
    }

    func deactivate() {
        state = .initial
        renderingService.clearAnchorHighlights()
        renderingService.hidePreviewNodes()
    }

    func handleSceneClick(at point: CGPoint, hitAnchorId: Int32?) {
        guard let anchorId = hitAnchorId else { return }
        dispatch(.toggleSelection(id: anchorId))
    }

    // MARK: - Actions

    func dispatch(_ action: AnchorEditAction) {
        state = action.reduce(state)
        updateRendering()

        Task { await handleSideEffect(action) }
    }

    // MARK: - Private

    private func updateRendering() {
        // Update highlights
        if state.hasSelection {
            renderingService.highlightAnchors(state.selectedAnchorIds, style: .selected)
        } else {
            renderingService.clearAnchorHighlights()
        }

        // Update preview
        if state.isPreviewingOffset && state.hasOffset {
            let positions = calculatePreviewPositions()
            renderingService.showPreviewNodes(at: positions)
        } else {
            renderingService.hidePreviewNodes()
        }
    }

    private func calculatePreviewPositions() -> [Int32: SIMD3<Float>] {
        var result: [Int32: SIMD3<Float>] = [:]
        for id in state.selectedAnchorIds {
            if let anchor = mapRepository.anchor(id: id) {
                result[id] = anchor.position + state.positionOffset
            }
        }
        return result
    }

    private func handleSideEffect(_ action: AnchorEditAction) async {
        switch action {
        case .applyOffset:
            guard state.canApplyOffset else { return }
            for id in state.selectedAnchorIds {
                mapRepository.updateAnchorPosition(id: id, offset: state.positionOffset)
            }
            renderingService.refreshAll()
            dispatch(.clearSelection)
            dispatch(.setOffset(.zero))

        case .deleteSelected:
            for id in state.selectedAnchorIds {
                mapRepository.deleteAnchor(id: id)
            }
            renderingService.refreshAll()
            dispatch(.clearSelection)

        default:
            break
        }
    }
}
```

### Test Example

```swift
// Tests/Domain/AnchorEditStateTests.swift

import Testing
@testable import LARExplorer

struct AnchorEditStateTests {

    // MARK: - Selection Tests

    @Test func toggleSelection_addsWhenNotPresent() {
        let state = AnchorEditState.initial
        let action = AnchorEditAction.toggleSelection(id: 1)

        let new = action.reduce(state)

        #expect(new.selectedAnchorIds.contains(1))
    }

    @Test func toggleSelection_removesWhenPresent() {
        var state = AnchorEditState.initial
        state.selectedAnchorIds = [1, 2, 3]

        let new = AnchorEditAction.toggleSelection(id: 2).reduce(state)

        #expect(new.selectedAnchorIds == [1, 3])
    }

    @Test func clearSelection_emptiesSetAndDisablesPreview() {
        var state = AnchorEditState.initial
        state.selectedAnchorIds = [1, 2]
        state.isPreviewingOffset = true

        let new = AnchorEditAction.clearSelection.reduce(state)

        #expect(new.selectedAnchorIds.isEmpty)
        #expect(!new.isPreviewingOffset)
    }

    // MARK: - Offset Tests

    @Test func setOffset_updatesValue() {
        let state = AnchorEditState.initial
        let offset = SIMD3<Float>(1, 2, 3)

        let new = AnchorEditAction.setOffset(offset).reduce(state)

        #expect(new.positionOffset == offset)
    }

    // MARK: - Computed Properties

    @Test func canApplyOffset_requiresBoth() {
        var state = AnchorEditState.initial
        #expect(!state.canApplyOffset)

        state.selectedAnchorIds = [1]
        #expect(!state.canApplyOffset)

        state.positionOffset = SIMD3(1, 0, 0)
        #expect(state.canApplyOffset)
    }
}
```

### Tool Coordinator Test Example

```swift
// Tests/Tools/AnchorEditToolTests.swift

import Testing
@testable import LARExplorer

@MainActor
struct AnchorEditToolTests {

    @Test func dispatch_toggleSelection_updatesStateAndRendering() {
        let mockRepo = MockMapRepository()
        let mockRendering = MockRenderingService()
        let tool = AnchorEditTool(mapRepository: mockRepo, renderingService: mockRendering)

        tool.dispatch(.toggleSelection(id: 42))

        #expect(tool.state.selectedAnchorIds.contains(42))
        #expect(mockRendering.highlightAnchorsCalls.last?.ids == [42])
    }

    @Test func dispatch_applyOffset_updatesRepository() async {
        let mockRepo = MockMapRepository()
        mockRepo.stubbedAnchors[1] = AnchorData(id: 1, position: .zero)
        mockRepo.stubbedAnchors[2] = AnchorData(id: 2, position: .zero)

        let mockRendering = MockRenderingService()
        let tool = AnchorEditTool(mapRepository: mockRepo, renderingService: mockRendering)

        // Setup
        tool.dispatch(.toggleSelection(id: 1))
        tool.dispatch(.toggleSelection(id: 2))
        tool.dispatch(.setOffset(SIMD3(1, 0, 0)))

        // Action
        tool.dispatch(.applyOffset)
        try await Task.sleep(nanoseconds: 50_000_000)

        // Verify
        #expect(mockRepo.updateAnchorPositionCalls.count == 2)
        #expect(tool.state.selectedAnchorIds.isEmpty)
    }

    @Test func activate_resetsState() {
        let mockRepo = MockMapRepository()
        let mockRendering = MockRenderingService()
        let tool = AnchorEditTool(mapRepository: mockRepo, renderingService: mockRendering)

        tool.dispatch(.toggleSelection(id: 1))
        tool.activate()

        #expect(tool.state == .initial)
    }

    @Test func deactivate_clearsRendering() {
        let mockRepo = MockMapRepository()
        let mockRendering = MockRenderingService()
        let tool = AnchorEditTool(mapRepository: mockRepo, renderingService: mockRendering)

        tool.deactivate()

        #expect(mockRendering.clearAnchorHighlightsCalled)
        #expect(mockRendering.hidePreviewNodesCalled)
    }
}
```

### Mock Example

```swift
// TestSupport/Mocks/MockRenderingService.swift

final class MockRenderingService: RenderingService {
    // Call recording
    var highlightAnchorsCalls: [(ids: Set<Int32>, style: HighlightStyle)] = []
    var clearAnchorHighlightsCalled = false
    var showPreviewNodesCalls: [[Int32: SIMD3<Float>]] = []
    var hidePreviewNodesCalled = false
    var refreshAllCalled = false

    func highlightAnchors(_ ids: Set<Int32>, style: HighlightStyle) {
        highlightAnchorsCalls.append((ids, style))
    }

    func clearAnchorHighlights() {
        clearAnchorHighlightsCalled = true
    }

    func showPreviewNodes(at positions: [Int32: SIMD3<Float>]) {
        showPreviewNodesCalls.append(positions)
    }

    func hidePreviewNodes() {
        hidePreviewNodesCalled = true
    }

    func highlightLandmarks(_ ids: Set<Int>, style: HighlightStyle) {}
    func clearLandmarkHighlights() {}
    func showBoundsOverlay(lower: SIMD2<Double>, upper: SIMD2<Double>) {}
    func clearBoundsOverlays() {}
    func refreshMapOverlays() {}

    func refreshAll() {
        refreshAllCalled = true
    }

    func reset() {
        highlightAnchorsCalls.removeAll()
        clearAnchorHighlightsCalled = false
        showPreviewNodesCalls.removeAll()
        hidePreviewNodesCalled = false
        refreshAllCalled = false
    }
}
```

---

## Testing Strategy

### Test Types by Phase

| Phase | Target | Dependencies | Speed | Example Command |
|-------|--------|--------------|-------|-----------------|
| 1 | Reducers | None | ms | `swift test --filter Domain` |
| 2 | Repository | Real LARMap | s | `swift test --filter Integration` |
| 3 | Coordinators | Mocks | ms | `swift test --filter Tool` |
| 4 | Rendering | Mocks | ms | `swift test --filter Rendering` |
| 5 | App launch | Full app | s | `swift test --filter Smoke` |
| 6 | User flows | Real + mocks | s | `swift test --filter E2E` |

### Running All Tests

```bash
# Full test suite
swift test

# Specific phase
swift test --filter Domain
swift test --filter Tool
swift test --filter E2E
```

---

## Migration Checklist

### Phase 0: Test Infrastructure
- [ ] Define `MapRepository` protocol
- [ ] Define `RenderingService` protocol
- [ ] Define `ToolCoordinator` protocol
- [ ] Implement `MockMapRepository`
- [ ] Implement `MockRenderingService`
- [ ] Create test fixtures

### Phase 1: Domain Layer
- [ ] Create `Domain/Models/` value types
- [ ] Implement `AnchorEditState` (TDD)
- [ ] Implement `EdgeEditState` (TDD)
- [ ] Implement `GPSAlignmentState` (TDD)
- [ ] Implement `RelocalizationState` (TDD)
- [ ] Implement `LandmarksState` (TDD)

### Phase 2: Repository Layer
- [ ] Implement `LARMapRepository`
- [ ] Write integration tests

### Phase 3: Tool Coordinators
- [ ] Implement `ExploreTool` (minimal)
- [ ] Implement `AnchorEditTool` (TDD)
- [ ] Implement `EdgeEditTool` (TDD)
- [ ] Implement `GPSAlignmentTool` (TDD)
- [ ] Implement `RelocalizationTool` (TDD)
- [ ] Implement `LandmarksTool` (TDD)

### Phase 4: Rendering Services
- [ ] Implement `SceneRenderingService`
- [ ] Implement `MapRenderingService`
- [ ] Write rendering tests

### Phase 5: View Layer
- [ ] Refactor `ContentView`
- [ ] Create view containers
- [ ] Create tool inspectors
- [ ] Write smoke tests

### Phase 6: E2E Integration
- [ ] Write user flow tests
- [ ] Verify all tests pass

### Phase 7: Manual Testing
- [ ] Visual verification per tool
- [ ] UX polish

---

## Notes for Refinement

> Areas that may need further discussion

1. **Error Handling**: How do side effects report errors to UI?
2. **Loading States**: Should tools have explicit loading states?
3. **Undo/Redo**: Consider action history for undo support
4. **LARNavigationCoordinator**: Integration strategy with existing code

---

## Appendix

### Architecture Comparison Details

Three parallel plans were evaluated:

| Aspect | **Plan A** | **Plan B** | **Plan C** |
|--------|-----------|-----------|-----------|
| **Pattern** | Coordinator + Presenter | Coordinator + UseCase | Action/Reducer |
| **State** | `@Published` object | State + Action + UseCase | State + Action in coordinator |
| **Migration** | 5 weeks | 7 weeks | ~2 weeks |

---

## References

- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture)
- [LARNavigationCoordinator](/Sources/LocalizeAR/Navigation/LARNavigationCoordinator.swift)
- [Current ARCHITECTURE.md](/Examples/LARExplorer/ARCHITECTURE.md)