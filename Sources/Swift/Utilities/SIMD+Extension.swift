//
//  File.swift
//  
//
//  Created by Jean Flaherty on 6/25/21.
//

import Foundation
import simd

extension simd_float4x4 {
    var flattened: [Float] {
        return [
            self[0,0], self[0,1], self[0,2], self[0,3],
            self[1,0], self[1,1], self[1,2], self[1,3],
            self[2,0], self[2,1], self[2,2], self[2,3],
            self[3,0], self[3,1], self[3,2], self[3,3]
        ]
    }
    
    init(_ flattened: [Float]) {
        self.init(
            .init(flattened[0], flattened[1], flattened[2], flattened[3]),
            .init(flattened[4], flattened[5], flattened[6], flattened[7]),
            .init(flattened[8], flattened[9], flattened[10], flattened[11]),
            .init(flattened[12], flattened[13], flattened[14], flattened[15])
        )
    }
    
    var rigidInverse: simd_float4x4 {
        let inverseRotation = simd_float3x4(
            .init(self[0,0], self[1,0], self[2,0], 0),
            .init(self[0,1], self[1,1], self[2,1], 0),
            .init(self[0,2], self[1,2], self[2,2], 0)
        )
        var inverseTranslation = -inverseRotation * simd_make_float3(self[3])
        inverseTranslation.w = 1 / self[3,3]
        return simd_float4x4(inverseRotation[0], inverseRotation[1], inverseRotation[2], inverseTranslation)
    }
}
