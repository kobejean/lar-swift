//
//  EdgeEditingStrategy.swift
//  LARExplorer
//
//  Created by Assistant on 2025-09-19.
//

import Foundation
import SceneKit

/// Strategy for creating edges between anchors
@MainActor
class EdgeEditingStrategy: ToolInteractionStrategy {
    private let editingService: EditingService
    private let hitTestManager = HitTestManager()

    init(editingService: EditingService) {
        self.editingService = editingService
    }

    func handleClick(at location: NSPoint, in sceneView: SCNView) {
        guard let result = hitTestManager.performHitTest(at: location, in: sceneView) else {
            return
        }

        // Only handle anchor selections for edge creation
        if case .anchor(let anchorId) = result.type {
            editingService.handleAnchorClickForEdgeCreation(anchorId)
        }
    }
}