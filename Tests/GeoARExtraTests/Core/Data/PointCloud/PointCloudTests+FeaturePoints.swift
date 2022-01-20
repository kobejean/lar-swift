//
//  PointCloudTests.swift
//
//
//  Created by Jean Flaherty on 7/6/21.
//

import XCTest
import simd
@testable import GeoARExtra

extension PointCloudTests {
    
    func testAddFeaturePoints() {
        // Given
        let transform = simd_float4x4([[0,1,2,3],[4,5,6,7],[8,9,10,11],[12,13,14,15]])
        let featurePoints = [
            FeaturePoint(transform: transform, descriptor: [0,1,2,3]),
            FeaturePoint(transform: transform, descriptor: [4,5,6,7]),
            FeaturePoint(transform: transform, descriptor: [8,9,10,11])
        ]
        let pointCloud = PointCloud()
        // When
        pointCloud.add(featurePoints)
        // Then
        XCTAssert(featurePoints.allSatisfy({ pointCloud.featurePoints.contains($0) }))
    }
    
    func testRemoveFeaturePoints() {
        // Given
        let transform = simd_float4x4([[0,1,2,3],[4,5,6,7],[8,9,10,11],[12,13,14,15]])
        let featurePoints = [
            FeaturePoint(transform: transform, descriptor: [0,1,2,3]),
            FeaturePoint(transform: transform, descriptor: [4,5,6,7]),
            FeaturePoint(transform: transform, descriptor: [8,9,10,11])
        ]
        let pointCloud = PointCloud()
        pointCloud.add(featurePoints)
        // When
        pointCloud.remove(featurePoints)
        // Then
        XCTAssert(pointCloud.featurePoints.isEmpty)
    }
    
}

