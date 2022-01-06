//
//  GeoARSession.swift
//  
//
//  Created by Jean Flaherty on 6/13/21.
//

import Foundation
import ARKit

open class GeoARSession: ARSession {
    
    public var tracker = GeoARTracker()
    
    override init() {
        super.init()
        tracker.internalTracker.session = self
    }
    
}
