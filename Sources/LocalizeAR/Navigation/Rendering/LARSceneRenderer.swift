//
//  LARSceneRenderer.swift
//  LocalizeAR
//
//  Created by Jean Atsumi Flaherty on 2025-10-05.
//

import Foundation
import SceneKit
import LocalizeAR_ObjC

#if canImport(UIKit)
import UIKit
private typealias PlatformColor = UIColor
#elseif canImport(AppKit)
import AppKit
private typealias PlatformColor = NSColor
#endif

/// Handles all SceneKit rendering operations for navigation elements
public class LARSceneRenderer: LARSceneRendering {
    // MARK: - Configuration
    private struct Constants {
        static let guideNodeRadius: CGFloat = 0.05
        static let guideNodeStepLength: Float = 0.5
        static let guideNodeColor = PlatformColor.systemBlue
        static let previewNodeRadius: CGFloat = 0.15
        static let previewLineRadius: CGFloat = 0.02
    }

    // MARK: - Properties
    private weak var rootNode: SCNNode?
    private var anchorNodes = LARSCNNodeCollection()
    private var previewNodes: [Int32: SCNNode] = [:]

    // Reusable guide node template (lazy to avoid Metal initialization in tests)
    private lazy var guideNodeTemplate: SCNNode = {
        let node = SCNNode()
        let geometry = SCNSphere(radius: Constants.guideNodeRadius)
        geometry.firstMaterial?.diffuse.contents = Constants.guideNodeColor
        node.geometry = geometry
        return node
    }()

    // MARK: - Initialization
    public init() {}

    // MARK: - LARSceneRendering Protocol

    public func configure(with sceneNode: SCNNode) {
        self.rootNode = sceneNode
    }

    public func addAnchorNode(for anchor: LARAnchor) {
        guard let rootNode = rootNode else { return }

        let node = LARSCNAnchorNode.create(anchorId: anchor.id)
        node.transform = SCNMatrix4(anchor.transform)
        anchorNodes.add(node)
        rootNode.addChildNode(node)
    }

    public func updateAnchorNode(anchorId: Int32, transform: simd_float4x4) {
        guard let node = anchorNodes.nodeById[anchorId] else { return }
        node.simdTransform = transform
    }

    public func removeAnchorNode(anchorId: Int32) {
        anchorNodes.nodeById[anchorId]?.removeFromParentNode()
        anchorNodes.remove(withId: anchorId)
    }

    public func addEdgeGuideNodes(from fromPosition: simd_float3, to toPosition: simd_float3) {
        guard let rootNode = rootNode else { return }

        let positions = calculateGuideNodePositions(from: fromPosition, to: toPosition)

        for position in positions {
            let guide = guideNodeTemplate.copy() as! SCNNode
            guide.simdPosition = position
            rootNode.addChildNode(guide)
        }
    }

    public func highlightAnchor(anchorId: Int32) {
        anchorNodes.nodeById[anchorId]?.isSelected = true
    }

    public func unhighlightAnchor(anchorId: Int32) {
        anchorNodes.nodeById[anchorId]?.isSelected = false
    }

    public func clearAllHighlights() {
        for (_, node) in anchorNodes.nodeById {
            node.isSelected = false
        }
    }

    public func showPreviewNodes(_ positions: [(id: Int32, position: simd_float3)]) {
        hidePreviewNodes() // Clear existing previews

        guard let rootNode = rootNode else { return }

        for (anchorId, previewPosition) in positions {
            // Create semi-transparent preview node
            let previewNode = createPreviewNode()
            previewNode.simdPosition = previewPosition
            rootNode.addChildNode(previewNode)
            previewNodes[anchorId] = previewNode

            // Create connecting line from current to preview position
            if let currentNode = anchorNodes.nodeById[anchorId] {
                let lineNode = createPreviewLine(from: currentNode.simdPosition, to: previewPosition)
                rootNode.addChildNode(lineNode)
                // Store line node with offset to avoid collision with anchor IDs
                // Using Int32.max - anchorId to ensure uniqueness (can't use negative because -0 == 0)
                let lineKey = Int32.max - anchorId
                previewNodes[lineKey] = lineNode
            }
        }
    }

    public func hidePreviewNodes() {
        for (_, node) in previewNodes {
            node.removeFromParentNode()
        }
        previewNodes.removeAll()
    }

    public func removeAllGuideNodes() {
        rootNode?.childNodes.forEach { node in
            if let sphere = node.geometry as? SCNSphere,
               sphere.radius == Constants.guideNodeRadius,
               !(node is LARSCNAnchorNode) { // Don't remove anchor nodes
                node.removeFromParentNode()
            }
        }
    }

    public func removeAllNavigationElements() {
        // Remove all anchor nodes
        for (_, node) in anchorNodes.nodeById {
            node.removeFromParentNode()
        }
        anchorNodes.removeAll()

        // Remove all guide nodes
        removeAllGuideNodes()

        // Remove all preview nodes
        hidePreviewNodes()

        // Clear selections
        clearAllHighlights()
    }

    public func getAnchorNode(anchorId: Int32) -> LARSCNAnchorNode? {
        return anchorNodes.nodeById[anchorId]
    }

    // MARK: - Private Helper Methods

    private func calculateGuideNodePositions(from start: simd_float3, to goal: simd_float3) -> [simd_float3] {
        let distance = simd_distance(start, goal)
        guard distance > 0 else { return [] }

        let stepLength = Constants.guideNodeStepLength
        let stepDirection = (goal - start) / distance
        let stepVector = stepDirection * stepLength
        let stepCount = Int(floor(distance / stepLength))

        return (0..<stepCount).map { i in
            start + stepVector * Float(i + 1)
        }
    }

    private func createPreviewNode() -> SCNNode {
        let node = SCNNode()
        let geometry = SCNSphere(radius: Constants.previewNodeRadius)

        // Semi-transparent green material
        let material = SCNMaterial()
        material.diffuse.contents = PlatformColor.systemGreen.withAlphaComponent(0.6)
        material.emission.contents = PlatformColor.systemGreen.withAlphaComponent(0.2)
        material.transparency = 0.6
        geometry.materials = [material]

        node.geometry = geometry
        return node
    }

    private func createPreviewLine(from start: simd_float3, to end: simd_float3) -> SCNNode {
        let vector = end - start
        let distance = simd_length(vector)

        // Create cylinder as line
        let cylinder = SCNCylinder(radius: Constants.previewLineRadius, height: CGFloat(distance))
        let material = SCNMaterial()
        material.diffuse.contents = PlatformColor.systemGreen.withAlphaComponent(0.4)
        cylinder.materials = [material]

        let lineNode = SCNNode(geometry: cylinder)

        // Position and orient the cylinder
        lineNode.simdPosition = (start + end) / 2.0

        // Calculate rotation to align cylinder with vector
        let up = simd_float3(0, 1, 0)
        let normalizedVector = simd_normalize(vector)

        if simd_length(normalizedVector - up) > 0.001 {
            let axis = simd_cross(up, normalizedVector)
            let angle = acos(simd_dot(up, normalizedVector))
            lineNode.simdRotation = simd_float4(axis.x, axis.y, axis.z, angle)
        }

        return lineNode
    }
}