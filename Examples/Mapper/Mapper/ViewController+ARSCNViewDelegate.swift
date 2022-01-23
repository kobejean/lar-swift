//
//  ViewController+ARSCNViewDelegate.swift
//  Mapper
//
//  Created by Jean Flaherty on 5/28/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import SceneKit
import ARKit
import LocalAR

extension ViewController: ARSCNViewDelegate {
    
    
    // MARK: - ARSCNViewDelegate
    
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        guard let navigationAnchor = anchor as? GeoARNavigationAnchor else { return SCNNode() }
//        
//        let node = navigationNode.clone()
//        node.transform = SCNMatrix4(navigationAnchor.transform)
//        return node
//    }
}
