//
//  CameraPoint.swift
//  
//
//  Created by Jean Flaherty on 7/18/21.
//

import Foundation
import ARKit

class CameraPoint: NSObject, Codable, GeoARMapMovable {
    
    let identifier: UUID
    let transform: simd_float4x4
    let intrinsics: Intrinsics
    var featurePoints: Set<Feature> = []
    var locationPoints: [UUID] = []
    
    
    // MARK: Computed Properties
    
    required init(transform: simd_float4x4, intrinsics: Intrinsics, identifier: UUID = UUID()) {
        self.identifier = identifier
        self.transform = transform
        self.intrinsics = intrinsics
        
        super.init()
    }
    
    init(camera: ARCamera) {
        self.identifier = UUID()
        self.transform = camera.transform
        self.intrinsics = Intrinsics(intrinsics: camera.intrinsics)
        
        super.init()
    }
    
    func move(relativeTransform: simd_float4x4) -> Self {
        let newTransform = relativeTransform * transform
        
        let other = Self(transform: newTransform, intrinsics: intrinsics, identifier: identifier)
        other.featurePoints = featurePoints
        other.locationPoints = locationPoints
        return other
    }
    
    func add(_ features: [VisionManager.Feature]) {
        let featurePoints = features.map({ Feature($0) })
        self.featurePoints.formUnion(featurePoints)
    }
    
    func add(_ locationPoints: [LocationPoint]) {
        let identifiers = locationPoints.map({ $0.identifier })
        self.locationPoints.append(contentsOf: identifiers)
    }
    
    // MARK: Codable
    
    enum CodingKeys: String, CodingKey {
        case identifier = "identifier"
        case transform = "transform"
        case intrinsics = "intrinsics"
        case featurePoints = "featurePoints"
        case locationPoints = "locationPoints"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(identifier.uuidString, forKey: .identifier)
        try container.encode(transform, forKey: .transform)
        try container.encode(intrinsics, forKey: .intrinsics)
        try container.encode(featurePoints, forKey: .featurePoints)
        try container.encode(locationPoints.map({ $0.uuidString }), forKey: .locationPoints)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.identifier = UUID(uuidString: try container.decode(String.self, forKey: .identifier))!
        self.transform = try container.decode(simd_float4x4.self, forKey: .transform)
        self.intrinsics = try container.decode(Intrinsics.self, forKey: .intrinsics)
        self.featurePoints = try container.decode(Set<Feature>.self, forKey: .featurePoints)
        self.locationPoints = (try container.decode([String].self, forKey: .locationPoints)).map({ UUID(uuidString: $0)! })

        super.init()
    }
}


// MARK: Structs

extension CameraPoint {
    
    struct Point: Codable {
        let x: Float
        let y: Float
    }
    
    struct Feature: Codable, Hashable {
        let identifier: UUID
        let keyPoint: Point
        
        enum CodingKeys: String, CodingKey {
            case identifier = "identifier"
            case keyPoint = "keyPoint"
        }
        
        init(_ feature: VisionManager.Feature) {
            identifier = feature.featurePoint!.identifier
            keyPoint = Point(x: feature.keypoint.pt.x, y: feature.keypoint.pt.y)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(identifier.uuidString, forKey: CodingKeys.identifier)
            try container.encode(keyPoint, forKey: CodingKeys.keyPoint)
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.identifier = UUID(uuidString: try container.decode(String.self, forKey: CodingKeys.identifier))!
            self.keyPoint = try container.decode(Point.self, forKey: CodingKeys.keyPoint)
        }
        
        
        // MARK: Hashable
        
        static func == (lhs: Feature, rhs: Feature) -> Bool {
            return lhs.identifier == rhs.identifier
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }
    
    struct Intrinsics: Codable {
        let focalLength: Float
        let principlePoint: Point
        
        init(intrinsics: simd_float3x3) {
            self.focalLength = intrinsics[0,0]
            self.principlePoint = Point(x: intrinsics[2,0], y: intrinsics[2,1])
        }
    }
    
}
