//
//  RenderingService.swift
//  LARExplorer
//
//  Created by Claude Code on 2026-01-04.
//

import Foundation
import simd

// MARK: - Highlight Style

/// Visual styles for highlighting elements in the scene and map views
enum HighlightStyle: Equatable {
    /// User-selected items (primary selection color)
    case selected
    /// Preview of pending changes (translucent)
    case preview
    /// Landmarks within spatial query range (gray)
    case spatialQuery
    /// Successfully matched landmarks (orange)
    case matched
    /// Inlier landmarks after RANSAC (green)
    case inlier
}

// MARK: - RenderingService Protocol

/// Unified rendering commands for both Scene (3D) and Map (2D) views
/// This protocol allows testing rendering logic without actual UI dependencies
@MainActor
protocol RenderingService: AnyObject {
    // MARK: - Anchor Rendering

    /// Highlight specific anchors with the given style
    func highlightAnchors(_ ids: Set<Int32>, style: HighlightStyle)

    /// Clear all anchor highlights
    func clearAnchorHighlights()

    /// Update anchor position in the scene (after applying offset)
    func updateAnchorPosition(id: Int32, transform: simd_float4x4)

    /// Show preview nodes at specified positions (for offset preview)
    func showPreviewNodes(at positions: [Int32: SIMD3<Float>])

    /// Hide all preview nodes
    func hidePreviewNodes()

    // MARK: - Edge Rendering

    /// Highlight a specific edge
    func highlightEdge(from: Int32, to: Int32, style: HighlightStyle)

    /// Clear all edge highlights
    func clearEdgeHighlights()

    /// Add a visual edge between anchors
    func addEdge(from: Int32, to: Int32)

    /// Remove a visual edge between anchors
    func removeEdge(from: Int32, to: Int32)

    // MARK: - Landmark Rendering

    /// Highlight specific landmarks with the given style
    func highlightLandmarks(_ ids: Set<Int>, style: HighlightStyle)

    /// Clear all landmark highlights
    func clearLandmarkHighlights()

    // MARK: - Map Overlay Rendering

    /// Show a bounds overlay on the 2D map
    func showBoundsOverlay(lower: SIMD2<Double>, upper: SIMD2<Double>)

    /// Clear all bounds overlays
    func clearBoundsOverlays()

    /// Refresh all map overlays (after data changes)
    func refreshMapOverlays()

    // MARK: - Global Operations

    /// Refresh all visual elements (scene + map)
    func refreshAll()

    /// Set the visibility of the point cloud
    func setPointCloudVisible(_ visible: Bool)

    /// Set the visibility of navigation nodes
    func setNavigationNodesVisible(_ visible: Bool)

    /// Set the visibility of navigation edges
    func setNavigationEdgesVisible(_ visible: Bool)
}
