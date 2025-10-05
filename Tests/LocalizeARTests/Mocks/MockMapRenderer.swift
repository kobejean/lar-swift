//
//  MockMapRenderer.swift
//  LocalizeARTests
//
//  Created by Jean Atsumi Flaherty on 2025-10-05.
//

import XCTest
import MapKit
import CoreLocation
@testable import LocalizeAR
import LocalizeAR_ObjC

/// Mock implementation of LARMapRendering for testing
class MockMapRenderer: LARMapRendering {
    // Track method calls
    var configureCallCount = 0
    var addAnchorOverlayCallCount = 0
    var addEdgeOverlayCallCount = 0
    var updateAllOverlaysCallCount = 0
    var updateUserLocationCallCount = 0
    var removeAllOverlaysCallCount = 0

    // Track parameters
    var lastConfiguredMapView: MKMapView?
    var lastAnchorOverlay: (anchor: LARAnchor, map: LARMap)?
    var lastEdgeOverlay: (from: LARAnchor, to: LARAnchor, map: LARMap)?
    var lastUpdateOverlays: (anchors: [Int32: LARAnchor], edges: [(from: Int32, to: Int32)], map: LARMap)?
    var lastUserLocation: CLLocation?
    var lastUserLocationAnimated: Bool?

    func configure(with mapView: MKMapView) {
        configureCallCount += 1
        lastConfiguredMapView = mapView
    }

    func addAnchorOverlay(for anchor: LARAnchor, using map: LARMap) {
        addAnchorOverlayCallCount += 1
        lastAnchorOverlay = (anchor, map)
    }

    func addEdgeOverlay(from fromAnchor: LARAnchor, to toAnchor: LARAnchor, using map: LARMap) {
        addEdgeOverlayCallCount += 1
        lastEdgeOverlay = (fromAnchor, toAnchor, map)
    }

    func updateAllOverlays(anchors: [Int32: LARAnchor], edges: [(from: Int32, to: Int32)], using map: LARMap) {
        updateAllOverlaysCallCount += 1
        lastUpdateOverlays = (anchors, edges, map)
    }

    func updateUserLocation(_ location: CLLocation, animated: Bool) {
        updateUserLocationCallCount += 1
        lastUserLocation = location
        lastUserLocationAnimated = animated
    }

    func removeAllOverlays() {
        removeAllOverlaysCallCount += 1
    }
}
