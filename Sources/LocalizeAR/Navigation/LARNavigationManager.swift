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
    // MARK: - Configuration
    private struct Constants {
        static let guideNodeRadius: CGFloat = 0.05
        static let guideNodeStepLength: Float = 0.5
        static let guideNodeColor = UIColor.systemBlue
        static let previewNodeRadius: CGFloat = 0.15
        static let previewLineRadius: CGFloat = 0.02
        static let userLocationThreshold: Double = 0.05
    }
    
    // MARK: - Properties
    weak var map: LARMap?
    weak var mapView: MKMapView?
    weak var mapNode: SCNNode?
	public var userLocation: CLLocation? = nil
	public var userLocationAnnotation: MKPointAnnotation?
    
    // Additional delegate to forward map events
    public weak var additionalMapDelegate: LARMapDelegate?
    
    private let guideNode = ({
        let node = SCNNode()
        let geometry = SCNSphere(radius: Constants.guideNodeRadius)
        geometry.firstMaterial?.diffuse.contents = Constants.guideNodeColor
        node.geometry = geometry
        return node
    })()
    
    // Preview nodes for position offset
    private var previewNodes: [Int32: SCNNode] = [:]
	
	public var anchorNodes = LARSCNNodeCollection()
	public var anchors: [Int32:LARAnchor] = [:]
	public var navigationEdges: [(from: Int32, to: Int32)] = []
	
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
    
    /// Adds a navigation anchor point to the scene and map overlays
    /// - Parameter anchor: The anchor to add as a navigation point
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
        guard let node = anchorNodes.nodeById[anchor.id] else { return }
        node.simdTransform = transform
    }
    
    /// Creates a navigation edge between two anchors with visual guide nodes
    /// - Parameters:
    ///   - from: ID of the source anchor
    ///   - to: ID of the destination anchor
    public func addNavigationEdge(from: Int32, to: Int32) {
        guard let fromAnchor = anchors[from], let toAnchor = anchors[to] else {
            print("Warning: Cannot create edge between anchors \(from) and \(to) - one or both anchors not found")
            return
        }
        
        navigationEdges.append((from, to))
        createGuideNodes(from: fromAnchor, to: toAnchor)
        
        if let map, map.originReady {
            addMapEdgeOverlay(from: fromAnchor, to: toAnchor)
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
		
		for (fromId, toId) in navigationEdges {
			if let fromAnchor = anchors[fromId], let toAnchor = anchors[toId] {
				addMapEdgeOverlay(from: fromAnchor, to: toAnchor)
			}
		}
	}
	
	// MARK: - Selection Utilities
	
	public func getAnchorNode(id: Int32) -> LARSCNAnchorNode? {
		return anchorNodes.nodeById[id]
	}
	
	public func setAnchorSelection(id: Int32, selected: Bool) {
		anchorNodes.nodeById[id]?.isSelected = selected
	}
	
	public func clearAllSelections() {
		for (_, node) in anchorNodes.nodeById {
			node.isSelected = false
		}
	}
	
	// MARK: - Preview Management
	
	public func showPreviewNodes(for positions: [(id: Int32, position: simd_float3)]) {
		hidePreviewNodes() // Clear existing previews
		
		for (anchorId, previewPosition) in positions {
			// Create semi-transparent preview node
			let previewNode = createPreviewNode()
			previewNode.simdPosition = previewPosition
			mapNode?.addChildNode(previewNode)
			previewNodes[anchorId] = previewNode
			
			// Create connecting line from current to preview position
			if let currentNode = anchorNodes.nodeById[anchorId] {
				let lineNode = createPreviewLine(from: currentNode.simdPosition, to: previewPosition)
				mapNode?.addChildNode(lineNode)
				// Store line node with negative ID to distinguish it
				previewNodes[-anchorId] = lineNode
			}
		}
	}
	
	public func hidePreviewNodes() {
		for (_, node) in previewNodes {
			node.removeFromParentNode()
		}
		previewNodes.removeAll()
	}
	
	private func createPreviewNode() -> SCNNode {
		let node = SCNNode()
		let geometry = SCNSphere(radius: Constants.previewNodeRadius)
		
		// Semi-transparent green material
		let material = SCNMaterial()
		material.diffuse.contents = UIColor.systemGreen.withAlphaComponent(0.6)
		material.emission.contents = UIColor.systemGreen.withAlphaComponent(0.2)
		material.transparency = 0.6
		geometry.materials = [material]
		
		node.geometry = geometry
		return node
	}
	
	private func createPreviewLine(from start: simd_float3, to end: simd_float3) -> SCNNode {
		let vector = end - start
		let distance = simd_length(vector)
		
		// Create cylinder as line
		let cylinder = SCNCylinder(radius: Constants.previewLineRadius, height: CGFloat(distance))
		let material = SCNMaterial()
		material.diffuse.contents = UIColor.systemGreen.withAlphaComponent(0.4)
		cylinder.materials = [material]
		
		let lineNode = SCNNode(geometry: cylinder)
		
		// Position and orient the cylinder
		lineNode.simdPosition = (start + end) / 2.0
		
		// Calculate rotation to align cylinder with vector
		let up = simd_float3(0, 1, 0)
		let normalizedVector = simd_normalize(vector)
		
		if simd_length(normalizedVector - up) > 0.001 {
			let axis = simd_cross(up, normalizedVector)
			let angle = acos(simd_dot(up, normalizedVector))
			lineNode.simdRotation = simd_float4(axis.x, axis.y, axis.z, angle)
		}
		
		return lineNode
	}
	
#if canImport(UIKit)
	public func updateUserLocation(position: simd_float3) {
		guard let map, map.originReady else { return }
		let newLocation = map.location(from: simd_double3(position))
		let distance = userLocation?.distance(from: newLocation)
		guard distance == nil || distance! > Constants.userLocationThreshold else { return }
		
		if let userLocationAnnotation {
			userLocationAnnotation.coordinate = newLocation.coordinate
			userLocation = newLocation
			mapView?.setCenter(newLocation.coordinate, animated: true)
		} else {
			let annotation = MKPointAnnotation()
			mapView?.addAnnotation(annotation)
			mapView?.userTrackingMode = .none
			userLocationAnnotation = annotation
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
	
	public func map(_ map: LARMap, didAdd anchor: LARAnchor) {
		// Forward to additional delegate
		additionalMapDelegate?.map?(map, didAdd: anchor)
	}
	
	public func map(_ map: LARMap, didUpdate anchor: LARAnchor) {
		// Forward to additional delegate
		additionalMapDelegate?.map?(map, didUpdate: anchor)
	}
	
	public func map(_ map: LARMap, didUpdateOrigin transform: simd_double4x4) {
		updateMapOverlays()
		// Forward to additional delegate
		additionalMapDelegate?.map?(map, didUpdateOrigin: transform)
	}
	
	public func map(_ map: LARMap, willRemove anchor: LARAnchor) {
		removeNavigationAnchor(id: anchor.id)
		// Forward to additional delegate
		additionalMapDelegate?.map?(map, willRemove: anchor)
	}
	
	// MARK: - Anchor Management
	
	private func removeNavigationAnchor(id anchorId: Int32) {
		// Remove visual representations
		removeAnchorNode(id: anchorId)
		removeAnchorEdges(id: anchorId)
		refreshGuideNodes()
		
		// Remove from local collections
		anchors.removeValue(forKey: anchorId)
		anchorNodes.remove(withId: anchorId)
		
		// Update map overlays
		updateMapOverlays()
	}
	
	private func removeAnchorNode(id anchorId: Int32) {
		anchorNodes.nodeById[anchorId]?.removeFromParentNode()
	}
	
	private func removeAnchorEdges(id anchorId: Int32) {
		navigationEdges.removeAll { edge in
			edge.from == anchorId || edge.to == anchorId
		}
	}
	
	public func refreshGuideNodes() {
		removeAllGuideNodes()
		regenerateGuideNodes()
	}
	
	private func removeAllGuideNodes() {
		mapNode?.childNodes.forEach { node in
			if let sphere = node.geometry as? SCNSphere,
			   sphere.radius == Constants.guideNodeRadius,
			   !(node is LARSCNAnchorNode) { // Don't remove anchor nodes
				node.removeFromParentNode()
			}
		}
	}
	
	private func regenerateGuideNodes() {
		for (fromId, toId) in navigationEdges {
			// Look up anchors fresh from the dictionary to ensure they're still valid
			guard let fromAnchor = anchors[fromId],
				  let toAnchor = anchors[toId] else {
				continue // Skip edges with deleted anchors
			}
			
			createGuideNodes(from: fromAnchor, to: toAnchor)
		}
	}
	
	// MARK: - Guide Node Management
	
	/// Creates visual guide nodes between two anchors to show the navigation path
	private func createGuideNodes(from fromAnchor: LARAnchor, to toAnchor: LARAnchor) {
		let positions = calculateGuideNodePositions(
			from: simd_float3(fromAnchor.transform.position),
			to: simd_float3(toAnchor.transform.position)
		)
		
		for position in positions {
			let guide = guideNode.copy() as! SCNNode
			guide.simdPosition = position
			mapNode?.addChildNode(guide)
		}
	}
	
	private func calculateGuideNodePositions(from start: simd_float3, to goal: simd_float3) -> [simd_float3] {
		let distance = simd_distance(start, goal)
		guard distance > 0 else { return [] }
		
		let stepLength = Constants.guideNodeStepLength
		let stepDirection = (goal - start) / distance
		let stepVector = stepDirection * stepLength
		let stepCount = Int(floor(distance / stepLength))
		
		return (0..<stepCount).map { i in
			start + stepVector * Float(i + 1)
		}
	}
	
}
