//
//  SCNSphere.swift
//  LARScan
//
//  Created by Jean Flaherty on 2022/01/31.
//

import Foundation
import SceneKit
import simd

class SCNScreenSpaceScaleConstraint : SCNTransformConstraint {
    
    override init() {
        super.init()
    }
    
    convenience init(pointOfView: SCNNode) {
        self.init(inWorldSpace: true) { node, transform in
            let x = simd_float3(transform.m11, transform.m12, transform.m13)
            let nodePosition = simd_float3(transform.m41, transform.m42, transform.m43)
            let camPosition = pointOfView.simdWorldPosition
            let camDistance = simd_distance(camPosition, nodePosition)
            let scale = max(camDistance, 0.5) / simd_length(x)
            var newTransform = transform
            newTransform.m11 *= scale
            newTransform.m12 *= scale
            newTransform.m13 *= scale
            newTransform.m21 *= scale
            newTransform.m22 *= scale
            newTransform.m23 *= scale
            newTransform.m31 *= scale
            newTransform.m32 *= scale
            newTransform.m33 *= scale
            return newTransform
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
