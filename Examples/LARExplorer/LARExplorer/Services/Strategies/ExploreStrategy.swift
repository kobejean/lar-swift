//
//  ExploreStrategy.swift
//  LARExplorer
//
//  Created by Assistant on 2025-09-19.
//

import Foundation
import SceneKit

/// Default strategy for explore mode - no special interactions
@MainActor
class ExploreStrategy: ToolInteractionStrategy {
    func handleClick(at location: NSPoint, in sceneView: SCNView) {
        // No special handling in explore mode
        // Camera controls are handled by SceneKit
    }
}