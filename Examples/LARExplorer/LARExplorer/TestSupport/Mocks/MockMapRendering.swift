//
//  MockMapRendering.swift
//  LARExplorer
//
//  Created by Claude Code on 2026-01-04.
//

import Foundation
import simd

/// Mock implementation of MapRendering for testing
@MainActor
final class MockMapRendering: MapRendering {
    // MARK: - Call Recording

    struct EdgeCall: Equatable {
        let fromId: Int32
        let toId: Int32
    }

    struct EdgeHighlightCall: Equatable {
        let fromId: Int32
        let toId: Int32
        let style: HighlightStyle
    }

    struct BoundsCall: Equatable {
        let lower: SIMD2<Double>
        let upper: SIMD2<Double>
    }

    // Edge highlights
    var highlightEdgeCalls: [EdgeHighlightCall] = []
    var clearEdgeHighlightsCalled = false
    var clearEdgeHighlightsCallCount = 0

    // Edge operations
    var addEdgeCalls: [EdgeCall] = []
    var removeEdgeCalls: [EdgeCall] = []

    // Bounds overlays
    var showBoundsOverlayCalls: [BoundsCall] = []
    var clearBoundsOverlaysCalled = false
    var clearBoundsOverlaysCallCount = 0

    // Refresh
    var refreshOverlaysCalled = false
    var refreshOverlaysCallCount = 0

    // MARK: - MapRendering

    func highlightEdge(from: Int32, to: Int32, style: HighlightStyle) {
        highlightEdgeCalls.append(EdgeHighlightCall(fromId: from, toId: to, style: style))
    }

    func clearEdgeHighlights() {
        clearEdgeHighlightsCalled = true
        clearEdgeHighlightsCallCount += 1
    }

    func addEdge(from: Int32, to: Int32) {
        addEdgeCalls.append(EdgeCall(fromId: from, toId: to))
    }

    func removeEdge(from: Int32, to: Int32) {
        removeEdgeCalls.append(EdgeCall(fromId: from, toId: to))
    }

    func showBoundsOverlay(lower: SIMD2<Double>, upper: SIMD2<Double>) {
        showBoundsOverlayCalls.append(BoundsCall(lower: lower, upper: upper))
    }

    func clearBoundsOverlays() {
        clearBoundsOverlaysCalled = true
        clearBoundsOverlaysCallCount += 1
    }

    func refreshOverlays() {
        refreshOverlaysCalled = true
        refreshOverlaysCallCount += 1
    }

    // MARK: - Test Helpers

    func reset() {
        highlightEdgeCalls.removeAll()
        clearEdgeHighlightsCalled = false
        clearEdgeHighlightsCallCount = 0
        addEdgeCalls.removeAll()
        removeEdgeCalls.removeAll()
        showBoundsOverlayCalls.removeAll()
        clearBoundsOverlaysCalled = false
        clearBoundsOverlaysCallCount = 0
        refreshOverlaysCalled = false
        refreshOverlaysCallCount = 0
    }
}
