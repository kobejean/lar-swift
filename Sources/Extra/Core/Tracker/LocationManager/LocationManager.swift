//
//  LocationManager.swift
//  
//
//  Created by Jean Flaherty on 6/3/21.
//

import Foundation
import ARKit
import CoreLocation
import Collections
import LANumerics


class LocationManager: NSObject {
    
    struct Frame {
        let timestamp: TimeInterval
        let cameraTransform: simd_float4x4
    }
    
    weak var tracker: InternalTracker?
    weak var externalManager: GeoARLocationManager?
    
    var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 0.5
        locationManager.headingFilter = 0.5
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()
    
    var _uncombinedLocations = Deque<CLLocation>()
    var _uncombinedFrames = Deque<Frame>()
    
    // MARK: Setup

    func requestAuthorization() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func estimatedVirtualLocation(frame: ARFrame) -> (point: simd_float2, accuracy: Float)? {
        // TODO: Finalize horizontalAccuracy requirements
        guard let location = locationManager.location,
              let tracker = tracker,
              let mapAnchor = frame.mapAnchor,
              let mapSpaceVirtualLocation = tracker.map.pointCloud.estimatedVirtualLocation(for: location),
              location.horizontalAccuracy > 0// ,
              // location.horizontalAccuracy < 10
        else { return nil }
        
        let accuracy = Float(location.horizontalAccuracy)
        let virtualLocation = mapAnchor.moveOut(mapSpaceVirtualLocation)
        return (virtualLocation, accuracy)
    }
    
    func estimatedRealLocation(frame: ARFrame) -> CLLocation? {
        let virtual2 = simd_float2(frame.camera.transform[3,0], frame.camera.transform[3,2])
        guard let tracker = tracker,
              let mapSpaceVirtual2 = frame.mapAnchor?.moveIn(virtual2),
              let mapSpaceRealLocation = tracker.map.pointCloud.estimatedRealLocation(for: mapSpaceVirtual2)
        else { return nil }
        return mapSpaceRealLocation
    }
    
    
    // MARK: - Process
    
    func process(locations: [CLLocation]) {
        guard let tracker = tracker else { return }
        
        switch tracker.mode {
        case .tracking: _map(locations: locations) // TODO: revisit
        case .mapping: _map(locations: locations)
        }
        _updateUserLocation(locations: locations)
    }
    
    func process(frame: ARFrame) {
        guard let tracker = tracker else { return }
        
        switch tracker.mode {
        case .tracking: _map(frame: frame) // TODO: revisit
        case .mapping: _map(frame: frame)
        }
        _updateUserLocation(frame: frame)
    }
    
    
    // MARK: Track
    
    private func _track(locations: [CLLocation]) {
        
    }
    
    private func _track(frame: ARFrame) {
        
    }
    
    
    // MARK: Map
    
    private func _map(locations: [CLLocation]) {
        guard _uncombinedFrames.count > 0 else { return }
        _uncombinedLocations.append(contentsOf: locations)
    }
    
    private func _map(frame: ARFrame) {
        let uncombinedFrame = Frame(
            timestamp: frame.timestamp,
            cameraTransform: frame.camera.transform
        )
        _uncombinedFrames.append(uncombinedFrame)
        
        // Get location points and add them to map
        let locationPoints = combineUncombinedData()
        if !locationPoints.isEmpty {
            tracker?.snapshotManager.snap(locationPoints: locationPoints)
        }
        
        guard !locationPoints.isEmpty,
              let mapAnchor = frame.mapAnchor,
              let tracker = tracker
        else { return }
        
        let mapSpaceLocationPoints = mapAnchor.moveIn(locationPoints)
        tracker.map.pointCloud.add(mapSpaceLocationPoints)
        
        let cameraPoint = CameraPoint(camera: frame.camera)
        cameraPoint.add(locationPoints)
        let mapSpaceCameraPoint = mapAnchor.moveIn(cameraPoint)
        tracker.map.pointCloud.add(mapSpaceCameraPoint)
        
        tracker.delegate?.locationManager(self, didAdd: mapSpaceLocationPoints)
        
    }
    
    private func _updateUserLocation(locations: [CLLocation]) {
        guard let manager = externalManager, let delegate = externalManager?.delegate else { return }
        
        if case .relocalizing = tracker?.state {
            delegate.locationManager(manager, didUpdateLocations: locations)
        }
    }
    
    private func _updateUserLocation(frame: ARFrame) {
        guard let manager = externalManager, let delegate = externalManager?.delegate else { return }
        
        if case .normal = tracker?.state {
            guard let location = estimatedRealLocation(frame: frame) else { return }
            
            delegate.locationManager(manager, didUpdateLocations: [location])
        }
    }
    
}
