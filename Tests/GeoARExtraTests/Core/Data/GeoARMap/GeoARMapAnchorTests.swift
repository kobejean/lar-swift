//
//  File.swift
//  
//
//  Created by Jean Flaherty on 7/9/21.
//

import XCTest
import simd
import CoreLocation
@testable import GeoARExtra

final class GeoARMapAnchorTests: XCTestCase {
    
    
    // MARK: Moving FeaturePoints
    
    func testMoveInFeaturePoints() throws {
        // Given
        let map = GeoARMap()
        let mapAnchorTransform = simd_float4x4([[0,0,1,0],[1,0,0,0],[0,1,0,0],[-1,-2,-3,1]])
        let mapAnchor = GeoARMapAnchor(transform: mapAnchorTransform, map: map)
        let featurePointTransform = simd_float4x4([[0.5,0,0,0],[0,0.25,0,0],[0,0,2,0],[3,1,5,1]])
        let featurePoints = [FeaturePoint(transform: featurePointTransform, descriptor: [0,1,2,3])]
        // When
        let movedFeaturePoints = mapAnchor.moveIn(featurePoints)
        // Then
        let movedFeaturePoint = try XCTUnwrap(movedFeaturePoints.first)
        XCTAssertEqual(movedFeaturePoint.transform[0,0], 0, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[0,1], 0.5, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[0,2], 0, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[0,3], 0, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[1,0], 0, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[1,1], 0, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[1,2], 0.25, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[1,3], 0, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[2,0], 2, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[2,1], 0, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[2,2], 0, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[2,3], 0, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[3,0], 8, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[3,1], 4, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[3,2], 3, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[3,3], 1, accuracy: 1e-7)
    }
    
    func testMoveOutFeaturePoints() throws {
        // Given
        let map = GeoARMap()
        let mapAnchorTransform = simd_float4x4([[0,0,1,0],[1,0,0,0],[0,1,0,0],[1,2,3,1]])
        let mapAnchor = GeoARMapAnchor(transform: mapAnchorTransform, map: map)
        let featurePointTransform = simd_float4x4([[0.5,0,0,0],[0,0.25,0,0],[0,0,2,0],[3,1,5,1]])
        let featurePoints = [FeaturePoint(transform: featurePointTransform, descriptor: [0,1,2,3])]
        // When
        let movedFeaturePoints = mapAnchor.moveOut(featurePoints)
        // Then
        let movedFeaturePoint = try XCTUnwrap(movedFeaturePoints.first)
        XCTAssertEqual(movedFeaturePoint.transform[0,0], 0, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[0,1], 0, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[0,2], 0.5, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[0,3], 0, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[1,0], 0.25, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[1,1], 0, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[1,2], 0, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[1,3], 0, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[2,0], 0, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[2,1], 2, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[2,2], 0, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[2,3], 0, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[3,0], 2, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[3,1], 7, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[3,2], 6, accuracy: 1e-7)
        XCTAssertEqual(movedFeaturePoint.transform[3,3], 1, accuracy: 1e-7)
    }
    
    
    // MARK: Moving Vectors
    
    func testMoveInVector() throws {
        // Given
        let map = GeoARMap()
        let mapAnchorTransform = simd_float4x4([[0,0,1,0],[0,1,0,0],[1,0,0,0],[1,2,3,1]])
        let mapAnchor = GeoARMapAnchor(transform: mapAnchorTransform, map: map)
        let vector = simd_float2(3, 4)
        // When
        let movedVector = mapAnchor.moveIn(vector)
        // Then
        XCTAssertEqual(movedVector.x, 1, accuracy: 1e-7)
        XCTAssertEqual(movedVector.y, 2, accuracy: 1e-7)
    }
    
    func testMoveOutVector() throws {
        // Given
        let map = GeoARMap()
        let mapAnchorTransform = simd_float4x4([[0,0,1,0],[0,1,0,0],[1,0,0,0],[1,2,3,1]])
        let mapAnchor = GeoARMapAnchor(transform: mapAnchorTransform, map: map)
        let vector = simd_float2(3, 4)
        // When
        let movedVector = mapAnchor.moveOut(vector)
        // Then
        XCTAssertEqual(movedVector.x, 5, accuracy: 1e-7)
        XCTAssertEqual(movedVector.y, 6, accuracy: 1e-7)
    }
    
    
    // MARK: Moving LocationPoints
    
    func testMoveInLocationPoint() throws {
        // Given
        let map = GeoARMap()
        let mapAnchorTransform = simd_float4x4([[0,0,1,0],[1,0,0,0],[0,1,0,0],[-1,-2,-3,1]])
        let mapAnchor = GeoARMapAnchor(transform: mapAnchorTransform, map: map)
        let locationPointTransform = simd_float4x4([[0.5,0,0,0],[0,0.25,0,0],[0,0,2,0],[3,1,5,1]])
        let location = CLLocation(
            coordinate: CLLocationCoordinate2DMake(35.360608995766592, 138.727410981504949),
            altitude: 12388,
            horizontalAccuracy: 5,
            verticalAccuracy: 1,
            timestamp: Date(timeIntervalSince1970: 0)
        )
        let locationPoint = LocationPoint(transform: locationPointTransform, location: location)
        // When
        let movedLocationPoint = mapAnchor.moveIn(locationPoint)
        // Then
        XCTAssertEqual(movedLocationPoint.transform[0,0], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[0,1], 0.5, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[0,2], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[0,3], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[1,0], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[1,1], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[1,2], 0.25, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[1,3], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[2,0], 2, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[2,1], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[2,2], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[2,3], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[3,0], 8, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[3,1], 4, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[3,2], 3, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[3,3], 1, accuracy: 1e-7)
    }
    
    func testMoveOutLocationPoint() throws {
        // Given
        let map = GeoARMap()
        let mapAnchorTransform = simd_float4x4([[0,0,1,0],[1,0,0,0],[0,1,0,0],[1,2,3,1]])
        let mapAnchor = GeoARMapAnchor(transform: mapAnchorTransform, map: map)
        let locationPointTransform = simd_float4x4([[0.5,0,0,0],[0,0.25,0,0],[0,0,2,0],[3,1,5,1]])
        let location = CLLocation(
            coordinate: CLLocationCoordinate2DMake(35.360608995766592, 138.727410981504949),
            altitude: 12388,
            horizontalAccuracy: 5,
            verticalAccuracy: 1,
            timestamp: Date(timeIntervalSince1970: 0)
        )
        let locationPoint = LocationPoint(transform: locationPointTransform, location: location)
        // When
        let movedLocationPoint = mapAnchor.moveOut(locationPoint)
        // Then
        XCTAssertEqual(movedLocationPoint.transform[0,0], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[0,1], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[0,2], 0.5, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[0,3], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[1,0], 0.25, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[1,1], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[1,2], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[1,3], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[2,0], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[2,1], 2, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[2,2], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[2,3], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[3,0], 2, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[3,1], 7, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[3,2], 6, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[3,3], 1, accuracy: 1e-7)
    }
    
    func testMoveInLocationPoints() throws {
        // Given
        let map = GeoARMap()
        let mapAnchorTransform = simd_float4x4([[0,0,1,0],[1,0,0,0],[0,1,0,0],[-1,-2,-3,1]])
        let mapAnchor = GeoARMapAnchor(transform: mapAnchorTransform, map: map)
        let locationPointTransform = simd_float4x4([[0.5,0,0,0],[0,0.25,0,0],[0,0,2,0],[3,1,5,1]])
        let location = CLLocation(
            coordinate: CLLocationCoordinate2DMake(35.360608995766592, 138.727410981504949),
            altitude: 12388,
            horizontalAccuracy: 5,
            verticalAccuracy: 1,
            timestamp: Date(timeIntervalSince1970: 0)
        )
        let locationPoints = [LocationPoint(transform: locationPointTransform, location: location)]
        // When
        let movedLocationPoints = mapAnchor.moveIn(locationPoints)
        // Then
        let movedLocationPoint = try XCTUnwrap(movedLocationPoints.first)
        XCTAssertEqual(movedLocationPoint.transform[0,0], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[0,1], 0.5, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[0,2], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[0,3], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[1,0], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[1,1], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[1,2], 0.25, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[1,3], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[2,0], 2, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[2,1], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[2,2], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[2,3], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[3,0], 8, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[3,1], 4, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[3,2], 3, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[3,3], 1, accuracy: 1e-7)
    }
    
    func testMoveOutLocationsPoint() throws {
        // Given
        let map = GeoARMap()
        let mapAnchorTransform = simd_float4x4([[0,0,1,0],[1,0,0,0],[0,1,0,0],[1,2,3,1]])
        let mapAnchor = GeoARMapAnchor(transform: mapAnchorTransform, map: map)
        let locationPointTransform = simd_float4x4([[0.5,0,0,0],[0,0.25,0,0],[0,0,2,0],[3,1,5,1]])
        let location = CLLocation(
            coordinate: CLLocationCoordinate2DMake(35.360608995766592, 138.727410981504949),
            altitude: 12388,
            horizontalAccuracy: 5,
            verticalAccuracy: 1,
            timestamp: Date(timeIntervalSince1970: 0)
        )
        let locationPoints = [LocationPoint(transform: locationPointTransform, location: location)]
        // When
        let movedLocationPoints = mapAnchor.moveOut(locationPoints)
        // Then
        let movedLocationPoint = try XCTUnwrap(movedLocationPoints.first)
        XCTAssertEqual(movedLocationPoint.transform[0,0], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[0,1], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[0,2], 0.5, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[0,3], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[1,0], 0.25, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[1,1], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[1,2], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[1,3], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[2,0], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[2,1], 2, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[2,2], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[2,3], 0, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[3,0], 2, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[3,1], 7, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[3,2], 6, accuracy: 1e-7)
        XCTAssertEqual(movedLocationPoint.transform[3,3], 1, accuracy: 1e-7)
    }
    
}
