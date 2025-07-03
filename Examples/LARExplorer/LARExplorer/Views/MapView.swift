//
//  MapView.swift
//  LARExplorer
//
//  Created by Jean Flaherty on 2025-06-30.
//

import SwiftUI
import MapKit
import LocalizeAR

struct MapView: NSViewRepresentable {
    @ObservedObject var mapViewModel: MapViewModel
    let onMapViewCreated: (MKMapView) -> Void
    
    func makeNSView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        // Don't set delegate here - let navigation manager handle it
        
        DispatchQueue.main.async {
            onMapViewCreated(mapView)
        }
        
        return mapView
    }
    
    func updateNSView(_ mapView: MKMapView, context: Context) {
        // MapViewModel handles all overlay updates through its delegate
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func updateRegion(for map: LARMap) {
        do {
            try mapViewModel.updateRegion(for: map)
        } catch {
            print("MapView: Failed to update region: \(error)")
        }
    }
}
