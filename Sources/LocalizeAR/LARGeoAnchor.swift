//
//  File.swift
//  
//
//  Created by Jean Flaherty on 2025/05/26.
//

import Foundation
import CoreLocation

public class LARGeoAnchor {
    public var anchor: LARAnchor
    public var location: CLLocation
    public init(anchor: LARAnchor, location: CLLocation) {
        self.anchor = anchor
        self.location = location
    }
}
