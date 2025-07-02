//
//  LARNavigationManager.swift
//
//
//  Created by Jean Flaherty on 2025/05/26.
//

import Foundation
import SceneKit
import AVFoundation
import CoreLocation
import MapKit
import LocalizeAR_ObjC

public class LARNavigationManager : NSObject, MKMapViewDelegate, LARMapDelegate {
    weak var map: LARMap?
    weak var mapView: MKMapView?
    weak var mapNode: SCNNode?
	public var userLocation: CLLocation? = nil
	public var userLocationAnnotation: MKPointAnnotation?
    
    let guideNode = ({
        let node = SCNNode()
        let geometry = SCNSphere(radius: 0.05)
        geometry.firstMaterial?.diffuse.contents = UIColor.systemBlue
        node.geometry = geometry
        return node
    })()
	
	public var anchorNodes = LARSCNNodeCollection()
	public var anchors: [Int32:LARAnchor] = [:]
	public var navigationEdges: [(from: LARAnchor, to: LARAnchor)] = []
	
    public init(map: LARMap, mapView: MKMapView, mapNode: SCNNode) {
        self.map = map
        self.mapView = mapView
        self.mapNode = mapNode
		super.init()
		mapView.delegate = self
		map.delegate = self
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
	
	deinit {
		
		if let userLocationAnnotation {
			mapView?.removeAnnotation(userLocationAnnotation)
		}
	}
    
    public func addNavigationPoint(anchor: LARAnchor) {
		anchors[anchor.id] = anchor
        let node = LARSCNAnchorNode.create(anchorId: anchor.id)
        node.transform = SCNMatrix4(anchor.transform)
        anchorNodes.add(node)
        mapNode?.addChildNode(node)
        if map?.originReady ?? false, let coordinate = map?.location(from: anchor).coordinate {
			let overlay = LARMKNavigationNodeOverlay(coordinate: coordinate)
			mapView?.addOverlay(overlay, level: .aboveLabels)
        }
    }
    
    public func updateNavigationPoint(anchor: LARAnchor, transform: simd_float4x4) {
        let node = anchorNodes.nodeById[anchor.id]!
        node.simdWorldTransform = transform
    }
    
    public func addNavigationEdge(from: Int32, to: Int32) {
        // place guide nodes
		let from = anchors[from]!, to = anchors[to]!
		navigationEdges.append((from, to))
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
		
		if let map, map.originReady {
			addMapEdgeOverlay(from: from, to: to)
		}
    }
	
	private func addMapEdgeOverlay(from: LARAnchor, to: LARAnchor) {
		let fromCoordinate = map!.location(from: from).coordinate
		let toCoordinate = map!.location(from: to).coordinate
		let polyline = MKPolyline(coordinates: [fromCoordinate, toCoordinate], count: 2)
		mapView?.addOverlay(polyline, level: .aboveRoads)
	}
	
	public func updateMapOverlays() {
		guard let mapView, let map, map.originReady else { return }
		
		mapView.removeOverlays(mapView.overlays)
		
		for (_, anchor) in anchors {
			let coordinate = map.location(from: anchor).coordinate
			let overlay = LARMKNavigationNodeOverlay(coordinate: coordinate)
			mapView.addOverlay(overlay, level: .aboveLabels)
		}
		
		for (from, to) in navigationEdges { addMapEdgeOverlay(from: from, to: to) }
	}
	
	public func selectAnchor(id: Int32) {
		anchorNodes.nodeById[id]?.isSelected = true
	}
	
#if canImport(UIKit)
	public func updateUserLocation(position: simd_float3) {
		guard let map, map.originReady else { return }
		let newLocation = map.location(from: simd_double3(position))
		let distance = userLocation?.distance(from: newLocation)
		guard distance == nil || distance! > 0.05 else { return }
		
		if let userLocationAnnotation {
			userLocationAnnotation.coordinate = newLocation.coordinate
			userLocation = newLocation
			mapView?.setCenter(newLocation.coordinate, animated: true)
		} else {
			let annotaion = MKPointAnnotation()
			mapView?.addAnnotation(annotaion)
			mapView?.userTrackingMode = .none
			userLocationAnnotation = annotaion
		}
	}
	
	// MARK: - MKMapViewDelegate
	
	public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKUserLocation {
			let pin = LARMKUserLocationAnnotationView(
				annotation: annotation,
				color: .systemPurple,
				reuseIdentifier: nil
			)
			return pin
		} else if let annotation = annotation as? MKPointAnnotation, annotation == userLocationAnnotation {
			let pin = LARMKUserLocationAnnotationView(
				annotation: annotation,
				color: UIColor.systemBlue,
				reuseIdentifier: nil
			)
			return pin
		}
		return nil
	}
#endif
	public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if let circle = overlay as? LARMKNavigationGuideNodeOverlay {
			let renderer = MKCircleRenderer(circle: circle)
			renderer.fillColor = UIColor.systemBlue
			return renderer
		} else if let circle = overlay as? LARMKNavigationNodeOverlay {
			let renderer = MKCircleRenderer(circle: circle)
			renderer.fillColor = .white
			return renderer
		} else if let polyline = overlay as? MKPolyline {
			let renderer = MKPolylineRenderer(polyline: polyline)
			renderer.strokeColor = UIColor.systemBlue
			renderer.lineWidth = 3.0
			renderer.lineDashPattern = nil // [5, 5]
			return renderer
		}
		
		return MKOverlayRenderer(overlay: overlay)
	}
	
	// MARK: - LARMapDelegate
	
	public func map(_ map: LARMap, didUpdateOrigin transform: simd_double4x4) {
		updateMapOverlays()
	}
	
}
