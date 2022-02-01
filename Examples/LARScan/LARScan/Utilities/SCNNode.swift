//
//  SCNSphere.swift
//  LARScan
//
//  Created by Jean Flaherty on 2022/01/31.
//

import Foundation
import SceneKit

extension SCNNode {
    static func sphere(radius: CGFloat, color: UIColor) -> SCNNode {
        let node = SCNNode()
        let geometry = SCNSphere(radius: radius)
        geometry.firstMaterial?.diffuse.contents = color
        node.geometry = geometry
        return node
    }
}
