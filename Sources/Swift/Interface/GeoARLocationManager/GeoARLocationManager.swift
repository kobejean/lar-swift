//
//  GeoARLocationManager.swift
//  
//
//  Created by Jean Flaherty on 7/25/21.
//

import Foundation

public class GeoARLocationManager {
    let internalManager: LocationManager
    public weak var delegate: GeoARLocationManagerDelegate?
    
    init(internalManager: LocationManager) {
        self.internalManager = internalManager
        internalManager.externalManager = self
    }
}
