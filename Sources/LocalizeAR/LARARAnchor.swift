//
//  File.swift
//  
//
//  Created by Jean Flaherty on 2025/05/27.
//

import Foundation
import ARKit
import LocalizeAR_ObjC

public class LARARAnchor : ARAnchor {
    public let anchor: LARAnchor
    public init(anchor: LARAnchor, transform: simd_float4x4) {
        self.anchor = anchor
        super.init(name: "LARARAnchor", transform: transform)
    }
    
    public required init(anchor: ARAnchor) {
        let anchor = anchor as! LARARAnchor
        self.anchor = anchor.anchor
        super.init(anchor: anchor)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
