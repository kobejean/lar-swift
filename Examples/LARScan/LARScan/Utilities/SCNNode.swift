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
    
    static func axis(color: UIColor) -> SCNNode {
        let node = SCNNode()
        let axis = SCNNode()
        let tip = SCNNode.sphere(radius: 0.001, color: UIColor.red)
        tip.position = SCNVector3(0, 0, 0)
        axis.position = SCNVector3(0, 0, 0.025)
        let geometry = SCNBox(width: 0.001, height: 0.001, length: 0.05, chamferRadius: 0)
        geometry.chamferSegmentCount = 1
        geometry.firstMaterial?.diffuse.contents = color
        axis.geometry = geometry
        node.addChildNode(axis)
        node.addChildNode(tip)
        return node
    }
}
