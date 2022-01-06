//
//  GeoARTracker.swift
//  
//
//  Created by Jean Flaherty on 7/17/21.
//

import Foundation
import ARKit

public class GeoARTracker {
    public var debugString = ""
    let internalTracker = InternalTracker()
    public let locationManager: GeoARLocationManager
    
    weak var internalDelegate: GeoARTrackerDelegate?
    public weak var delegate: GeoARTrackerDelegate?
    
    public var map: GeoARMap { internalTracker.map }
    public var state: GeoARTrackerState { internalTracker.state }
    public var mode: GeoARTrackerMode {
        get { return internalTracker.mode }
        set { internalTracker.mode = newValue }
    }
    
    init() {
        self.locationManager = GeoARLocationManager(internalManager: internalTracker.locationManager)
        self.internalTracker.externalTracker = self
    }
    
    public func add(anchor: GeoARAnchor) {
        guard let mapAnchor = internalTracker.mapAnchor else { return }
        let mapSpaceAnchor = mapAnchor.moveIn(anchor)
        map.anchors.append(mapSpaceAnchor)
        
        internalDelegate?.tracker(self, didAdd: [mapSpaceAnchor])
        delegate?.tracker(self, didAdd: [mapSpaceAnchor])
    }
    
    public func setMap(_ map: GeoARMap) {
        internalTracker.setMap(map)
    }
    
    public func snapFrame() {
        internalTracker.snapFrame()
    }
    
    public func save() {
        internalTracker.snapshotManager.save()
    }
}
