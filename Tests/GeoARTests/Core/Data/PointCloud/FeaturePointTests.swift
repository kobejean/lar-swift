//
//  FeaturePointTests.swift
//  
//
//  Created by Jean Flaherty on 7/7/21.
//

import XCTest
import simd
@testable import GeoAR

final class FeaturePointTests: XCTestCase {
    
    func testCodable() throws {
        // Given
        let transform = simd_float4x4([[0,1,2,3],[4,5,6,7],[8,9,10,11],[12,13,14,15]])
        let featurePoint = FeaturePoint(transform: transform, descriptor: [0,1,2,3])
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        let decoder = PropertyListDecoder()
        // When
        let data = try encoder.encode(featurePoint)
        let decodedFeaturePoint = try decoder.decode(FeaturePoint.self, from: data)
        // Then
        
        // Transform
        XCTAssertEqual(decodedFeaturePoint.transform[0,0], 0)
        XCTAssertEqual(decodedFeaturePoint.transform[0,1], 1)
        XCTAssertEqual(decodedFeaturePoint.transform[0,2], 2)
        XCTAssertEqual(decodedFeaturePoint.transform[0,3], 3)
        XCTAssertEqual(decodedFeaturePoint.transform[1,0], 4)
        XCTAssertEqual(decodedFeaturePoint.transform[1,1], 5)
        XCTAssertEqual(decodedFeaturePoint.transform[1,2], 6)
        XCTAssertEqual(decodedFeaturePoint.transform[1,3], 7)
        XCTAssertEqual(decodedFeaturePoint.transform[2,0], 8)
        XCTAssertEqual(decodedFeaturePoint.transform[2,1], 9)
        XCTAssertEqual(decodedFeaturePoint.transform[2,2], 10)
        XCTAssertEqual(decodedFeaturePoint.transform[2,3], 11)
        XCTAssertEqual(decodedFeaturePoint.transform[3,0], 12)
        XCTAssertEqual(decodedFeaturePoint.transform[3,1], 13)
        XCTAssertEqual(decodedFeaturePoint.transform[3,2], 14)
        XCTAssertEqual(decodedFeaturePoint.transform[3,3], 15)
        // Descriptor
        XCTAssertEqual(decodedFeaturePoint.descriptor[0], 0)
        XCTAssertEqual(decodedFeaturePoint.descriptor[1], 1)
        XCTAssertEqual(decodedFeaturePoint.descriptor[2], 2)
        XCTAssertEqual(decodedFeaturePoint.descriptor[3], 3)
    }
    
    func testHashable() throws {
        // Given
        let transform = simd_float4x4([[0,1,2,3],[4,5,6,7],[8,9,10,11],[12,13,14,15]])
        let featurePointA = FeaturePoint(transform: transform, descriptor: [0,1,2,3])
        let featurePointB = FeaturePoint(transform: transform, descriptor: [0,1,2,3], identifier: featurePointA.identifier)
        let featurePointC = FeaturePoint(transform: transform, descriptor: [0,1,2,3])
        // When
        let hashA = featurePointA.hash
        let hashB = featurePointB.hash
        let hashC = featurePointC.hash
        let hashValueA = featurePointA.hashValue
        let hashValueB = featurePointB.hashValue
        let hashValueC = featurePointC.hashValue
        // Then
        
        // A and B should be equal
        XCTAssertEqual(featurePointA, featurePointB)
        XCTAssertEqual(hashA, hashB)
        XCTAssertEqual(hashValueA, hashValueB)
        // A and C should not be equal
        XCTAssertNotEqual(featurePointA, featurePointC)
        XCTAssertNotEqual(hashA, hashC)
        XCTAssertNotEqual(hashValueA, hashValueC)
    }
    
    func testComputedProporties() {
        // Given
        let transform = simd_float4x4([[0.5,0,0,0],[0,0.5,0,0],[0,0,2,0],[3,1,5,1]])
        let featurePoint = FeaturePoint(transform: transform, descriptor: [0,1,2,3])
        // When
        let point = featurePoint.point
        let cameraPoint = featurePoint.cameraPoint
        let boundingRectMin = featurePoint.boundingRectMin
        let boundingRectMax = featurePoint.boundingRectMax
        let size = featurePoint.size
        // Then
        
        // Point
        XCTAssertEqual(point.x, 3, accuracy: 1e-5)
        XCTAssertEqual(point.y, 1, accuracy: 1e-5)
        XCTAssertEqual(point.z, 5, accuracy: 1e-5)
        // Camera Point
        XCTAssertEqual(cameraPoint.x, 3, accuracy: 1e-5)
        XCTAssertEqual(cameraPoint.y, 1, accuracy: 1e-5)
        XCTAssertEqual(cameraPoint.z, 7, accuracy: 1e-5)
        // Bounding rect min
        XCTAssertEqual(boundingRectMin.x, 3, accuracy: 1e-5)
        XCTAssertEqual(boundingRectMin.y, 7, accuracy: 1e-5)
        // Bounding rect max
        XCTAssertEqual(boundingRectMax.x, 3, accuracy: 1e-5)
        XCTAssertEqual(boundingRectMax.y, 7, accuracy: 1e-5)
        // Size
        XCTAssertEqual(size, 0.5, accuracy: 1e-5)
    }
    
    func testMove() {
        // Given
        let transform = simd_float4x4([[0.5,0,0,0],[0,0.25,0,0],[0,0,2,0],[3,1,5,1]])
        let featurePoint = FeaturePoint(transform: transform, descriptor: [0,1,2,3])
        let relativeTransform = simd_float4x4([[0,0,1,0],[1,0,0,0],[0,1,0,0],[1,2,3,1]])
        // When
        let moved = featurePoint.move(relativeTransform: relativeTransform)
        // Then
        XCTAssertEqual(moved.transform[0,0], 0, accuracy: 1e-5)
        XCTAssertEqual(moved.transform[0,1], 0, accuracy: 1e-5)
        XCTAssertEqual(moved.transform[0,2], 0.5, accuracy: 1e-5)
        XCTAssertEqual(moved.transform[0,3], 0, accuracy: 1e-5)
        XCTAssertEqual(moved.transform[1,0], 0.25, accuracy: 1e-5)
        XCTAssertEqual(moved.transform[1,1], 0, accuracy: 1e-5)
        XCTAssertEqual(moved.transform[1,2], 0, accuracy: 1e-5)
        XCTAssertEqual(moved.transform[1,3], 0, accuracy: 1e-5)
        XCTAssertEqual(moved.transform[2,0], 0, accuracy: 1e-5)
        XCTAssertEqual(moved.transform[2,1], 2, accuracy: 1e-5)
        XCTAssertEqual(moved.transform[2,2], 0, accuracy: 1e-5)
        XCTAssertEqual(moved.transform[2,3], 0, accuracy: 1e-5)
        XCTAssertEqual(moved.transform[3,0], 2, accuracy: 1e-5)
        XCTAssertEqual(moved.transform[3,1], 7, accuracy: 1e-5)
        XCTAssertEqual(moved.transform[3,2], 6, accuracy: 1e-5)
        XCTAssertEqual(moved.transform[3,3], 1, accuracy: 1e-5)
    }
    
}

