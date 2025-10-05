//
//  LARSceneRendering.swift
//  LocalizeAR
//
//  Created by Assistant on 2025-10-05.
//

import Foundation
import SceneKit
import LocalizeAR_ObjC

/// Protocol defining SceneKit rendering operations for navigation elements
public protocol LARSceneRendering: AnyObject {
    /// Configure the renderer with a root SceneKit node
    func configure(with sceneNode: SCNNode)

    /// Add a visual node for a navigation anchor
    /// - Parameter anchor: The anchor to visualize
    func addAnchorNode(for anchor: LARAnchor)

    /// Update the transform of an existing anchor node
    /// - Parameters:
    ///   - anchorId: ID of the anchor to update
    ///   - transform: New transform matrix
    func updateAnchorNode(anchorId: Int32, transform: simd_float4x4)

    /// Remove an anchor node from the scene
    /// - Parameter anchorId: ID of the anchor to remove
    func removeAnchorNode(anchorId: Int32)

    /// Add guide nodes along an edge between two anchors
    /// - Parameters:
    ///   - fromPosition: Starting position
    ///   - toPosition: Ending position
    func addEdgeGuideNodes(from fromPosition: simd_float3, to toPosition: simd_float3)

    /// Highlight an anchor node (selection state)
    /// - Parameter anchorId: ID of the anchor to highlight
    func highlightAnchor(anchorId: Int32)

    /// Remove highlight from an anchor node
    /// - Parameter anchorId: ID of the anchor to unhighlight
    func unhighlightAnchor(anchorId: Int32)

    /// Clear all highlights
    func clearAllHighlights()

    /// Show preview nodes at specified positions
    /// - Parameter positions: Array of (anchor ID, preview position) tuples
    func showPreviewNodes(_ positions: [(id: Int32, position: simd_float3)])

    /// Hide all preview nodes
    func hidePreviewNodes()

    /// Remove all guide nodes (spheres between anchors)
    func removeAllGuideNodes()

    /// Remove all navigation elements from the scene
    func removeAllNavigationElements()

    /// Get an anchor node by ID
    /// - Parameter anchorId: ID of the anchor
    /// - Returns: The SceneKit node, or nil if not found
    func getAnchorNode(anchorId: Int32) -> LARSCNAnchorNode?
}