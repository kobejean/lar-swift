//
//  MockRenderingService.swift
//  LARExplorer
//
//  Created by Claude Code on 2026-01-04.
//

import Foundation
import simd

/// Mock implementation of RenderingService for unit testing
/// Records all method calls for verification in tests
@MainActor
final class MockRenderingService: RenderingService {
    // MARK: - Call Recording Structures

    struct AnchorHighlightCall: Equatable {
        let ids: Set<Int32>
        let style: HighlightStyle
    }

    struct PreviewNodesCall: Equatable {
        let positions: [Int32: SIMD3<Float>]

        static func == (lhs: PreviewNodesCall, rhs: PreviewNodesCall) -> Bool {
            guard lhs.positions.keys == rhs.positions.keys else { return false }
            for key in lhs.positions.keys {
                guard let lhsPos = lhs.positions[key],
                      let rhsPos = rhs.positions[key],
                      lhsPos == rhsPos else {
                    return false
                }
            }
            return true
        }
    }

    struct EdgeHighlightCall: Equatable {
        let fromId: Int32
        let toId: Int32
        let style: HighlightStyle
    }

    struct EdgeOperationCall: Equatable {
        let fromId: Int32
        let toId: Int32
    }

    struct LandmarkHighlightCall: Equatable {
        let ids: Set<Int>
        let style: HighlightStyle
    }

    struct BoundsOverlayCall: Equatable {
        let lower: SIMD2<Double>
        let upper: SIMD2<Double>
    }

    // MARK: - Recorded Calls

    // Anchor rendering
    var highlightAnchorsCalls: [AnchorHighlightCall] = []
    var clearAnchorHighlightsCalled = false
    var clearAnchorHighlightsCallCount = 0
    var showPreviewNodesCalls: [PreviewNodesCall] = []
    var hidePreviewNodesCalled = false
    var hidePreviewNodesCallCount = 0

    // Edge rendering
    var highlightEdgeCalls: [EdgeHighlightCall] = []
    var clearEdgeHighlightsCalled = false
    var clearEdgeHighlightsCallCount = 0
    var addEdgeCalls: [EdgeOperationCall] = []
    var removeEdgeCalls: [EdgeOperationCall] = []

    // Landmark rendering
    var highlightLandmarksCalls: [LandmarkHighlightCall] = []
    var clearLandmarkHighlightsCalled = false
    var clearLandmarkHighlightsCallCount = 0

    // Map overlay rendering
    var showBoundsOverlayCalls: [BoundsOverlayCall] = []
    var clearBoundsOverlaysCalled = false
    var clearBoundsOverlaysCallCount = 0
    var refreshMapOverlaysCalled = false
    var refreshMapOverlaysCallCount = 0

    // Global operations
    var refreshAllCalled = false
    var refreshAllCallCount = 0
    var setPointCloudVisibleCalls: [Bool] = []
    var setNavigationNodesVisibleCalls: [Bool] = []
    var setNavigationEdgesVisibleCalls: [Bool] = []

    // MARK: - RenderingService Conformance

    func highlightAnchors(_ ids: Set<Int32>, style: HighlightStyle) {
        highlightAnchorsCalls.append(AnchorHighlightCall(ids: ids, style: style))
    }

    func clearAnchorHighlights() {
        clearAnchorHighlightsCalled = true
        clearAnchorHighlightsCallCount += 1
    }

    func showPreviewNodes(at positions: [Int32: SIMD3<Float>]) {
        showPreviewNodesCalls.append(PreviewNodesCall(positions: positions))
    }

    func hidePreviewNodes() {
        hidePreviewNodesCalled = true
        hidePreviewNodesCallCount += 1
    }

    func highlightEdge(from: Int32, to: Int32, style: HighlightStyle) {
        highlightEdgeCalls.append(EdgeHighlightCall(fromId: from, toId: to, style: style))
    }

    func clearEdgeHighlights() {
        clearEdgeHighlightsCalled = true
        clearEdgeHighlightsCallCount += 1
    }

    func addEdge(from: Int32, to: Int32) {
        addEdgeCalls.append(EdgeOperationCall(fromId: from, toId: to))
    }

    func removeEdge(from: Int32, to: Int32) {
        removeEdgeCalls.append(EdgeOperationCall(fromId: from, toId: to))
    }

    func highlightLandmarks(_ ids: Set<Int>, style: HighlightStyle) {
        highlightLandmarksCalls.append(LandmarkHighlightCall(ids: ids, style: style))
    }

    func clearLandmarkHighlights() {
        clearLandmarkHighlightsCalled = true
        clearLandmarkHighlightsCallCount += 1
    }

    func showBoundsOverlay(lower: SIMD2<Double>, upper: SIMD2<Double>) {
        showBoundsOverlayCalls.append(BoundsOverlayCall(lower: lower, upper: upper))
    }

    func clearBoundsOverlays() {
        clearBoundsOverlaysCalled = true
        clearBoundsOverlaysCallCount += 1
    }

    func refreshMapOverlays() {
        refreshMapOverlaysCalled = true
        refreshMapOverlaysCallCount += 1
    }

    func refreshAll() {
        refreshAllCalled = true
        refreshAllCallCount += 1
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

    /// Reset all recorded calls (useful between tests)
    func reset() {
        // Anchor rendering
        highlightAnchorsCalls.removeAll()
        clearAnchorHighlightsCalled = false
        clearAnchorHighlightsCallCount = 0
        showPreviewNodesCalls.removeAll()
        hidePreviewNodesCalled = false
        hidePreviewNodesCallCount = 0

        // Edge rendering
        highlightEdgeCalls.removeAll()
        clearEdgeHighlightsCalled = false
        clearEdgeHighlightsCallCount = 0
        addEdgeCalls.removeAll()
        removeEdgeCalls.removeAll()

        // Landmark rendering
        highlightLandmarksCalls.removeAll()
        clearLandmarkHighlightsCalled = false
        clearLandmarkHighlightsCallCount = 0

        // Map overlay rendering
        showBoundsOverlayCalls.removeAll()
        clearBoundsOverlaysCalled = false
        clearBoundsOverlaysCallCount = 0
        refreshMapOverlaysCalled = false
        refreshMapOverlaysCallCount = 0

        // Global operations
        refreshAllCalled = false
        refreshAllCallCount = 0
        setPointCloudVisibleCalls.removeAll()
        setNavigationNodesVisibleCalls.removeAll()
        setNavigationEdgesVisibleCalls.removeAll()
    }

    // MARK: - Convenience Assertions

    /// Get the last anchor highlight call (if any)
    var lastAnchorHighlight: AnchorHighlightCall? {
        highlightAnchorsCalls.last
    }

    /// Get the last landmark highlight call (if any)
    var lastLandmarkHighlight: LandmarkHighlightCall? {
        highlightLandmarksCalls.last
    }

    /// Get the last preview nodes call (if any)
    var lastPreviewNodes: PreviewNodesCall? {
        showPreviewNodesCalls.last
    }
}
