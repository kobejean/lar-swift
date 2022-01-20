//
//  GeoARMapMovable.swift
//  
//
//  Created by Jean Flaherty on 7/17/21.
//

import Foundation
import simd

protocol GeoARMapMovable {
    
    func move(relativeTransform: simd_float4x4) -> Self
    
}
