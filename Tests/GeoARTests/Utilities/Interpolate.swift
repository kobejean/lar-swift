//
//  Interpolate.swift
//  
//
//  Created by Jean Flaherty on 6/4/21.
//

import XCTest
@testable import GeoAR

final class InterpolateTests: XCTestCase {
    
    func testInterpolateDouble() {
        // Given
        let a = 5.0
        let b = 15.0
        let alpha = 0.2
        // When
        let result = a.interpolate(with: b, alpha: alpha)
        // Then
        XCTAssertEqual(result, 7.0, accuracy: 0.000000001)
    }
    
}
