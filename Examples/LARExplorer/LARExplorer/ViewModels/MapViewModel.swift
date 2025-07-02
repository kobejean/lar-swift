//
//  MapViewModel.swift
//  LARExplorer
//
//  Created by Claude Code on 2025-06-30.
//

import SwiftUI
import MapKit
import LocalizeAR

@MainActor
class MapViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
    )
    
    // MARK: - Internal Properties
    private weak var mapView: MKMapView?
    
    // MARK: - Configuration
    func configure(mapView: MKMapView) {
        self.mapView = mapView
        setupMapView()
    }
    
    func updateRegion(for map: LARMap) {
        let location = map.location(from: simd_double3())
        let newRegion = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        )
        
        self.region = newRegion
        mapView?.setRegion(newRegion, animated: true)
    }
    
    // MARK: - Private Methods
    private func setupMapView() {
        guard let mapView = mapView else { return }
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
        mapView.setRegion(region, animated: false)
    }
}