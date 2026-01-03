//
//  CoordinatorStrategy.swift
//  LARExplorer
//
//  Created by Claude Code on 2026-01-04.
//

import Foundation
import SceneKit

/// Adapter that bridges ToolCoordinator to ToolInteractionStrategy
///
/// This adapter allows any ToolCoordinator to be used where a ToolInteractionStrategy
/// is expected. It performs hit testing on scene clicks and delegates the results
/// to the coordinator's handleSceneClick method.
///
/// Design Pattern: Adapter
/// - Wraps a ToolCoordinator (new architecture)
/// - Implements ToolInteractionStrategy (existing architecture)
/// - Enables gradual migration without breaking existing code
@MainActor
final class CoordinatorStrategy<C: ToolCoordinator>: ToolInteractionStrategy {

    // MARK: - Dependencies

    private let coordinator: C
    private let hitTestManager = HitTestManager()

    // MARK: - Initialization

    init(coordinator: C) {
        self.coordinator = coordinator
    }

    // MARK: - ToolInteractionStrategy

    func handleClick(at location: NSPoint, in sceneView: SCNView) {
        // Perform hit test to determine what was clicked
        let result = hitTestManager.performHitTest(at: location, in: sceneView)

        // Extract anchor and landmark IDs from result
        var hitAnchorId: Int32? = nil
        var hitLandmarkId: Int? = nil

        if let result = result {
            switch result.type {
            case .anchor(let id):
                hitAnchorId = id
            case .landmark(let index):
                hitLandmarkId = index
            case .none:
                break
            }
        }

        // Delegate to coordinator with extracted information
        coordinator.handleSceneClick(
            at: CGPoint(x: location.x, y: location.y),
            hitAnchorId: hitAnchorId,
            hitLandmarkId: hitLandmarkId
        )
    }

    func activate() {
        coordinator.activate()
    }

    func deactivate() {
        coordinator.deactivate()
    }
}
