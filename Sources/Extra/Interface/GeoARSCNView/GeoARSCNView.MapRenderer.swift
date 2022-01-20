//
//  GeoARSCNView.MapRenderer.swift
//  
//
//  Created by Jean Flaherty on 7/7/21.
//

import Foundation
import SceneKit
import ARKit


extension GeoARSCNView {
    
    class MapRenderer: NSObject {
        
        weak var view: GeoARSCNView? {
            didSet {
                let tintColor = view?.tintColor ?? .systemBlue
                navigationGuideNode.childNodes.first?.geometry?.firstMaterial?.diffuse.contents = tintColor
            }
        }
        
        var mapNode: SCNNode = {
            let node = SCNNode()
            node.name = "map"
            return node
        }()
        
        
        // MARK: Node Types
        
        enum NodeType: String {
            case locationPoint = "locationPoint"
            case addedFeaturePoint = "addedFeaturePoint"
            case gatheredFeaturePoint = "gatheredFeaturePoint"
            case trackedFeaturePoint = "trackedFeaturePoint"
            
            case navigationNode = "navigationNode"
            case navigationGuideNode = "navigationGuideNode"
        }
        
        
        // MARK: Node Instances
        
        let locationPointNode = SCNNode.locationPointNode(
            color: UIColor.cyan,
            name: NodeType.locationPoint.rawValue)
        let gatheredFeaturePointNode = SCNNode.featurePointNode(
            color: UIColor.gray.withAlphaComponent(0.8),
            name: NodeType.gatheredFeaturePoint.rawValue)
        let addedFeaturePointNode = SCNNode.featurePointNode(
            color: UIColor.orange,
            name: NodeType.addedFeaturePoint.rawValue)
        let trackedFeaturePointNode = SCNNode.featurePointNode(
            color: UIColor.green,
            name: NodeType.trackedFeaturePoint.rawValue)
        
        
        let navigationNode = SCNNode.navigationNode(
            color: UIColor.white,
            name: NodeType.navigationNode.rawValue)
        let navigationGuideNode = SCNNode.navigationGuideNode(
            color: UIColor.systemBlue,
            name: NodeType.navigationGuideNode.rawValue)
        
        
        // MARK: Adding/Removing Nodes
        
        func addNodes(of type: NodeType, with transforms: [simd_float4x4]) {
            
            let original: SCNNode = {
                switch type {
                case .locationPoint: return locationPointNode
                case .addedFeaturePoint: return addedFeaturePointNode
                case .gatheredFeaturePoint: return gatheredFeaturePointNode
                case .trackedFeaturePoint: return trackedFeaturePointNode
                    
                case .navigationNode: return navigationNode
                case .navigationGuideNode: return navigationGuideNode
                }
            }()
            
            for transform in transforms {
                let node = original.clone()
                node.transform = SCNMatrix4(transform)
                mapNode.addChildNode(node)
            }
        }
        
        func removeAllNodes(of type: NodeType) {
            
            let nodes = mapNode.childNodes.filter { node in node.name == type.rawValue }
            for node in nodes {
                node.removeFromParentNode()
            }
        }
        
        func removeAllNodes() {
            
            let types = Set([
                NodeType.locationPoint.rawValue,
                NodeType.addedFeaturePoint.rawValue,
                NodeType.gatheredFeaturePoint.rawValue,
                NodeType.trackedFeaturePoint.rawValue,
                
                NodeType.navigationNode.rawValue,
                NodeType.navigationGuideNode.rawValue
            ])

            let nodes = mapNode.childNodes.filter { node in types.contains(node.name ?? "") }
            for node in nodes {
                node.removeFromParentNode()
            }
        }
        
        
        // MARK: Render
        
        func renderAnchors(anchors: [GeoARAnchor]) {
            for anchor in anchors {
                if let anchor = anchor as? GeoARNavigationAnchor {
                    renderNavigationNode(anchor: anchor)
                }
            }
            updateNavigationGuideNodes()
        }
        
        func renderLocationPoints(session: ARSession) {
            guard view?.geoARDebugOptions.contains(.showLocationPoints) == true,
                  let map = session.currentFrame?.mapAnchor?.map
            else { return }
            // Render location points
            removeAllNodes(of: .locationPoint)
            
            let transforms = map.pointCloud.locationPoints.map({ $0.transform })
            addNodes(of: .locationPoint, with: transforms)
        }
        
        func renderNavigationNode(anchor: GeoARNavigationAnchor) {
            let node = navigationNode.clone()
            node.transform = SCNMatrix4(anchor.transform)
            mapNode.addChildNode(node)
        }
        
        
        func updateNavigationGuideNodes() {
            guard let view = view else { return }
            
            removeAllNodes(of: .navigationGuideNode)
            
            let navigationGraphs = view.tracker.map.anchors.compactMap({ ($0 as? GeoARNavigationGraphAnchor)?.graph })
            
            for navigationGraph in navigationGraphs {
                for transform in navigationGraph.trail() {
                    let node = navigationGuideNode.clone()
                    node.transform = SCNMatrix4(transform)
                    mapNode.addChildNode(node)
                }
            }
        }
    }
    
}

private extension SCNNode {
    
    static func locationPointNode(color: UIColor, name: String) -> Self {
        let node = Self()
        node.geometry = SCNSphere(radius: 0.005)
        node.geometry?.firstMaterial?.diffuse.contents = color
        node.name = name
        return node
    }
    
    static func featurePointNode(color: UIColor, name: String) -> Self {
        let node = Self()
        node.geometry = SCNPlane(width: 2.0, height: 2.0)
        node.geometry?.firstMaterial?.diffuse.contents = color
        node.name = name
        return node
    }
    
    static func navigationNode(color: UIColor, name: String) -> Self {
        let node = Self()
        node.geometry = SCNTube(innerRadius: 0.15, outerRadius: 0.2, height: 0.01)
        node.geometry?.firstMaterial?.diffuse.contents = color
        node.name = name
        return node
    }
    
    static func navigationGuideNode(color: UIColor, name: String) -> Self {
        let node = Self()
        
        var sphereTransform = matrix_identity_float4x4
        sphereTransform[3,1] = 0.1
        
        let sphere = SCNNode()
        sphere.geometry = SCNSphere(radius: 0.05)
        sphere.geometry?.firstMaterial?.diffuse.contents = color
        sphere.transform = SCNMatrix4(sphereTransform)
        node.addChildNode(sphere)
        
        node.name = name
        return node
    }
    
}
