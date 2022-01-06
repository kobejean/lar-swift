//
//  GeoARLocationManagerDelegate.swift
//  
//
//  Created by Jean Flaherty on 6/13/21.
//

import Foundation
import CoreLocation


public protocol GeoARLocationManagerDelegate: NSObjectProtocol {
    
    func locationManager(_ manager: GeoARLocationManager, didUpdateLocations locations: [CLLocation])
    
    func locationManager(_ manager: GeoARLocationManager, didUpdateHeading newHeading: CLHeading)
    
}

public extension GeoARLocationManagerDelegate {
    
    func locationManager(_ manager: GeoARLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: GeoARLocationManager, didUpdateHeading newHeading: CLHeading) {
        
    }
    
}
