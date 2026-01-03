//
//  SceneInteractionManager.swift
//  LARExplorer
//
//  Created by Assistant on 2025-09-19.
//

import Foundation
import SceneKit
import LocalizeAR

/// Manages scene interactions and delegates to appropriate strategies
@MainActor
class SceneInteractionManager: ObservableObject {
    // Services
    private let editingService: EditingService
    private let landmarkInspectionService: LandmarkInspectionService
    private let mapService: MapService

    // Strategies
    private var strategies: [ExplorerTool: ToolInteractionStrategy] = [:]
    private var currentStrategy: ToolInteractionStrategy?

    // New architecture coordinator (optional - used when configured)
    private var anchorEditCoordinator: AnchorEditCoordinator?

    @Published var selectedTool: ExplorerTool = .explore {
        didSet {
            switchToTool(selectedTool)
        }
    }

    init(editingService: EditingService,
         landmarkInspectionService: LandmarkInspectionService,
         mapService: MapService) {
        self.editingService = editingService
        self.landmarkInspectionService = landmarkInspectionService
        self.mapService = mapService

        // Initialize strategies for each tool (legacy approach)
        strategies[.explore] = ExploreStrategy()
        strategies[.editAnchors] = AnchorEditingStrategy(editingService: editingService)
        strategies[.editEdges] = EdgeEditingStrategy(editingService: editingService)
        strategies[.alignGPS] = ExploreStrategy() // GPS alignment doesn't need click handling
        strategies[.testRelocalization] = ExploreStrategy() // Test relocalization doesn't need click handling
        strategies[.inspectLandmarks] = LandmarkInspectionStrategy(
            landmarkInspectionService: landmarkInspectionService,
            mapService: mapService
        )

        // Set initial strategy
        switchToTool(selectedTool)
    }

    /// Configure with new architecture coordinator
    /// This replaces the legacy strategy for anchor editing
    func configureCoordinator(_ coordinator: AnchorEditCoordinator) {
        self.anchorEditCoordinator = coordinator

        // Replace the legacy anchor editing strategy with coordinator-based strategy
        strategies[.editAnchors] = CoordinatorStrategy(coordinator: coordinator)

        // If anchor editing is currently active, switch to the new strategy
        if selectedTool == .editAnchors {
            switchToTool(selectedTool)
        }
    }

    /// Handle click events by delegating to current strategy
    func handleClick(at location: NSPoint, in sceneView: SCNView) {
        currentStrategy?.handleClick(at: location, in: sceneView)
    }

    /// Switch to a different tool/strategy
    private func switchToTool(_ tool: ExplorerTool) {
        // Deactivate current strategy
        currentStrategy?.deactivate()

        // Switch to new strategy
        currentStrategy = strategies[tool]

        // Activate new strategy
        currentStrategy?.activate()
    }
}