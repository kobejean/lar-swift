//
//  PointCloudTests.swift
//
//
//  Created by Jean Flaherty on 7/6/21.
//

import XCTest
import simd
import CoreLocation
@testable import GeoARExtra

final class PointCloudTests: XCTestCase {
    
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
        let featurePoint = FeaturePoint(transform: transform, descriptor: [0,1,2,3])
        let locationPoint = LocationPoint(transform: transform, location: location)
        let pointCloud = PointCloud()
        pointCloud.add([featurePoint])
        pointCloud.add([locationPoint])
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        let decoder = PropertyListDecoder()
        // When
        let data = try encoder.encode(pointCloud)
        let decodedPointCloud = try decoder.decode(PointCloud.self, from: data)
        // Then
        guard let decodedFeaturePoint = decodedPointCloud.featurePoints.first,
              let decodedLocationPoint = decodedPointCloud.locationPoints.first
        else { XCTFail(); return }
        
        XCTAssertEqual(decodedFeaturePoint.transform[0,2], 2)
        XCTAssertEqual(decodedFeaturePoint.descriptor[2], 2)
        XCTAssertEqual(decodedLocationPoint.transform[1,0], 4)
        XCTAssertEqual(decodedLocationPoint.location.coordinate.latitude, 35.36060)
        XCTAssertEqual(decodedLocationPoint.location.coordinate.longitude, 138.72740)
    }
    
}

