//
//  LARNavigationManager.swift
//
//
//  Created by Jean Flaherty on 2025/05/26.
//

import Foundation
import SceneKit
import ARKit
import AVFoundation
import CoreLocation
import MapKit
import LocalizeAR_ObjC

public class LARNavigationManager {
    weak var map: LARMap?
    weak var mapView: MKMapView?
    weak var mapNode: SCNNode?
    
    let guideNode = ({
        let node = SCNNode()
        let geometry = SCNSphere(radius: 0.02)
        geometry.firstMaterial?.diffuse.contents = UIColor.systemBlue
        node.geometry = geometry
        return node
    })()
    
    public var anchorNodes = LARSCNNodeCollection()
    
    public init(map: LARMap, mapView: MKMapView, mapNode: SCNNode) {
        self.map = map
        self.mapView = mapView
        self.mapNode = mapNode
    }
    
    public func addNavigationPoint(anchor: LARAnchor) {
        let node = LARSCNAnchorNode.create(anchorId: anchor.id)
        node.transform = SCNMatrix4(anchor.transform)
        anchorNodes.add(node)
        mapNode?.addChildNode(node)
        if map?.originReady ?? false, let coordinate = map?.location(from: anchor).coordinate {
            mapView?.addOverlay(LARMKNavigationNodeOverlay(coordinate: coordinate))
        }
    }
    
    public func addNavigationEdge(from: LARAnchor, to: LARAnchor) {
        // place guide nodes
        let start = simd_float3(from.transform.position)
        let goal = simd_float3(to.transform.position)
        let distance = simd_distance(start, goal)
        var step = (goal-start)
        let stepLength: Float = 0.25
        step *= stepLength/simd_length(step)
        for i in 0..<Int(distance/0.25) {
            let guide = guideNode.copy() as! SCNNode
            guide.simdWorldPosition = start + step*Float(i)
            mapNode?.addChildNode(guide)
        }
        
    }
}
