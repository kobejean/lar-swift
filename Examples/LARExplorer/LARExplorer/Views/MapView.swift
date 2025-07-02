//
//  MapView.swift
//  LARExplorer
//
//  Created by Claude Code on 2025-06-30.
//

import SwiftUI
import MapKit
import LocalizeAR

struct MapView: NSViewRepresentable {
    @StateObject private var viewModel = MapViewModel()
    let onMapViewCreated: (MKMapView) -> Void
    
    func makeNSView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        
        DispatchQueue.main.async {
            viewModel.configure(mapView: mapView)
            onMapViewCreated(mapView)
        }
        
        return mapView
    }
    
    func updateNSView(_ mapView: MKMapView, context: Context) {
        // Update map view if needed
    }
    
    func updateRegion(for map: LARMap) {
        viewModel.updateRegion(for: map)
    }
}
