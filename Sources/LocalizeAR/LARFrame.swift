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
    
    convenience init(id: Int, timestamp: Int64, intrinsics: Mat, extrinsics: Mat) {
        self.init(id: id, timestamp: timestamp, intrinsics: intrinsics, extrinsics: extrinsics)
    }
    
    static func loadFrames(from url: URL) -> [LARFrame]? {
        return LARFrame.loadFrames(fromFile: url.path)
    }
    
    var id: Int {
        return Int(frameId)
    }
    
    // Helper to get transform as simd_double4x4
    var transform: simd_double4x4 {
        return extrinsics.toSIMD()
    }
}