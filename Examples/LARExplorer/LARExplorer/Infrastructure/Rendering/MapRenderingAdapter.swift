//
//  MapRenderingAdapter.swift
//  LARExplorer
//
//  Created by Claude Code on 2026-01-04.
//

import Foundation
import MapKit
import simd

/// Protocol for map-specific rendering operations
/// Allows decoupling from concrete MKMapView for testing
@MainActor
protocol MapRendering: AnyObject {
    /// Highlight an edge on the map
    func highlightEdge(from: Int32, to: Int32, style: HighlightStyle)

    /// Clear all edge highlights
    func clearEdgeHighlights()

    /// Add an edge to the map display
    func addEdge(from: Int32, to: Int32)

    /// Remove an edge from the map display
    func removeEdge(from: Int32, to: Int32)

    /// Show bounds overlay on the map
    func showBoundsOverlay(lower: SIMD2<Double>, upper: SIMD2<Double>)

    /// Clear all bounds overlays
    func clearBoundsOverlays()

    /// Refresh map overlays
    func refreshOverlays()
}

/// Adapter that implements map rendering by delegating to an MKMapView
@MainActor
final class MapRenderingAdapter: MapRendering {
    // MARK: - Properties

    private weak var mapView: MKMapView?
    private var edgeHighlightOverlays: [String: MKOverlay] = [:]
    private var boundsOverlays: [MKOverlay] = []

    // MARK: - Coordinate Converter

    /// Function to convert world coordinates to map coordinates
    /// This should be injected based on the current map origin
    var coordinateConverter: ((SIMD3<Float>) -> CLLocationCoordinate2D)?

    // MARK: - Initialization

    init(mapView: MKMapView? = nil) {
        self.mapView = mapView
    }

    func configure(mapView: MKMapView) {
        self.mapView = mapView
    }

    // MARK: - MapRendering

    func highlightEdge(from: Int32, to: Int32, style: HighlightStyle) {
        guard let mapView = mapView else { return }

        let key = edgeKey(from: from, to: to)

        // Remove existing highlight for this edge
        if let existing = edgeHighlightOverlays[key] {
            mapView.removeOverlay(existing)
        }

        // In a real implementation, we'd look up the anchor positions
        // and create a polyline between them
        // For now, this is a placeholder that demonstrates the pattern
    }

    func clearEdgeHighlights() {
        guard let mapView = mapView else { return }

        for (_, overlay) in edgeHighlightOverlays {
            mapView.removeOverlay(overlay)
        }
        edgeHighlightOverlays.removeAll()
    }

    func addEdge(from: Int32, to: Int32) {
        // In a real implementation, this would add a permanent edge overlay
        // The actual edge data is stored in the repository
        refreshOverlays()
    }

    func removeEdge(from: Int32, to: Int32) {
        // In a real implementation, this would remove the edge overlay
        refreshOverlays()
    }

    func showBoundsOverlay(lower: SIMD2<Double>, upper: SIMD2<Double>) {
        guard let mapView = mapView else { return }

        // Create a polygon overlay for the bounds
        let coordinates = [
            CLLocationCoordinate2D(latitude: lower.y, longitude: lower.x),
            CLLocationCoordinate2D(latitude: lower.y, longitude: upper.x),
            CLLocationCoordinate2D(latitude: upper.y, longitude: upper.x),
            CLLocationCoordinate2D(latitude: upper.y, longitude: lower.x)
        ]

        let polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
        boundsOverlays.append(polygon)
        mapView.addOverlay(polygon)
    }

    func clearBoundsOverlays() {
        guard let mapView = mapView else { return }

        for overlay in boundsOverlays {
            mapView.removeOverlay(overlay)
        }
        boundsOverlays.removeAll()
    }

    func refreshOverlays() {
        // Force a redraw of all overlays
        guard let mapView = mapView else { return }

        // Re-add all overlays to trigger a refresh
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        mapView.addOverlays(overlays)
    }

    // MARK: - Private Helpers

    private func edgeKey(from: Int32, to: Int32) -> String {
        let sorted = [from, to].sorted()
        return "\(sorted[0])-\(sorted[1])"
    }
}
