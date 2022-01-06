//
//  GeoARNavigationAnchorTests.swift
//  
//
//  Created by Jean Flaherty on 7/9/21.
//


import XCTest
import Foundation
import simd
@testable import GeoAR

final class GeoARNavigationAnchorTests: XCTestCase {
    
    func testCopyable() throws {
        // Given
        let transform = matrix_identity_float4x4
        let anchor = GeoARNavigationAnchor(transform: transform)
        // When
        let copy = GeoARNavigationAnchor(anchor: anchor)
        // Then
        XCTAssertEqual(anchor.identifier, copy.identifier)
    }
    
    func testDistance() throws {
        // Given
        let transform1 = matrix_identity_float4x4
        var transform2 = matrix_identity_float4x4
        transform2[3] = .init(1, 2, 3, 1)
        let anchor1 = GeoARNavigationAnchor(transform: transform1)
        let anchor2 = GeoARNavigationAnchor(transform: transform2)
        // When
        let distance = anchor1.distance(to: anchor2)
        // Then
        let expect = Float(sqrt(Double(14)))
        XCTAssertEqual(distance, expect, accuracy: expect.ulp)
    }
    
}
