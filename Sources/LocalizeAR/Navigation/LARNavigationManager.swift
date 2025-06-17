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
	public var userLocation: CLLocation? = nil
	public var userLocationAnnotation: MKPointAnnotation?
	public var userLocationAnnotationView: LARMKUserLocationAnnotationView?
    
    let guideNode = ({
        let node = SCNNode()
        let geometry = SCNSphere(radius: 0.05)
        geometry.firstMaterial?.diffuse.contents = UIColor.systemBlue
        node.geometry = geometry
        return node
    })()
	
	public var anchorNodes = LARSCNNodeCollection()
	public var anchors: [Int32:LARAnchor] = [:]
	
    public init(map: LARMap, mapView: MKMapView, mapNode: SCNNode) {
        self.map = map
        self.mapView = mapView
        self.mapNode = mapNode
		for anchor in map.anchors {
			addNavigationPoint(anchor: anchor)
		}
		for (from_id, to_ids) in map.edges {
			let from = Int32(truncating: from_id)
			for to_id in to_ids {
				let to = Int32(truncating: to_id)
				if to <= from { continue }
				addNavigationEdge(from: from, to: to)
			}
		}
    }
    
    public func addNavigationPoint(anchor: LARAnchor) {
		anchors[anchor.id] = anchor
        let node = LARSCNAnchorNode.create(anchorId: anchor.id)
        node.transform = SCNMatrix4(anchor.transform)
        anchorNodes.add(node)
        mapNode?.addChildNode(node)
        if map?.originReady ?? false, let coordinate = map?.location(from: anchor).coordinate {
            mapView?.addOverlay(LARMKNavigationNodeOverlay(coordinate: coordinate))
        }
    }
    
    public func updateNavigationPoint(anchor: LARAnchor, transform: simd_float4x4) {
        let node = anchorNodes.nodeById[anchor.id]!
        node.simdWorldTransform = transform
    }
    
    public func addNavigationEdge(from: Int32, to: Int32) {
        // place guide nodes
		let from = anchors[from]!, to = anchors[to]!
        let start = simd_float3(from.transform.position)
        let goal = simd_float3(to.transform.position)
        let distance = simd_distance(start, goal)
        var step = (goal-start)
        let stepLength: Float = 0.5
        step *= stepLength/simd_length(step)
		for i in 0..<Int(floor(distance/stepLength)) {
            let guide = guideNode.copy() as! SCNNode
            guide.simdWorldPosition = start + step*Float(i+1)
            mapNode?.addChildNode(guide)
        }
        
    }
	
	public func selectAnchor(id: Int32) {
		anchorNodes.nodeById[id]?.isSelected = true
	}
	
	public func updateUserLocation(position: simd_float3) {
		guard let map, map.originReady else { return }
		let newLocation = map.location(from: simd_double3(position))
		let distance = userLocation?.distance(from: newLocation)
		guard distance == nil || distance! > 0.1 else { return }
		
		if userLocationAnnotation == nil {
			let annotaion = MKPointAnnotation()
			mapView?.addAnnotation(annotaion)
			mapView?.userTrackingMode = .none
			userLocationAnnotation = annotaion
		}
		userLocationAnnotation!.coordinate = newLocation.coordinate
		userLocation = newLocation
		mapView?.setCenter(newLocation.coordinate, animated: true)
	}
}
