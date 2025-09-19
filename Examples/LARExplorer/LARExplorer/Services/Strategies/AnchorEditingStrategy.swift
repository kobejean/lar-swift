//
//  AnchorEditingStrategy.swift
//  LARExplorer
//
//  Created by Assistant on 2025-09-19.
//

import Foundation
import SceneKit

/// Strategy for editing anchors
@MainActor
class AnchorEditingStrategy: ToolInteractionStrategy {
    private let editingService: EditingService
    private let hitTestManager = HitTestManager()

    init(editingService: EditingService) {
        self.editingService = editingService
    }

    func handleClick(at location: NSPoint, in sceneView: SCNView) {
        guard let result = hitTestManager.performHitTest(at: location, in: sceneView) else {
            return
        }

        // Only handle anchor selections
        if case .anchor(let anchorId) = result.type {
            editingService.selectAnchor(id: anchorId)
        }
    }
}