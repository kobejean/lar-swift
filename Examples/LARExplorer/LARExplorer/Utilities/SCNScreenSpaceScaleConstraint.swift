////
////  SCNScreenSpaceScaleConstraint.swift
////  LARExplorer
////
////  Created by Jean Flaherty on 2025-07-03.
////
//
//import Foundation
//import SceneKit
//import simd
//
//class SCNScreenSpaceScaleConstraint: SCNTransformConstraint {
//    
//    override init() {
//        super.init()
//    }
//    
//    convenience init(pointOfView: SCNNode, scaleFactor: CGFloat = AppConfiguration.PointCloud.Localization.scaleDistanceFactor) {
//        self.init(inWorldSpace: true) { node, transform in
//            let currentScale = simd_length(
//                simd_float3(Float(transform.m11), Float(transform.m12), Float(transform.m13))
//            )
//            let nodePosition = simd_float3(Float(transform.m41), Float(transform.m42), Float(transform.m43))
//            let camPosition = pointOfView.simdWorldPosition
//            let camDistance = simd_distance(camPosition, nodePosition)
//            
//            // Scale based on distance with configurable factor
//            let scale = CGFloat(max(camDistance / Float(scaleFactor), 1.0) / currentScale)
//            
//            var newTransform = transform
//            newTransform.m11 *= scale
//            newTransform.m12 *= scale
//            newTransform.m13 *= scale
//            newTransform.m21 *= scale
//            newTransform.m22 *= scale
//            newTransform.m23 *= scale
//            newTransform.m31 *= scale
//            newTransform.m32 *= scale
//            newTransform.m33 *= scale
//            return newTransform
//        }
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}



import Foundation
import SceneKit
import simd

class SCNScreenSpaceScaleConstraint : SCNTransformConstraint {
	
	override init() {
		super.init()
	}
	
	convenience init(pointOfView: SCNNode) {
		self.init(inWorldSpace: true) {
 node,
			transform in
			let currentScale = simd_length(
				simd_float3(Float(transform.m11), Float(transform.m12), Float(transform.m13))
			)
			let nodePosition = simd_float3(Float(transform.m41), Float(transform.m42), Float(transform.m43))
			let camPosition = pointOfView.simdWorldPosition
			let camDistance = simd_distance(camPosition, nodePosition)
			let scale = 0.15*CGFloat(max(camDistance, 10.0) / currentScale)
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
