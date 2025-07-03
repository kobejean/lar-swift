//
//  MapViewModel.swift
//  LARExplorer
//
//  Created by Jean Flaherty on 2025-06-30.
//

import SwiftUI
import MapKit
import LocalizeAR

@MainActor
class MapViewModel: NSObject, ObservableObject {
    // MARK: - Published Properties
    @Published var overlays: [MKOverlay] = []
    @Published var visualizationState: LocalizationVisualization.State = .empty {
        didSet {
            updateBoundsOverlays()
        }
    }
    
    // MARK: - Private Properties
    private weak var mapView: MKMapView?
    private var map: LARMap?
    private var navigationManager: LARNavigationManager?
    
    // MARK: - Configuration
    func configure(mapView: MKMapView) {
        self.mapView = mapView
        setupMapView()
    }
    
    func setMapData(_ map: LARMap, navigationManager: LARNavigationManager?) {
        self.map = map
        self.navigationManager = navigationManager
        
        // Set delegate now that we have navigation manager
        mapView?.delegate = self
        
        // Update to actual map region with error handling
        do {
            try updateRegion(for: map)
        } catch {
            print("MapViewModel: Failed to set map region: \(error)")
        }
    }
    
    private func setupMapView() {
        guard let mapView = mapView else { return }
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
        
        // Will be updated to actual region when map data loads
        // Using a minimal default region for now
        let defaultRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
        )
        mapView.setRegion(defaultRegion, animated: false)
    }
    
    func updateRegion(for map: LARMap) throws {
        guard let mapView = mapView else {
            throw MapViewModelError.mapViewNotConfigured
        }
        
        let landmarks = map.landmarks
        guard !landmarks.isEmpty else {
            throw MapViewModelError.noLandmarksAvailable
        }
        
        guard let (southWest, northEast) = CoordinateConversionService.landmarkBounds(for: landmarks, using: map) else {
            throw MapViewModelError.coordinateConversionFailed
        }
        
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: (southWest.latitude + northEast.latitude) / 2,
                longitude: (southWest.longitude + northEast.longitude) / 2
            ),
            span: MKCoordinateSpan(
                latitudeDelta: abs(northEast.latitude - southWest.latitude),
                longitudeDelta: abs(northEast.longitude - southWest.longitude)
            )
        )
        
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - Overlay Management
    private func updateBoundsOverlays() {
        guard let map = map, map.originReady else {
            print("Cannot create overlays: map origin not ready")
            return
        }
        
        // Remove existing polygon overlays
        let existingPolygons = overlays.compactMap { $0 as? MKPolygon }
        overlays.removeAll { $0 is MKPolygon }
        mapView?.removeOverlays(existingPolygons)
        
        // Create new polygon overlays if bounds exist
        guard let bounds = visualizationState.bounds else { return }
        
        var newOverlays: [MKOverlay] = []
        for (lower, upper) in bounds.bounds {
            let coordinates = CoordinateConversionService.boundsToPolygon(lower: lower, upper: upper, using: map)
            guard !coordinates.isEmpty else { continue }
            
            let polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
            newOverlays.append(polygon)
        }
        
        overlays.append(contentsOf: newOverlays)
        mapView?.addOverlays(newOverlays, level: .aboveRoads)
        
        print("MapViewModel: Updated \(newOverlays.count) bounds overlays")
    }
    
    func updateVisualization(state: LocalizationVisualization.State) {
        visualizationState = state
    }
    
    func clearLandmarkBounds() {
        visualizationState = .empty
    }
}

// MARK: - MKMapViewDelegate
// MARK: - Error Types
enum MapViewModelError: LocalizedError {
    case mapViewNotConfigured
    case noLandmarksAvailable
    case coordinateConversionFailed
    
    var errorDescription: String? {
        switch self {
        case .mapViewNotConfigured:
            return "MapView not properly configured"
        case .noLandmarksAvailable:
            return "No landmarks available for region calculation"
        case .coordinateConversionFailed:
            return "Failed to convert coordinates to GPS"
        }
    }
}

// MARK: - MKMapViewDelegate
extension MapViewModel: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Handle our polygon overlays
        if let polygon = overlay as? MKPolygon {
            let renderer = MKPolygonRenderer(polygon: polygon)
            renderer.strokeColor = NSColor.systemGreen.withAlphaComponent(0.8)
            renderer.fillColor = NSColor.systemGreen.withAlphaComponent(0.2)
            renderer.lineWidth = 2
            return renderer
        }
        
        // Delegate navigation overlays to navigation manager
        if let navigationManager = navigationManager {
            return navigationManager.mapView(mapView, rendererFor: overlay)
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Delegate to navigation manager for annotations
        #if canImport(UIKit)
        return navigationManager?.mapView?(mapView, viewFor: annotation)
        #else
        return nil
        #endif
    }
}
