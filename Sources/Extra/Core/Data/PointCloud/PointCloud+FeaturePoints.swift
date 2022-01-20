//
//  PointCloud+FeaturePoints.swift
//  
//
//  Created by Jean Flaherty on 6/26/21.
//

import Foundation
import GameKit
import simd


extension PointCloud {
    
    func add(_ featurePoints: [FeaturePoint]) {
        self.featurePoints.formUnion(featurePoints)
        self.featurePointsRTree.add(featurePoints)
    }
    
    func remove(_ featurePoints: [FeaturePoint]) {
        self.featurePoints.subtract(featurePoints)
        self.featurePointsRTree.remove(featurePoints)
    }
    
    func featurnPoints(inBoundCenter center: simd_float2, radius: Float) -> [FeaturePoint] {
        let rectMin = simd_float2(center.x - radius, center.y - radius)
        let rectMax = simd_float2(center.x + radius, center.y + radius)
        return self.featurePointsRTree.elements(inBoundingRectMin: rectMin, rectMax: rectMax)
    }
    
}


// MARK: GKRTree Extension

extension GKRTree where ElementType == FeaturePoint {
    
    func add(_ featurePoints: [FeaturePoint]) {
        for featurePoint in featurePoints {
            self.addElement(
                featurePoint,
                boundingRectMin: featurePoint.boundingRectMin,
                boundingRectMax: featurePoint.boundingRectMax,
                splitStrategy: .reduceOverlap)
        }
    }
    
    func remove(_ featurePoints: [FeaturePoint]) {
        for featurePoint in featurePoints {
            self.removeElement(
                featurePoint,
                boundingRectMin: featurePoint.boundingRectMin,
                boundingRectMax: featurePoint.boundingRectMax)
        }
    }
    
}
