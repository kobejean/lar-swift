//
//  FeaturePoint.swift
//  
//
//  Created by Jean Flaherty on 6/24/21.
//

import Foundation
import ARKit

class FeaturePoint: NSObject, Codable, GeoARMapMovable {
    
    let identifier: UUID
    let transform: simd_float4x4
    let descriptor: [UInt8]
    let response: Float
    
    static let extent: Float = 0
    
    
    // MARK: Computed Properties
    
    var point: simd_float3 { simd_make_float3(transform[3]) }
    var cameraPoint: simd_float3 { simd_make_float3(transform[3] + transform[2]) }
    var boundingRectMin: simd_float2 {
        let cameraPoint = self.cameraPoint
        return simd_float2(cameraPoint.x - Self.extent, cameraPoint.z - Self.extent)
    }
    var boundingRectMax: simd_float2 {
        let cameraPoint = self.cameraPoint
        return simd_float2(cameraPoint.x + Self.extent, cameraPoint.z + Self.extent)
    }
    var size: Float { simd_length(transform[1]) }
    
    required init(transform: simd_float4x4, descriptor: [UInt8], response: Float = 0, identifier: UUID = UUID()) {
        self.identifier = identifier
        self.transform = transform
        self.response = response
        self.descriptor = descriptor
        
        super.init()
    }
    
    func move(relativeTransform: simd_float4x4) -> Self {
        let newTransform = relativeTransform * transform
        return Self(transform: newTransform, descriptor: descriptor, response: response, identifier: identifier)
    }
    
    
    // MARK: Codable
    
    enum CodingKeys: String, CodingKey {
        case identifier = "identifier"
        case transform = "transform"
        case response = "response"
        case descriptor = "descriptor"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(identifier.uuidString, forKey: .identifier)
        try container.encode(transform, forKey: .transform)
        try container.encode(response, forKey: .response)
        try container.encode(Data(descriptor), forKey: .descriptor)
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.identifier = UUID(uuidString: try container.decode(String.self, forKey: .identifier))!
        self.transform = try container.decode(simd_float4x4.self, forKey: .transform)
        self.response = try container.decode(Float.self, forKey: .response)
        self.descriptor = Array(try container.decode(Data.self, forKey: .descriptor))
        
        super.init()
    }
    
    
    // MARK: Hashable
    
    public override func isEqual(_ other: (Any)?) -> Bool {
      guard let other = other as? Self else { return false }
      return self.identifier == other.identifier
    }

    public override var hash: Int {
      var hasher = Hasher()
      hasher.combine(identifier)
      return hasher.finalize()
    }
}
