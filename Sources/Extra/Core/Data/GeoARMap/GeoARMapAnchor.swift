//
//  GeoARMapAnchor.swift
//  
//
//  Created by Jean Flaherty on 6/24/21.
//

import Foundation
import ARKit
import CoreLocation

public class GeoARMapAnchor: ARAnchor {
    
    public var map: GeoARMap
    
    
    // MARK: Initialization
    
    init(transform: simd_float4x4, map: GeoARMap) {
        self.map = map
        super.init(transform: transform)
    }
    
    required init(anchor: ARAnchor) {
        let other = anchor as! Self
        self.map = other.map
        super.init(anchor: anchor)
    }
    
    
    // MARK: Moving GeoARMapMovable
    
    func moveIn<T: GeoARMapMovable>(_ movable: T) -> T {
        return movable.move(relativeTransform: transform.rigidInverse)
    }
    
    func moveOut<T: GeoARMapMovable>(_ movable: T) -> T {
        return movable.move(relativeTransform: self.transform)
    }
    
    func moveIn<T: GeoARMapMovable>(_ movables: [T]) -> [T] {
        let inverseTransform = transform.rigidInverse
        return movables.map { movable in
            movable.move(relativeTransform: inverseTransform)
        }
    }
    
    func moveOut<T: GeoARMapMovable>(_ movables: [T]) -> [T] {
        let transform = self.transform
        return movables.map { movable in
            movable.move(relativeTransform: transform)
        }
    }
    
    
    // MARK: Moving Vectors
    
    func moveIn(_ vector: simd_float2) -> simd_float2 {
        let inverseTransform = transform.rigidInverse
        let vector4 = simd_float4(vector.x, 0, vector.y, 1)
        var mapped4 = inverseTransform * vector4
        mapped4 *= 1 / mapped4.w
        return simd_float2(mapped4.x, mapped4.z)
    }
    
    func moveOut(_ vector: simd_float2) -> simd_float2 {
        let vector4 = simd_float4(vector.x, 0, vector.y, 1)
        var mapped4 = transform * vector4
        mapped4 *= 1 / mapped4.w
        return simd_float2(mapped4.x, mapped4.z)
    }
    
    
    // MARK: NSCoding
    
    enum CodingKeys: String {
        case data = "data"
    }
    
    public override func encode(with coder: NSCoder) {
        let plistEncoder = PropertyListEncoder()
        plistEncoder.outputFormat = .binary
        coder.encode(try? plistEncoder.encode(map), forKey: CodingKeys.data.rawValue)
        super.encode(with: coder)
    }
    
    required init?(coder: NSCoder) {
        let plistDecoder = PropertyListDecoder()
        
        guard let rawData = coder.decodeObject(of: NSData.self, forKey: CodingKeys.data.rawValue)
        else { return nil }
        
        do {
            self.map = try plistDecoder.decode(GeoARMap.self, from: rawData as Data)
        } catch {
            fatalError("Can't decode map: \(error.localizedDescription)")
        }
        super.init(coder: coder)
    }
    
    
    // MARK: NSSecureCoding
    
    public override class var supportsSecureCoding: Bool {
        return true
    }
    
}
