//
//  LocationPoint.swift
//
//
//  Created by Jean Flaherty on 6/24/21.
//

import Foundation
import ARKit
import CoreLocation

class LocationPoint: Codable, GeoARMapMovable {
    
    let identifier: UUID
    let transform: simd_float4x4
    let location: CLLocation
    
    required init(transform: simd_float4x4, location: CLLocation, identifier: UUID = UUID()) {
        self.identifier = identifier
        self.transform = transform
        self.location = location
    }
    
    func move(relativeTransform: simd_float4x4) -> Self {
        let newTransform = relativeTransform * transform
        return Self(transform: newTransform, location: location, identifier: identifier)
    }
    
    
    // MARK: Codable
    
    enum CodingKeys: String, CodingKey {
        case identifier = "identifier"
        case transform = "transform"
        case latitude = "latitude"
        case longitude = "longitude"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(identifier.uuidString, forKey: .identifier)
        try container.encode(transform, forKey: .transform)
        
        try container.encode(location.coordinate.latitude, forKey: CodingKeys.latitude)
        try container.encode(location.coordinate.longitude, forKey: CodingKeys.longitude)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.identifier = UUID(uuidString: try container.decode(String.self, forKey: .identifier))!
        self.transform = try container.decode(simd_float4x4.self, forKey: .transform)
        
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        self.location = CLLocation(latitude: latitude, longitude: longitude)
    }
    
}
