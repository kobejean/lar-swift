//
//  SceneRenderingAdapter.swift
//  LARExplorer
//
//  Created by Claude Code on 2026-01-04.
//

import Foundation
import SceneKit
import simd

/// Protocol for scene-specific rendering operations
/// Allows decoupling from concrete SCNView for testing
@MainActor
protocol SceneRendering: AnyObject {
    /// Highlight anchors with a specific style
    func highlightAnchors(_ ids: Set<Int32>, style: HighlightStyle)

    /// Clear all anchor highlights
    func clearAnchorHighlights()

    /// Show preview nodes at specified positions
    func showPreviewNodes(at positions: [Int32: SIMD3<Float>])

    /// Hide all preview nodes
    func hidePreviewNodes()

    /// Highlight landmarks with a specific style
    func highlightLandmarks(_ ids: Set<Int>, style: HighlightStyle)

    /// Clear all landmark highlights
    func clearLandmarkHighlights()

    /// Refresh the scene
    func refresh()

    /// Set point cloud visibility
    func setPointCloudVisible(_ visible: Bool)

    /// Set navigation nodes visibility
    func setNavigationNodesVisible(_ visible: Bool)

    /// Set navigation edges visibility
    func setNavigationEdgesVisible(_ visible: Bool)
}

/// Adapter that implements scene rendering by delegating to an SCNView
@MainActor
final class SceneRenderingAdapter: SceneRendering {
    // MARK: - Properties

    private weak var sceneView: SCNView?
    private var anchorHighlightNodes: [Int32: SCNNode] = [:]
    private var previewNodes: [Int32: SCNNode] = [:]
    private var landmarkHighlightNodes: [Int: SCNNode] = [:]

    // MARK: - Color Constants

    private static let selectedColor = NSColor.systemBlue
    private static let previewColor = NSColor.systemGreen.withAlphaComponent(0.6)
    private static let spatialQueryColor = NSColor.systemYellow
    private static let matchedColor = NSColor.systemOrange
    private static let inlierColor = NSColor.systemGreen

    // MARK: - Initialization

    init(sceneView: SCNView? = nil) {
        self.sceneView = sceneView
    }

    func configure(sceneView: SCNView) {
        self.sceneView = sceneView
    }

    // MARK: - SceneRendering

    func highlightAnchors(_ ids: Set<Int32>, style: HighlightStyle) {
        clearAnchorHighlights()

        guard let scene = sceneView?.scene else { return }

        for id in ids {
            // Find the anchor node by name convention
            if let anchorNode = scene.rootNode.childNode(withName: "anchor_\(id)", recursively: true) {
                let highlightNode = createHighlightNode(for: anchorNode, style: style)
                anchorNode.addChildNode(highlightNode)
                anchorHighlightNodes[id] = highlightNode
            }
        }
    }

    func clearAnchorHighlights() {
        for (_, node) in anchorHighlightNodes {
            node.removeFromParentNode()
        }
        anchorHighlightNodes.removeAll()
    }

    func showPreviewNodes(at positions: [Int32: SIMD3<Float>]) {
        hidePreviewNodes()

        guard let scene = sceneView?.scene else { return }

        for (id, position) in positions {
            let previewNode = createPreviewNode(at: position)
            previewNode.name = "preview_\(id)"
            scene.rootNode.addChildNode(previewNode)
            previewNodes[id] = previewNode
        }
    }

    func hidePreviewNodes() {
        for (_, node) in previewNodes {
            node.removeFromParentNode()
        }
        previewNodes.removeAll()
    }

    func highlightLandmarks(_ ids: Set<Int>, style: HighlightStyle) {
        clearLandmarkHighlights()

        guard let scene = sceneView?.scene else { return }

        for id in ids {
            if let landmarkNode = scene.rootNode.childNode(withName: "landmark_\(id)", recursively: true) {
                let highlightNode = createHighlightNode(for: landmarkNode, style: style)
                landmarkNode.addChildNode(highlightNode)
                landmarkHighlightNodes[id] = highlightNode
            }
        }
    }

    func clearLandmarkHighlights() {
        for (_, node) in landmarkHighlightNodes {
            node.removeFromParentNode()
        }
        landmarkHighlightNodes.removeAll()
    }

    func refresh() {
        sceneView?.setNeedsDisplay(sceneView?.bounds ?? .zero)
    }

    func setPointCloudVisible(_ visible: Bool) {
        guard let scene = sceneView?.scene else { return }
        scene.rootNode.childNode(withName: "pointCloud", recursively: true)?.isHidden = !visible
    }

    func setNavigationNodesVisible(_ visible: Bool) {
        guard let scene = sceneView?.scene else { return }
        scene.rootNode.childNode(withName: "navigationNodes", recursively: true)?.isHidden = !visible
    }

    func setNavigationEdgesVisible(_ visible: Bool) {
        guard let scene = sceneView?.scene else { return }
        scene.rootNode.childNode(withName: "navigationEdges", recursively: true)?.isHidden = !visible
    }

    // MARK: - Private Helpers

    private func createHighlightNode(for targetNode: SCNNode, style: HighlightStyle) -> SCNNode {
        let color = colorForStyle(style)

        // Create a sphere highlight around the node
        let sphere = SCNSphere(radius: 0.15)
        sphere.firstMaterial?.diffuse.contents = color.withAlphaComponent(0.4)
        sphere.firstMaterial?.isDoubleSided = true

        let highlightNode = SCNNode(geometry: sphere)
        highlightNode.name = "highlight"

        return highlightNode
    }

    private func createPreviewNode(at position: SIMD3<Float>) -> SCNNode {
        let sphere = SCNSphere(radius: 0.1)
        sphere.firstMaterial?.diffuse.contents = Self.previewColor

        let node = SCNNode(geometry: sphere)
        node.simdPosition = position

        return node
    }

    private func colorForStyle(_ style: HighlightStyle) -> NSColor {
        switch style {
        case .selected:
            return Self.selectedColor
        case .preview:
            return Self.previewColor
        case .spatialQuery:
            return Self.spatialQueryColor
        case .matched:
            return Self.matchedColor
        case .inlier:
            return Self.inlierColor
        }
    }
}
