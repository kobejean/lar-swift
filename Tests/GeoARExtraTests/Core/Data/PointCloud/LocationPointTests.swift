//
//  FeaturePointTests.swift
//  
//
//  Created by Jean Flaherty on 7/7/21.
//

import XCTest
import simd
import CoreLocation
@testable import GeoARExtra

final class LocationPointTests: XCTestCase {
    
    func testCodable() throws {
        // Given
        let transform = simd_float4x4([[0,1,2,3],[4,5,6,7],[8,9,10,11],[12,13,14,15]])
        let location = CLLocation(
            coordinate: CLLocationCoordinate2DMake(35.36060, 138.72740),
            altitude: 12388,
            horizontalAccuracy: 1,
            verticalAccuracy: 1,
            timestamp: Date(timeIntervalSince1970: 0)
        )
        let locationPoint = LocationPoint(transform: transform, location: location)
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        let decoder = PropertyListDecoder()
        // When
        let data = try encoder.encode(locationPoint)
        let decodedLocationPoint = try decoder.decode(LocationPoint.self, from: data)
        // Then
        
        // Transform
        XCTAssertEqual(decodedLocationPoint.transform[0,0], 0)
        XCTAssertEqual(decodedLocationPoint.transform[0,1], 1)
        XCTAssertEqual(decodedLocationPoint.transform[0,2], 2)
        XCTAssertEqual(decodedLocationPoint.transform[0,3], 3)
        XCTAssertEqual(decodedLocationPoint.transform[1,0], 4)
        XCTAssertEqual(decodedLocationPoint.transform[1,1], 5)
        XCTAssertEqual(decodedLocationPoint.transform[1,2], 6)
        XCTAssertEqual(decodedLocationPoint.transform[1,3], 7)
        XCTAssertEqual(decodedLocationPoint.transform[2,0], 8)
        XCTAssertEqual(decodedLocationPoint.transform[2,1], 9)
        XCTAssertEqual(decodedLocationPoint.transform[2,2], 10)
        XCTAssertEqual(decodedLocationPoint.transform[2,3], 11)
        XCTAssertEqual(decodedLocationPoint.transform[3,0], 12)
        XCTAssertEqual(decodedLocationPoint.transform[3,1], 13)
        XCTAssertEqual(decodedLocationPoint.transform[3,2], 14)
        XCTAssertEqual(decodedLocationPoint.transform[3,3], 15)
        // Location
        XCTAssertEqual(decodedLocationPoint.location.coordinate.latitude, 35.36060)
        XCTAssertEqual(decodedLocationPoint.location.coordinate.longitude, 138.72740)
    }
    
    func testMove() {
        // Given
        let transform = simd_float4x4([[0.5,0,0,0],[0,0.25,0,0],[0,0,2,0],[3,1,5,1]])
        let location = CLLocation(
            coordinate: CLLocationCoordinate2DMake(35.36060, 138.72740),
            altitude: 12388,
            horizontalAccuracy: 1,
            verticalAccuracy: 1,
            timestamp: Date(timeIntervalSince1970: 0)
        )
        let locationPoint = LocationPoint(transform: transform, location: location)
        let relativeTransform = simd_float4x4([[0,0,1,0],[1,0,0,0],[0,1,0,0],[1,2,3,1]])
        // When
        let moved = locationPoint.move(relativeTransform: relativeTransform)
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

