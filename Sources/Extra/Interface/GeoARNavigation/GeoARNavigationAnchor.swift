//
//  GeoARNavigationAnchor.swift
//  
//
//  Created by Jean Flaherty on 7/9/21.
//

import Foundation
import ARKit

public class GeoARNavigationAnchor: GeoARAnchor {
    
    public func distance(to: GeoARNavigationAnchor) -> Float {
        return simd_distance(self.transform[3], to.transform[3])
    }
    
    public init(transform: simd_float4x4) {
        super.init(transform: transform)
    }
    
    init(anchor: GeoARNavigationAnchor) {
        super.init(transform: anchor.transform, identifier: anchor.identifier, name: anchor.name)
    }
    
    
    // MARK: NSCoding
    
    public override func encode(with coder: NSCoder) {
        super.encode(with: coder)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public class override var supportsSecureCoding: Bool { return true }
}
