//
//  ViewController+MKMapViewDelegate.swift
//  LARScan
//
//  Created by Jean Flaherty on 2022/02/02.
//

import Foundation
import MapKit
import LocalizeAR

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let pin = LARMKUserLocationAnnotationView(annotation: annotation, color: .green, reuseIdentifier: nil)
            pin.alpha = 0.25
//            pin.isHidden = true
//            userLocationAnnotationView = pin
            return pin

        } else if let annotation = annotation as? MKPointAnnotation, annotation == userLocationAnnotation {
            let pin = LARMKUserLocationAnnotationView(annotation: annotation, color: view.tintColor, reuseIdentifier: nil)
//            userLocationAnnotationView?.annotation = annotation
            return pin
        }
        return nil
    }
    
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        if let circle = overlay as? GeoARMKNavigationGuideNodeOverlay {
//            let renderer = MKCircleRenderer(circle: circle)
//            renderer.fillColor = view.tintColor
//            return renderer
//        } else if let circle = overlay as? GeoARMKNavigationNodeOverlay {
//            let renderer = MKCircleRenderer(circle: circle)
//            renderer.fillColor = .white
//            return renderer
//        }
//
//        return MKOverlayRenderer(overlay: overlay)
//    }
//
//    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
//        if !mapRegionIsMovedProgramatically {
//            mapRegionIsMovedByUser = true
//        }
//    }
//
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        if !mapRegionIsMovedProgramatically {
//            mapRegionFreezeTimer?.invalidate()
//            mapRegionFreezeTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { [weak self] timer in
//                self?.mapRegionIsMovedByUser = false
//            }
//        } else {
//            mapRegionIsMovedProgramatically = false
//        }
//    }
}
