//
//  SnapshotManager.FrameMetadata.swift
//  
//
//  Created by Jean Flaherty on 11/10/21.
//

import Foundation
import ARKit

extension SnapshotManager {
    
    class FrameMetadata: Codable {
        let id: Int
        let transform: simd_float4x4
        let intrinsics: Intrinsics
        let timestamp: TimeInterval
        
        required init(id: Int, transform: simd_float4x4, intrinsics: Intrinsics, timestamp: TimeInterval) {
            self.id = id
            self.transform = transform
            self.intrinsics = intrinsics
            self.timestamp = timestamp
        }
        
        init(id: Int, frame: ARFrame) {
            self.id = id
            self.timestamp = frame.timestamp
            self.transform = frame.camera.transform
            self.intrinsics = Intrinsics(intrinsics: frame.camera.intrinsics)
        }
        
        func move(relativeTransform: simd_float4x4) -> Self {
            let newTransform = relativeTransform * transform
            let other = Self(id: id, transform: newTransform, intrinsics: intrinsics, timestamp: timestamp)
            return other
        }
        
        // MARK: Codable
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case transform = "transform"
            case intrinsics = "intrinsics"
            case timestamp = "timestamp"
        }
    }
    
    struct Intrinsics: Codable {
        let focalLength: Float
        let principlePoint: Point
        
        init(intrinsics: simd_float3x3) {
            self.focalLength = intrinsics[0,0]
            self.principlePoint = Point(x: intrinsics[2,0], y: intrinsics[2,1])
        }
    }
    
    struct Point: Codable {
        let x: Float
        let y: Float
    }
}
