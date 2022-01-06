//
//  GeoARSCNView.MapRenderer+InternalTrackerDelegate.swift
//  
//
//  Created by Jean Flaherty on 7/7/21.
//

import Foundation
import SceneKit
import ARKit


extension GeoARSCNView.MapRenderer: GeoARTrackerDelegate {
    
    
    // MARK: GeoARTrackerDelegate
    
    func tracker(_ tracker: GeoARTracker, didAdd anchors: [GeoARAnchor]) {
        renderAnchors(anchors: anchors)
    }
    
    func tracker(_ tracker: GeoARTracker, didChange state: GeoARTrackerState) {
        if case .normal = state {
            renderAnchors(anchors: tracker.map.anchors)
        }
    }
}
