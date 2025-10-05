//
//  LARMapRendering.swift
//  LocalizeAR
//
//  Created by Assistant on 2025-10-05.
//

import Foundation
import MapKit
import CoreLocation
import LocalizeAR_ObjC

/// Protocol defining MapKit rendering operations for navigation elements
public protocol LARMapRendering: AnyObject {
    /// Configure the renderer with a MapKit view
    func configure(with mapView: MKMapView)

    /// Add an overlay for a navigation anchor
    /// - Parameters:
    ///   - anchor: The anchor to visualize
    ///   - map: The map for coordinate conversion
    func addAnchorOverlay(for anchor: LARAnchor, using map: LARMap)

    /// Add an overlay for a navigation edge
    /// - Parameters:
    ///   - fromAnchor: Starting anchor
    ///   - toAnchor: Ending anchor
    ///   - map: The map for coordinate conversion
    func addEdgeOverlay(from fromAnchor: LARAnchor, to toAnchor: LARAnchor, using map: LARMap)

    /// Update all overlays (useful when map origin changes)
    /// - Parameters:
    ///   - anchors: All navigation anchors
    ///   - edges: All navigation edges
    ///   - map: The map for coordinate conversion
    func updateAllOverlays(anchors: [Int32: LARAnchor], edges: [(from: Int32, to: Int32)], using map: LARMap)

    /// Update user location annotation
    /// - Parameters:
    ///   - location: New user location
    ///   - animated: Whether to animate the update
    func updateUserLocation(_ location: CLLocation, animated: Bool)

    /// Remove all overlays from the map
    func removeAllOverlays()
}