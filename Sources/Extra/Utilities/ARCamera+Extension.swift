//
//  ARCamera+Extension.swift
//  
//
//  Created by Jean Flaherty on 6/14/21.
//

import Foundation
import ARKit

extension ARCamera {
    
    /// A matrix transformation from 2d image coordinates to a direction vector for raycasting
    var directionMatrix: simd_float3x3 {
        let cameraRotation = simd_float3x3(
            simd_make_float3(transform.columns.0),
            simd_make_float3(transform.columns.1),
            simd_make_float3(transform.columns.2)
        )
        var unprojectionMatrix = intrinsics.inverse
        // y-axis and z-axis needs to be flipped
        unprojectionMatrix[1,1] = -unprojectionMatrix[1,1]
        unprojectionMatrix[2,1] = -unprojectionMatrix[2,1]
        unprojectionMatrix[2,2] = -unprojectionMatrix[2,2]
        return cameraRotation * unprojectionMatrix
    }
    
}
