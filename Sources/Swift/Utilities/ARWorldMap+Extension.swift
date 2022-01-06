//
//  File.swift
//  
//
//  Created by Jean Flaherty on 6/25/21.
//

import Foundation
import ARKit

extension ARWorldMap {
    
    @inline(__always)
    var mapData: GeoARMap? {
        return mapAnchor?.map
    }
    
    @inline(__always)
    var mapAnchor: GeoARMapAnchor? {
        return anchors.first(where: { $0 is GeoARMapAnchor }) as? GeoARMapAnchor
    }
    
}
