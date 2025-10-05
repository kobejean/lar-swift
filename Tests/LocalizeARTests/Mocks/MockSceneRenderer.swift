//
//  MockSceneRenderer.swift
//  LocalizeARTests
//
//  Created by Jean Atsumi Flaherty on 2025-10-05.
//

import XCTest
import SceneKit
@testable import LocalizeAR
import LocalizeAR_ObjC

/// Mock implementation of LARSceneRendering for testing
class MockSceneRenderer: LARSceneRendering {
    // Track method calls
    var configureCallCount = 0
    var addAnchorNodeCallCount = 0
    var updateAnchorNodeCallCount = 0
    var removeAnchorNodeCallCount = 0
    var addEdgeGuideNodesCallCount = 0
    var highlightAnchorCallCount = 0
    var unhighlightAnchorCallCount = 0
    var clearAllHighlightsCallCount = 0
    var showPreviewNodesCallCount = 0
    var hidePreviewNodesCallCount = 0
    var removeAllGuideNodesCallCount = 0
    var removeAllNavigationElementsCallCount = 0

    // Track parameters
    var lastConfiguredNode: SCNNode?
    var lastAddedAnchor: LARAnchor?
    var lastUpdatedAnchorId: Int32?
    var lastUpdatedTransform: simd_float4x4?
    var lastRemovedAnchorId: Int32?
    var lastEdgePositions: (from: simd_float3, to: simd_float3)?
    var lastHighlightedAnchorId: Int32?
    var lastUnhighlightedAnchorId: Int32?
    var lastPreviewPositions: [(id: Int32, position: simd_float3)]?

    // Mock state
    var mockAnchorNodes: [Int32: LARSCNAnchorNode] = [:]

    func configure(with sceneNode: SCNNode) {
        configureCallCount += 1
        lastConfiguredNode = sceneNode
    }

    func addAnchorNode(for anchor: LARAnchor) {
        addAnchorNodeCallCount += 1
        lastAddedAnchor = anchor

        // Create mock node
        let node = LARSCNAnchorNode.create(anchorId: anchor.id)
        mockAnchorNodes[anchor.id] = node
    }

    func updateAnchorNode(anchorId: Int32, transform: simd_float4x4) {
        updateAnchorNodeCallCount += 1
        lastUpdatedAnchorId = anchorId
        lastUpdatedTransform = transform
    }

    func removeAnchorNode(anchorId: Int32) {
        removeAnchorNodeCallCount += 1
        lastRemovedAnchorId = anchorId
        mockAnchorNodes.removeValue(forKey: anchorId)
    }

    func addEdgeGuideNodes(from fromPosition: simd_float3, to toPosition: simd_float3) {
        addEdgeGuideNodesCallCount += 1
        lastEdgePositions = (fromPosition, toPosition)
    }

    func highlightAnchor(anchorId: Int32) {
        highlightAnchorCallCount += 1
        lastHighlightedAnchorId = anchorId
    }

    func unhighlightAnchor(anchorId: Int32) {
        unhighlightAnchorCallCount += 1
        lastUnhighlightedAnchorId = anchorId
    }

    func clearAllHighlights() {
        clearAllHighlightsCallCount += 1
    }

    func showPreviewNodes(_ positions: [(id: Int32, position: simd_float3)]) {
        showPreviewNodesCallCount += 1
        lastPreviewPositions = positions
    }

    func hidePreviewNodes() {
        hidePreviewNodesCallCount += 1
    }

    func removeAllGuideNodes() {
        removeAllGuideNodesCallCount += 1
    }

    func removeAllNavigationElements() {
        removeAllNavigationElementsCallCount += 1
        mockAnchorNodes.removeAll()
    }

    func getAnchorNode(anchorId: Int32) -> LARSCNAnchorNode? {
        return mockAnchorNodes[anchorId]
    }
}
