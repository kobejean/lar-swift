//
//  Conversions.swift
//  
//
//  Created by Jean Flaherty on 5/30/21.
//

import Foundation
import ARKit
import SceneKit

extension BinaryInteger {
    var degreesToRadians: CGFloat { CGFloat(self) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { self * .pi / 180 }
    var radiansToDegrees: Self { self * 180 / .pi }
}

extension simd_float4x4 {
    static private let _uprightPointer: simd_float4 = [1,0,1,0]
    static private let _upsideDownPointer: simd_float4 = [1,0,-1,0]
    static private let _pointerAxes = simd_float2x4(columns: (_uprightPointer, _upsideDownPointer))
    
    func transformToHeading() -> simd_float2 {
        let (uprightPointer, updiseDownPointer) = (self * simd_float4x4._pointerAxes).columns
        let uprightWeight = max(-uprightPointer.y, 0.05)
        let upsideDownWeight = max(updiseDownPointer.y, 0.05)
        let alpha = uprightWeight / (uprightWeight + upsideDownWeight)
        let pointer = alpha * uprightPointer + (1 - alpha) * upsideDownWeight
        return [pointer.x, pointer.z]
    }
}
