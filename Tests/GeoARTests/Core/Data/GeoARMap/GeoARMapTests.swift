//
//  GeoARMapTests.swift
//  
//
//  Created by Jean Flaherty on 7/6/21.
//

import XCTest
import simd
@testable import GeoAR

final class GeoARMapTests: XCTestCase {
    
    func testCodable() throws {
        // Given
        let map = GeoARMap()
        let transform = simd_float4x4([[0,1,2,3],[4,5,6,7],[8,9,10,11],[12,13,14,15]])
        let featurePoint = FeaturePoint(transform: transform, descriptor: [0,1,2,3])
        map.pointCloud.add([featurePoint])
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        let decoder = PropertyListDecoder()
        // When
        let data = try encoder.encode(map)
        let decodedMap = try decoder.decode(GeoARMap.self, from: data)
        // Then
        guard let decodedFeaturePoint = decodedMap.pointCloud.featurePoints.first
        else { XCTFail(); return }
        XCTAssertEqual(decodedFeaturePoint.transform[3,0], 12)
        XCTAssertEqual(decodedFeaturePoint.descriptor[3], 3)
    }
    
}

