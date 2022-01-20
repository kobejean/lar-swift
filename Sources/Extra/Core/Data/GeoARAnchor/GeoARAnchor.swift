//
//  GeoARAnchor.swift
//  
//
//  Created by Jean Flaherty on 7/17/21.
//

import Foundation
import ARKit

public class GeoARAnchor: NSObject {
    
    public var transform: simd_float4x4
    public let identifier: UUID
    public var name: String?
    
    init(transform: simd_float4x4, identifier: UUID = UUID(), name: String? = nil) {
        self.transform = transform
        self.identifier = identifier
        self.name = name
    }
    
    public required init?(coder: NSCoder) {
        guard let transformFlattened = coder.decodeObject(
                of: NSArray.self, forKey: CodingKeys.transform.rawValue) as? [Float],
              let identifier = coder.decodeObject(
                of: NSUUID.self, forKey: CodingKeys.identifier.rawValue) as UUID?
        else { return nil }
        self.transform = simd_float4x4(transformFlattened)
        self.identifier = identifier
        self.name = coder.decodeObject(of: NSString.self, forKey: CodingKeys.name.rawValue) as String?
        super.init()
    }
}


// MARK: NSCoding

extension GeoARAnchor: NSCoding {
    
    enum CodingKeys: String {
        case transform = "transform"
        case identifier = "identifier"
        case name = "name"
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(transform.flattened, forKey: CodingKeys.transform.rawValue)
        coder.encode(identifier, forKey: CodingKeys.identifier.rawValue)
        coder.encode(name, forKey: CodingKeys.name.rawValue)
    }
    
}


// MARK: NSSecureCoding

extension GeoARAnchor: NSSecureCoding {
    
    public class var supportsSecureCoding: Bool { return true }
    
}


// MARK: GeoARMapMovable

extension GeoARAnchor: GeoARMapMovable {
    
    func move(relativeTransform: simd_float4x4) -> Self {
        transform = relativeTransform * transform
        return self
    }
    
}


// MARK: Equatable

extension GeoARAnchor {
    
    public static func == (lhs: GeoARAnchor, rhs: GeoARAnchor) -> Bool {
        return lhs.transform == rhs.transform && lhs.identifier == rhs.identifier && lhs.name == rhs.name
    }
    
}
