//
//  PointCloudTests.swift
//
//
//  Created by Jean Flaherty on 7/6/21.
//

import XCTest
import CoreLocation
import simd
@testable import GeoARExtra

extension PointCloudTests {
    
    func testAddLocationPoints() {
        // Given
        let parameters: [(Double, Double, Double, Float, Float)] = [
            (35.36060, 138.72740, 10, 0, 0),
            (35.360608995766592, 138.72740, 5, 1, 0)
        ]
        let locationPoints = _locationPoints(parameters: parameters)
        let pointCloud = PointCloud()
        // When
        pointCloud.add(locationPoints)
        // Then
        XCTAssertEqual(locationPoints[0].location, pointCloud.locationPoints[0].location)
        XCTAssertEqual(locationPoints[1].location, pointCloud.locationPoints[1].location)
    }
    
    func testCentroids() throws {
        // Given
        let parameters: [(Double, Double, Double, Float, Float)] = [
            (35.36060, 138.72740, 10, 0, 0),
            (35.36061, 138.72740, 5, 1, 0)
        ]
        let locationPoints = _locationPoints(parameters: parameters)
        let pointCloud = PointCloud()
        pointCloud.add(locationPoints)
        // When
        let centroids = try XCTUnwrap(pointCloud.locationCentroids())
        // Then
        
        // Weighted average with second location point error weighted with 0.8 = (1/5^2)/(1/10^2+1/5^2)
        XCTAssertEqual(centroids.real.coordinate.latitude, 35.360608, accuracy: 1e-14)
        XCTAssertEqual(centroids.real.coordinate.longitude, 138.72740, accuracy: 1e-14)
        XCTAssertEqual(centroids.virtual.x, 0.8, accuracy: 1e-5)
        XCTAssertEqual(centroids.virtual.z, 0, accuracy: 1e-5)
    }
    
    func testRotationMatrix1() throws {
        // Given
        let parameters: [(Double, Double, Double, Float, Float)] = [
            (35.36060, 138.72740, 10, 0, 0),
            (35.360608995766592, 138.72740, 5, 1, 0),
        ]
        let locationPoints = _locationPoints(parameters: parameters)
        let pointCloud = PointCloud()
        pointCloud.add(locationPoints)
        // When
        let rotationMatrix = try XCTUnwrap(pointCloud.locationRotationMatrix())
        // Then
        XCTAssertEqual(rotationMatrix[0,0], 0, accuracy: 1e-5)
        XCTAssertEqual(rotationMatrix[0,1], 1, accuracy: 1e-5)
        XCTAssertEqual(rotationMatrix[1,0], -1, accuracy: 1e-5)
        XCTAssertEqual(rotationMatrix[1,1], 0, accuracy: 1e-5)
    }
    
    func testRotationMatrix2() throws {
        // Given
        let parameters: [(Double, Double, Double, Float, Float)] = [
            (35.36060, 138.72740, 10, 0, 0),
            (35.360608995766592, 138.727410981504949, 5, -1, -1),
        ]
        let locationPoints = _locationPoints(parameters: parameters)
        let pointCloud = PointCloud()
        pointCloud.add(locationPoints)
        // When
        let rotationMatrix = try XCTUnwrap(pointCloud.locationRotationMatrix())
        // Then
        XCTAssertEqual(rotationMatrix[0,0], 0, accuracy: 1e-5)
        XCTAssertEqual(rotationMatrix[0,1], -1, accuracy: 1e-5)
        XCTAssertEqual(rotationMatrix[1,0], 1, accuracy: 1e-5)
        XCTAssertEqual(rotationMatrix[1,1], 0, accuracy: 1e-5)
    }
    
    func testCrossCovarianceMatrix() throws {
        // Given
        let parameters: [(Double, Double, Double, Float, Float)] = [
            (35.36060, 138.72740, 10, 0, 0),
            (35.360608995766592, 138.727410981504949, 5, 1, 1),
        ]
        let locationPoints = _locationPoints(parameters: parameters)
        let pointCloud = PointCloud()
        pointCloud.add(locationPoints)
        // When
        let crossCovarianceMatrix = try XCTUnwrap(pointCloud.locationCrossCovarianceMatrix())
        // Then
        XCTAssertEqual(crossCovarianceMatrix[0,0], 0.16, accuracy: 1e-5)
        XCTAssertEqual(crossCovarianceMatrix[0,1], 0.16, accuracy: 1e-5)
        XCTAssertEqual(crossCovarianceMatrix[1,0], -0.16, accuracy: 1e-5)
        XCTAssertEqual(crossCovarianceMatrix[1,1], -0.16, accuracy: 1e-5)
    }
    
    
    // MARK: Helpers
    
    private func _locationPoints(parameters: [(Double, Double, Double, Float, Float)]) -> [LocationPoint] {
        return parameters.map({ (lat, lon, acc, x, z) in
            let location = CLLocation(
                coordinate: CLLocationCoordinate2DMake(lat, lon),
                altitude: 12388,
                horizontalAccuracy: acc,
                verticalAccuracy: 1,
                timestamp: Date(timeIntervalSince1970: 0)
            )
            let transform = simd_float4x4([[1,0,0,0],[0,1,0,0],[0,0,1,0],[x,0,z,1]])
            return LocationPoint(transform: transform, location: location)
        })
    }
    
}

