//
//  HitTestManager.swift
//  LARExplorer
//
//  Created by Assistant on 2025-09-19.
//

import Foundation
import SceneKit
import LocalizeAR

/// Manages hit testing for different selectable objects in the scene
@MainActor
class HitTestManager {

    /// Perform hit test and return the selection result
    func performHitTest(at location: NSPoint, in sceneView: SCNView) -> SelectionResult? {
        // Try anchor hit test first (highest priority)
        if let anchorResult = hitTestAnchors(at: location, in: sceneView) {
            return anchorResult
        }

        // Then try landmark hit test
        if let landmarkResult = hitTestLandmarks(at: location, in: sceneView) {
            return landmarkResult
        }

        return nil
    }

    /// Hit test specifically for anchors
    func hitTestAnchors(at location: NSPoint, in sceneView: SCNView) -> SelectionResult? {
        let hitTestOptions: [SCNHitTestOption: Any] = [
            .categoryBitMask: LARSCNAnchorNode.anchorCategory,
            .firstFoundOnly: true
        ]

        let hitResults = sceneView.hitTest(location, options: hitTestOptions)

        if let hitResult = hitResults.first,
           let anchorNode = hitResult.node as? LARSCNAnchorNode {
            return SelectionResult(
                type: .anchor(id: anchorNode.anchorId),
                node: anchorNode,
                worldCoordinates: hitResult.worldCoordinates
            )
        }

        return nil
    }

    /// Hit test specifically for landmarks
    func hitTestLandmarks(at location: NSPoint, in sceneView: SCNView) -> SelectionResult? {
        let hitTestOptions: [SCNHitTestOption: Any] = [
            .categoryBitMask: PointCloudRenderer.landmarkHitTestCategory,
            .firstFoundOnly: true
        ]

        let hitResults = sceneView.hitTest(location, options: hitTestOptions)

        if let hitResult = hitResults.first,
           let nodeName = hitResult.node.name,
           nodeName.hasPrefix("landmark_") {

            // Extract landmark index from node name
            let indexString = String(nodeName.dropFirst("landmark_".count))
            if let landmarkIndex = Int(indexString) {
                return SelectionResult(
                    type: .landmark(index: landmarkIndex),
                    node: hitResult.node,
                    worldCoordinates: hitResult.worldCoordinates
                )
            }
        }

        return nil
    }
}