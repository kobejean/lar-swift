//
//  LARMapRenderer.swift
//  LocalizeAR
//
//  Created by Assistant on 2025-10-05.
//

import Foundation
import MapKit
import CoreLocation
import LocalizeAR_ObjC

#if canImport(UIKit)
import UIKit
private typealias PlatformColor = UIColor
#elseif canImport(AppKit)
import AppKit
private typealias PlatformColor = NSColor
#endif

/// Handles all MapKit rendering operations for navigation elements
public class LARMapRenderer: NSObject, LARMapRendering {
    // MARK: - Configuration
    private struct Constants {
        static let userLocationThreshold: Double = 0.05
    }

    // MARK: - Properties
    private weak var mapView: MKMapView?
    private var userLocationAnnotation: MKPointAnnotation?

    // MARK: - Initialization
    public override init() {
        super.init()
    }

    // MARK: - LARMapRendering Protocol

    public func configure(with mapView: MKMapView) {
        self.mapView = mapView
        mapView.delegate = self
    }

    public func addAnchorOverlay(for anchor: LARAnchor, using map: LARMap) {
        guard map.originReady else { return }

        let coordinate = map.location(from: anchor).coordinate
        let overlay = LARMKNavigationNodeOverlay(coordinate: coordinate)
        mapView?.addOverlay(overlay, level: .aboveLabels)
    }

    public func addEdgeOverlay(from fromAnchor: LARAnchor, to toAnchor: LARAnchor, using map: LARMap) {
        guard map.originReady else { return }

        let fromCoordinate = map.location(from: fromAnchor).coordinate
        let toCoordinate = map.location(from: toAnchor).coordinate
        let polyline = MKPolyline(coordinates: [fromCoordinate, toCoordinate], count: 2)
        mapView?.addOverlay(polyline, level: .aboveRoads)
    }

    public func updateAllOverlays(anchors: [Int32: LARAnchor], edges: [(from: Int32, to: Int32)], using map: LARMap) {
        guard let mapView = mapView, map.originReady else { return }

        // Remove existing overlays
        mapView.removeOverlays(mapView.overlays)

        // Add anchor overlays
        for (_, anchor) in anchors {
            addAnchorOverlay(for: anchor, using: map)
        }

        // Add edge overlays
        for (fromId, toId) in edges {
            if let fromAnchor = anchors[fromId], let toAnchor = anchors[toId] {
                addEdgeOverlay(from: fromAnchor, to: toAnchor, using: map)
            }
        }
    }

    public func updateUserLocation(_ location: CLLocation, animated: Bool) {
        guard let mapView = mapView else { return }

        if let userLocationAnnotation = userLocationAnnotation {
            userLocationAnnotation.coordinate = location.coordinate
            if animated {
                mapView.setCenter(location.coordinate, animated: true)
            }
        } else {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            mapView.addAnnotation(annotation)
            mapView.userTrackingMode = .none
            self.userLocationAnnotation = annotation
        }
    }

    public func removeAllOverlays() {
        guard let mapView = mapView else { return }
        mapView.removeOverlays(mapView.overlays)

        if let userLocationAnnotation = userLocationAnnotation {
            mapView.removeAnnotation(userLocationAnnotation)
            self.userLocationAnnotation = nil
        }
    }

    // MARK: - Deinitialization
    deinit {
        if let userLocationAnnotation = userLocationAnnotation {
            mapView?.removeAnnotation(userLocationAnnotation)
        }
    }
}

// MARK: - MKMapViewDelegate
extension LARMapRenderer: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Handle guide node overlays
        if let circle = overlay as? LARMKNavigationGuideNodeOverlay {
            let renderer = MKCircleRenderer(circle: circle)
            renderer.fillColor = PlatformColor.systemBlue
            return renderer
        }

        // Handle navigation node overlays
        if let circle = overlay as? LARMKNavigationNodeOverlay {
            let renderer = MKCircleRenderer(circle: circle)
            renderer.fillColor = PlatformColor.white
            return renderer
        }

        // Handle edge polylines
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = PlatformColor.systemBlue
            renderer.lineWidth = 3.0
            renderer.lineDashPattern = nil
            return renderer
        }

        return MKOverlayRenderer(overlay: overlay)
    }

#if canImport(UIKit)
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let pin = LARMKUserLocationAnnotationView(
                annotation: annotation,
                color: .systemPurple,
                reuseIdentifier: nil
            )
            return pin
        } else if let annotation = annotation as? MKPointAnnotation, annotation == userLocationAnnotation {
            let pin = LARMKUserLocationAnnotationView(
                annotation: annotation,
                color: UIColor.systemBlue,
                reuseIdentifier: nil
            )
            return pin
        }
        return nil
    }
#endif
}