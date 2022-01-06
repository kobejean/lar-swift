//
//  GeoARMap.swift
//  
//
//  Created by Jean Flaherty on 6/24/21.
//

import Foundation
import simd
import CoreLocation


public class GeoARMap {
    
    var pointCloud = PointCloud()
    public var anchors = [GeoARAnchor]()
    
    init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.pointCloud = try container.decode(PointCloud.self, forKey: CodingKeys.pointCloud)
        
        let anchorsContainer = try container.nestedContainer(keyedBy: AnchorKeys.self, forKey: CodingKeys.anchors)
        
        let anchorClassNames = try anchorsContainer.decode(Set<String>.self, forKey: AnchorKeys.classes)
        let anchorClasses: [AnyClass] = anchorClassNames.reduce(into: [NSArray.self]) { anchorClasses, anchorClassName in
            guard let anchorClass = NSClassFromString(anchorClassName) else { return }
            anchorClasses.append(anchorClass)
        }
        
        let anchorsData = try anchorsContainer.decode(Data.self, forKey: AnchorKeys.objects)
        let anchorsDecoder = try NSKeyedUnarchiver(forReadingFrom: anchorsData)
        self.anchors = anchorsDecoder.decodeObject(of: anchorClasses, forKey: "anchors") as? [GeoARAnchor] ?? []
    }
}


// MARK: Codable

extension GeoARMap: Codable {
    
    enum CodingKeys: String, CodingKey {
        case pointCloud = "pointCloud"
        case anchors = "anchors"
    }
    
    enum AnchorKeys: String, CodingKey {
        case classes = "$classes"
        case objects = "$objects"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pointCloud, forKey: CodingKeys.pointCloud)
        
        // Store anchor class names and objects in anchors container
        var anchorsContainer = container.nestedContainer(keyedBy: AnchorKeys.self, forKey: CodingKeys.anchors)
        
        // Populate `anchorClasses`
        var anchorClassNames = Set<String>()
        for anchor in anchors {
            let className = NSStringFromClass(type(of: anchor))
            anchorClassNames.insert(className)
        }
        try anchorsContainer.encode(anchorClassNames, forKey: AnchorKeys.classes)
        
        // Encode anchor objects
        let anchorsEncoder = NSKeyedArchiver(requiringSecureCoding: true)
        anchorsEncoder.encode(anchors, forKey: "anchors")
        let anchorsData = anchorsEncoder.encodedData
        try anchorsContainer.encode(anchorsData, forKey: AnchorKeys.objects)
    }
    
    public func locationsForTransforms(_ transforms: [simd_float4x4]) -> [CLLocation] {
        return pointCloud.locationsForTransforms(transforms)
    }
}
