//
//  LARRenderingServiceAdapter.swift
//  LARExplorer
//
//  Created by Claude Code on 2026-01-04.
//

import Foundation
import LocalizeAR
import MapKit
import simd

/// Adapter that bridges the RenderingService protocol to LARNavigationCoordinator
///
/// This adapter implements the domain-level RenderingService protocol by delegating
/// to the LocalizeAR library's LARNavigationCoordinator. It enables the new coordinator
/// architecture to work with existing rendering infrastructure.
///
/// Key responsibilities:
/// - Translate domain highlight styles to coordinator selection calls
/// - Forward preview node commands to scene renderer
/// - Delegate edge operations to navigation coordinator
/// - Manage bounds overlays through MapViewModel
@MainActor
final class LARRenderingServiceAdapter: RenderingService {

    // MARK: - Dependencies

    private weak var navigationCoordinator: LARNavigationCoordinator?
    private weak var mapViewModel: MapViewModel?

    // MARK: - State Tracking

    /// Track currently highlighted anchors for clearing
    private var highlightedAnchorIds: Set<Int32> = []

    // MARK: - Initialization

    init() {}

    /// Configure the adapter with required dependencies
    /// Called after map is loaded and navigation coordinator is available
    func configure(navigationCoordinator: LARNavigationCoordinator, mapViewModel: MapViewModel) {
        self.navigationCoordinator = navigationCoordinator
        self.mapViewModel = mapViewModel
    }

    // MARK: - RenderingService: Anchor Highlights

    func highlightAnchors(_ ids: Set<Int32>, style: HighlightStyle) {
        // Clear previous highlights first
        for id in highlightedAnchorIds where !ids.contains(id) {
            navigationCoordinator?.setAnchorSelection(id: id, selected: false)
        }

        // Apply new highlights
        for id in ids {
            navigationCoordinator?.setAnchorSelection(id: id, selected: true)
        }

        highlightedAnchorIds = ids
    }

    func clearAnchorHighlights() {
        for id in highlightedAnchorIds {
            navigationCoordinator?.setAnchorSelection(id: id, selected: false)
        }
        highlightedAnchorIds.removeAll()
    }

    // MARK: - RenderingService: Preview Nodes

    func showPreviewNodes(at positions: [Int32: SIMD3<Float>]) {
        let tuples = positions.map { (id: $0.key, position: $0.value) }
        navigationCoordinator?.showPreviewNodes(for: tuples)
    }

    func hidePreviewNodes() {
        navigationCoordinator?.hidePreviewNodes()
    }

    // MARK: - RenderingService: Edge Highlights

    func highlightEdge(from fromId: Int32, to toId: Int32, style: HighlightStyle) {
        // Edge highlighting is not currently supported by LARNavigationCoordinator
        // In the future, this could modify edge line colors/widths
    }

    func clearEdgeHighlights() {
        // Edge highlighting not yet implemented
    }

    // MARK: - RenderingService: Edge Operations

    func addEdge(from fromId: Int32, to toId: Int32) {
        navigationCoordinator?.addNavigationEdge(from: fromId, to: toId)
    }

    func removeEdge(from fromId: Int32, to toId: Int32) {
        navigationCoordinator?.removeNavigationEdge(from: fromId, to: toId)
    }

    // MARK: - RenderingService: Landmark Highlights

    func highlightLandmarks(_ ids: Set<Int>, style: HighlightStyle) {
        // Landmark highlighting is handled through LocalizationVisualization.State
        // This is currently managed by the localization service directly
        // Future implementation: update SceneViewModel's visualization state
    }

    func clearLandmarkHighlights() {
        // Landmark highlighting not yet implemented at this layer
    }

    // MARK: - RenderingService: Bounds Overlays

    func showBoundsOverlay(lower: SIMD2<Double>, upper: SIMD2<Double>) {
        // Create a visualization state with bounds using simd_double2
        let lowerBound = simd_double2(lower.x, lower.y)
        let upperBound = simd_double2(upper.x, upper.y)
        let bounds = LocalizationVisualization.LandmarkBounds(bounds: [(lowerBound, upperBound)])
        let state = LocalizationVisualization.State(highlights: nil, bounds: bounds)
        mapViewModel?.updateVisualization(state: state)
    }

    func clearBoundsOverlays() {
        mapViewModel?.updateVisualization(state: .empty)
    }

    func refreshMapOverlays() {
        navigationCoordinator?.updateMapOverlays()
    }

    // MARK: - RenderingService: Visibility Toggles

    func setPointCloudVisible(_ visible: Bool) {
        // Point cloud visibility is managed by SceneViewModel
        // This would need SceneViewModel reference to implement
    }

    func setNavigationNodesVisible(_ visible: Bool) {
        // Navigation node visibility not yet implemented
        // Would need to show/hide anchor nodes in scene
    }

    func setNavigationEdgesVisible(_ visible: Bool) {
        // Navigation edge visibility not yet implemented
        // Would need to show/hide guide nodes in scene
    }

    // MARK: - RenderingService: Refresh

    func refreshAll() {
        navigationCoordinator?.refreshGuideNodes()
        navigationCoordinator?.updateMapOverlays()
    }
}
