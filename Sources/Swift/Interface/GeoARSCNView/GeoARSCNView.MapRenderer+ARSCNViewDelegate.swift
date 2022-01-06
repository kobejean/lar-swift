//
//  GeoARSCNView.MapRenderer+ARSCNViewDelegate.swift
//  
//
//  Created by Jean Flaherty on 7/7/21.
//

import Foundation
import SceneKit
import ARKit


extension GeoARSCNView.MapRenderer: ARSCNViewDelegate {
    
    public func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        if let anchor = anchor as? GeoARMapAnchor {
            return _renderMapData(anchor: anchor)
        } else if let node = view?.delegateForwarder.externalDelegate?.renderer?(renderer, nodeFor: anchor) {
            return node
        }
        return SCNNode()
    }
    
    // TODO: Revisit this as it clearly doesn't do any rendering anymore
    private func _renderMapData(anchor: GeoARMapAnchor) -> SCNNode {
        removeAllNodes()
        
        mapNode.transform = SCNMatrix4(anchor.transform)
        mapNode.childNodes.forEach({ $0.removeFromParentNode() })
        
//        renderAnchors(anchors: anchor.map.anchors)
        return mapNode
    }
}
