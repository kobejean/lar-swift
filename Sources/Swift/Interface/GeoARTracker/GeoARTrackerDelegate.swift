//
//  GeoARMapTrackerDelegate.swift
//  
//
//  Created by Jean Flaherty on 6/13/21.
//

import Foundation
import ARKit


public protocol GeoARTrackerDelegate: ARSessionDelegate {
    
    func tracker(_ tracker: GeoARTracker, didAdd anchors: [GeoARAnchor])
    
    func tracker(_ tracker: GeoARTracker, didChange state: GeoARTrackerState)
    
}

public extension GeoARTrackerDelegate {
    
    func tracker(_ tracker: GeoARTracker, didAdd anchors: [GeoARAnchor]) {
        
    }
    
    func tracker(_ tracker: GeoARTracker, didChange state: GeoARTrackerState) {
        
    }
    
}
