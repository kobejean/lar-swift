//
//  ToolInteractionStrategy.swift
//  LARExplorer
//
//  Created by Assistant on 2025-09-19.
//

import Foundation
import SceneKit

/// Protocol defining how different tools handle scene interactions
protocol ToolInteractionStrategy {
    /// Handle a click at the given location
    func handleClick(at location: NSPoint, in sceneView: SCNView)

    /// Called when this strategy becomes active
    func activate()

    /// Called when this strategy becomes inactive
    func deactivate()
}

/// Default implementation for optional methods
extension ToolInteractionStrategy {
    func activate() {}
    func deactivate() {}
}