//
//  LARMap.swift
//  
//
//  Created by Jean Flaherty on 2022/02/02.
//

import Foundation
import CoreLocation
import LocalizeAR_ObjC

public extension LARMap {
    
    func globalPoint(from relative: simd_double3) -> simd_double3 {
        var global = simd_double3()
        globalPoint(from: relative, global: &global)
        return global
    }
    
    func globalPoint(from anchor: LARAnchor) -> simd_double3 {
        var global = simd_double3()
        globalPoint(from: anchor, global: &global)
        return global
    }
    
    func relativePoint(from global: simd_double3) -> simd_double3 {
        var relative = simd_double3()
        relativePoint(from: global, relative: &relative)
        return relative
    }
    
    func location(from relative: simd_double3) -> CLLocation {
        let global = globalPoint(from: relative)
        return CLLocation(latitude: global.x, longitude: global.y)
    }
    
    func location(from anchor: LARAnchor) -> CLLocation {
        let global = globalPoint(from: anchor)
        return CLLocation(latitude: global.x, longitude: global.y)
    }
    
}
