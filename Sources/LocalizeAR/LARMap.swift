//
//  File 2.swift
//  
//
//  Created by Jean Flaherty on 2022/02/02.
//

import Foundation
import LocalizeAR_ObjC

public extension LARMap {
    
    func globalPoint(from relative: simd_double3) -> simd_double3? {
        var global = simd_double3()
        guard globalPoint(from: relative, global: &global) else { return nil }
        return global
    }
    
    func relativePoint(from global: simd_double3) -> simd_double3? {
        var relative = simd_double3()
        guard relativePoint(from: global, relative: &relative) else { return nil }
        return relative
    }
    
}
