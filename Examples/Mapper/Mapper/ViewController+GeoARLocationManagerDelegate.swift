//
//  ViewController+MKMapViewDelegate.swift
//  Mapper
//
//  Created by Jean Flaherty on 5/28/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import MapKit
import GeoAR
import CoreLocation

extension ViewController: GeoARLocationManagerDelegate {
    
    func locationManager(_ manager: GeoARLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        if userLocationAnnotation == nil {
            let annotaion = MKPointAnnotation()
            mapView.addAnnotation(annotaion)
            mapView.userTrackingMode = .none
            userLocationAnnotation = annotaion
        }
        userLocationAnnotation!.coordinate = location.coordinate
        
        if case .relocalizing = lastTrackerState, case .normal = sceneView.tracker.state {
            // Zoom in on relocalization
            let radius: CLLocationDistance = 10
            let region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: radius,
                longitudinalMeters: radius)
            let fitRegion = mapView.regionThatFits(region)
            mapView.setRegion(fitRegion, animated: true)
        }
        lastTrackerState = sceneView.tracker.state
        
        if !mapRegionIsMovedByUser && lastUserLocation?.distance(from: location) ?? 1 > 0.1 {
            mapRegionIsMovedProgramatically = true
            mapView.setCenter(location.coordinate, animated: true)
            lastUserLocation = location
        }
    }
    
}
