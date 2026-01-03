//
//  MockSceneRendering.swift
//  LARExplorer
//
//  Created by Claude Code on 2026-01-04.
//

import Foundation
import simd

/// Mock implementation of SceneRendering for testing
@MainActor
final class MockSceneRendering: SceneRendering {
    // MARK: - Call Recording

    struct HighlightCall: Equatable {
        let ids: Set<Int32>
        let style: HighlightStyle
    }

    struct PreviewNodesCall: Equatable {
        let positions: [Int32: SIMD3<Float>]

        static func == (lhs: PreviewNodesCall, rhs: PreviewNodesCall) -> Bool {
            guard lhs.positions.keys == rhs.positions.keys else { return false }
            for key in lhs.positions.keys {
                if lhs.positions[key] != rhs.positions[key] { return false }
            }
            return true
        }
    }

    struct LandmarkHighlightCall: Equatable {
        let ids: Set<Int>
        let style: HighlightStyle
    }

    struct AnchorPositionUpdateCall: Equatable {
        let id: Int32
        let transform: simd_float4x4
    }

    // Anchors
    var highlightAnchorsCalls: [HighlightCall] = []
    var clearAnchorHighlightsCalled = false
    var clearAnchorHighlightsCallCount = 0
    var updateAnchorPositionCalls: [AnchorPositionUpdateCall] = []

    // Preview nodes
    var showPreviewNodesCalls: [PreviewNodesCall] = []
    var hidePreviewNodesCalled = false
    var hidePreviewNodesCallCount = 0

    // Landmarks
    var highlightLandmarksCalls: [LandmarkHighlightCall] = []
    var clearLandmarkHighlightsCalled = false
    var clearLandmarkHighlightsCallCount = 0

    // Visibility
    var setPointCloudVisibleCalls: [Bool] = []
    var setNavigationNodesVisibleCalls: [Bool] = []
    var setNavigationEdgesVisibleCalls: [Bool] = []

    // Refresh
    var refreshCalled = false
    var refreshCallCount = 0

    // MARK: - SceneRendering

    func highlightAnchors(_ ids: Set<Int32>, style: HighlightStyle) {
        highlightAnchorsCalls.append(HighlightCall(ids: ids, style: style))
    }

    func clearAnchorHighlights() {
        clearAnchorHighlightsCalled = true
        clearAnchorHighlightsCallCount += 1
    }

    func updateAnchorPosition(id: Int32, transform: simd_float4x4) {
        updateAnchorPositionCalls.append(AnchorPositionUpdateCall(id: id, transform: transform))
    }

    func showPreviewNodes(at positions: [Int32: SIMD3<Float>]) {
        showPreviewNodesCalls.append(PreviewNodesCall(positions: positions))
    }

    func hidePreviewNodes() {
        hidePreviewNodesCalled = true
        hidePreviewNodesCallCount += 1
    }

    func highlightLandmarks(_ ids: Set<Int>, style: HighlightStyle) {
        highlightLandmarksCalls.append(LandmarkHighlightCall(ids: ids, style: style))
    }

    func clearLandmarkHighlights() {
        clearLandmarkHighlightsCalled = true
        clearLandmarkHighlightsCallCount += 1
    }

    func refresh() {
        refreshCalled = true
        refreshCallCount += 1
    }

    func setPointCloudVisible(_ visible: Bool) {
        setPointCloudVisibleCalls.append(visible)
    }

    func setNavigationNodesVisible(_ visible: Bool) {
        setNavigationNodesVisibleCalls.append(visible)
    }

    func setNavigationEdgesVisible(_ visible: Bool) {
        setNavigationEdgesVisibleCalls.append(visible)
    }

    // MARK: - Test Helpers

    func reset() {
        highlightAnchorsCalls.removeAll()
        clearAnchorHighlightsCalled = false
        clearAnchorHighlightsCallCount = 0
        updateAnchorPositionCalls.removeAll()
        showPreviewNodesCalls.removeAll()
        hidePreviewNodesCalled = false
        hidePreviewNodesCallCount = 0
        highlightLandmarksCalls.removeAll()
        clearLandmarkHighlightsCalled = false
        clearLandmarkHighlightsCallCount = 0
        setPointCloudVisibleCalls.removeAll()
        setNavigationNodesVisibleCalls.removeAll()
        setNavigationEdgesVisibleCalls.removeAll()
        refreshCalled = false
        refreshCallCount = 0
    }
}
