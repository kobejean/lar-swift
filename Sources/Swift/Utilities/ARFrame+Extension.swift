//
//  File.swift
//  
//
//  Created by Jean Flaherty on 6/25/21.
//

import Foundation
import ARKit

extension ARFrame {
    
    var mapAnchor: GeoARMapAnchor? {
        for anchor in anchors {
            if let mapAnchor = anchor as? GeoARMapAnchor {
                return mapAnchor
            }
        }
        return nil
    }
    
}

