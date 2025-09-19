//
//  LARFrame.swift
//  
//
//  Created by Jean Flaherty on 2025-07-03.
//

import Foundation
import opencv2
import simd

public extension LARFrame {
    
    static func loadFrames(from url: URL) -> [LARFrame]? {
        return LARFrame.loadFrames(fromFile: url.path)
    }
    
    var id: Int {
        return Int(frameId)
    }
    
    // Helper to get transform as simd_double4x4
    var transform: simd_double4x4 {
        // Convert simd_float4x4 to simd_double4x4
        return simd_double4x4(
            simd_double4(Double(extrinsics.columns.0.x), Double(extrinsics.columns.0.y), Double(extrinsics.columns.0.z), Double(extrinsics.columns.0.w)),
            simd_double4(Double(extrinsics.columns.1.x), Double(extrinsics.columns.1.y), Double(extrinsics.columns.1.z), Double(extrinsics.columns.1.w)),
            simd_double4(Double(extrinsics.columns.2.x), Double(extrinsics.columns.2.y), Double(extrinsics.columns.2.z), Double(extrinsics.columns.2.w)),
            simd_double4(Double(extrinsics.columns.3.x), Double(extrinsics.columns.3.y), Double(extrinsics.columns.3.z), Double(extrinsics.columns.3.w))
        )
    }
}