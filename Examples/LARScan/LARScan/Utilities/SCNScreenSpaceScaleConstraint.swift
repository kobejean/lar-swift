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
            let nodePosition = simd_float3(transform.m41, transform.m42, transform.m43)
            let camPosition = simd_float3(pointOfView.worldPosition)
            let camDistance = simd_distance(camPosition, nodePosition)
            let scale = max(camDistance, 0.5)
            var newTransform = transform
            newTransform.m11 = scale
            newTransform.m22 = scale
            newTransform.m33 = scale
            return newTransform
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
