//
//  LARRenderingService.swift
//  LARExplorer
//
//  Created by Claude Code on 2026-01-04.
//

import Foundation
import simd

/// Concrete implementation of RenderingService that coordinates scene and map rendering
/// This service delegates to specialized adapters for SceneKit and MapKit operations
@MainActor
final class LARRenderingService: RenderingService {
    // MARK: - Dependencies

    private let sceneRenderer: SceneRendering
    private let mapRenderer: MapRendering

    // MARK: - Initialization

    init(sceneRenderer: SceneRendering, mapRenderer: MapRendering) {
        self.sceneRenderer = sceneRenderer
        self.mapRenderer = mapRenderer
    }

    /// Convenience initializer with default adapters
    convenience init() {
        self.init(
            sceneRenderer: SceneRenderingAdapter(),
            mapRenderer: MapRenderingAdapter()
        )
    }

    // MARK: - RenderingService - Anchors

    func highlightAnchors(_ ids: Set<Int32>, style: HighlightStyle) {
        sceneRenderer.highlightAnchors(ids, style: style)
    }

    func clearAnchorHighlights() {
        sceneRenderer.clearAnchorHighlights()
    }

    func showPreviewNodes(at positions: [Int32: SIMD3<Float>]) {
        sceneRenderer.showPreviewNodes(at: positions)
    }

    func hidePreviewNodes() {
        sceneRenderer.hidePreviewNodes()
    }

    // MARK: - RenderingService - Edges

    func highlightEdge(from: Int32, to: Int32, style: HighlightStyle) {
        mapRenderer.highlightEdge(from: from, to: to, style: style)
    }

    func clearEdgeHighlights() {
        mapRenderer.clearEdgeHighlights()
    }

    func addEdge(from: Int32, to: Int32) {
        mapRenderer.addEdge(from: from, to: to)
    }

    func removeEdge(from: Int32, to: Int32) {
        mapRenderer.removeEdge(from: from, to: to)
    }

    // MARK: - RenderingService - Landmarks

    func highlightLandmarks(_ ids: Set<Int>, style: HighlightStyle) {
        sceneRenderer.highlightLandmarks(ids, style: style)
    }

    func clearLandmarkHighlights() {
        sceneRenderer.clearLandmarkHighlights()
    }

    // MARK: - RenderingService - Map Overlays

    func showBoundsOverlay(lower: SIMD2<Double>, upper: SIMD2<Double>) {
        mapRenderer.showBoundsOverlay(lower: lower, upper: upper)
    }

    func clearBoundsOverlays() {
        mapRenderer.clearBoundsOverlays()
    }

    func refreshMapOverlays() {
        mapRenderer.refreshOverlays()
    }

    // MARK: - RenderingService - Global

    func refreshAll() {
        sceneRenderer.refresh()
        mapRenderer.refreshOverlays()
    }

    func setPointCloudVisible(_ visible: Bool) {
        sceneRenderer.setPointCloudVisible(visible)
    }

    func setNavigationNodesVisible(_ visible: Bool) {
        sceneRenderer.setNavigationNodesVisible(visible)
    }

    func setNavigationEdgesVisible(_ visible: Bool) {
        sceneRenderer.setNavigationEdgesVisible(visible)
    }
}
