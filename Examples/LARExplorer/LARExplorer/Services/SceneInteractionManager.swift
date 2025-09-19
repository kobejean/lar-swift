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
    private let explorerViewModel: LARExplorerViewModel

    // Strategies
    private var strategies: [ExplorerTool: ToolInteractionStrategy] = [:]
    private var currentStrategy: ToolInteractionStrategy?

    @Published var selectedTool: ExplorerTool = .explore {
        didSet {
            switchToTool(selectedTool)
        }
    }

    init(editingService: EditingService,
         landmarkInspectionService: LandmarkInspectionService,
         explorerViewModel: LARExplorerViewModel) {
        self.editingService = editingService
        self.landmarkInspectionService = landmarkInspectionService
        self.explorerViewModel = explorerViewModel

        // Initialize strategies for each tool
        strategies[.explore] = ExploreStrategy()
        strategies[.editAnchors] = AnchorEditingStrategy(editingService: editingService)
        strategies[.editEdges] = EdgeEditingStrategy(editingService: editingService)
        strategies[.alignGPS] = ExploreStrategy() // GPS alignment doesn't need click handling
        strategies[.testRelocalization] = ExploreStrategy() // Test relocalization doesn't need click handling
        strategies[.inspectLandmarks] = LandmarkInspectionStrategy(
            landmarkInspectionService: landmarkInspectionService,
            explorerViewModel: explorerViewModel
        )

        // Set initial strategy
        switchToTool(selectedTool)
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