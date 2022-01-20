//
//  File.swift
//  
//
//  Created by Jean Flaherty on 6/26/21.
//

import Foundation
import simd

extension simd_float4x4: Codable {
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let col0 = try container.decode(SIMD4<Float>.self)
        let col1 = try container.decode(SIMD4<Float>.self)
        let col2 = try container.decode(SIMD4<Float>.self)
        let col3 = try container.decode(SIMD4<Float>.self)
        self.init(col0, col1, col2, col3)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(columns.0)
        try container.encode(columns.1)
        try container.encode(columns.2)
        try container.encode(columns.3)
    }
    
}
