//
//  LARNavigationCoordinator.swift
//  LocalizeAR
//
//  Created by Jean Atsumi Flaherty on 2025-10-05.
//

import Foundation
import SceneKit
import MapKit
import CoreLocation
import LocalizeAR_ObjC

/// Delegate protocol for navigation coordinator events
@objc public protocol LARNavigationCoordinatorDelegate: AnyObject {
    @objc optional func navigationCoordinator(_ coordinator: LARNavigationCoordinator, didSelectAnchor anchor: LARAnchor)
    @objc optional func navigationCoordinator(_ coordinator: LARNavigationCoordinator, didUpdateUserLocation location: CLLocation)
}

/// Coordinates navigation visualization across SceneKit and MapKit
/// This is a Facade that provides a simplified API for navigation features
public class LARNavigationCoordinator: NSObject {
    // MARK: - Dependencies
    private let map: LARMap
    private let sceneRenderer: LARSceneRendering
    private let mapRenderer: LARMapRendering
    private let navigationGraph: LARNavigationGraphAdapter
    private let stateManager: LARNavigationStateManaging

    // MARK: - Properties
    public weak var delegate: LARNavigationCoordinatorDelegate?

    /// Additional map delegate for app-specific logic (e.g., auto-creating edges)
    public weak var additionalMapDelegate: LARMapDelegate?

    /// All navigation anchors
    public var anchors: [Int32: LARAnchor] {
        return navigationGraph.anchors
    }

    /// All navigation edges
    public var navigationEdges: [(from: Int32, to: Int32)] {
        return navigationGraph.edges
    }

    /// Currently selected anchor IDs
    public var selectedAnchorIds: Set<Int32> {
        return stateManager.selectedAnchorIds
    }

    /// Current user location
    public var userLocation: CLLocation? {
        return stateManager.userLocation
    }

    // MARK: - Initialization

    /// Initialize the navigation coordinator
    /// - Parameters:
    ///   - map: The map containing navigation data
    ///   - sceneRenderer: Renderer for SceneKit visualization
    ///   - mapRenderer: Renderer for MapKit visualization
    ///   - navigationGraph: Graph containing anchors and edges
    ///   - stateManager: Manager for navigation state
    public init(
        map: LARMap,
        sceneRenderer: LARSceneRendering,
        mapRenderer: LARMapRendering,
        navigationGraph: LARNavigationGraphAdapter,
        stateManager: LARNavigationStateManaging
    ) {
        self.map = map
        self.sceneRenderer = sceneRenderer
        self.mapRenderer = mapRenderer
        self.navigationGraph = navigationGraph
        self.stateManager = stateManager
        super.init()

        // Set up as map delegate to listen for origin updates
        map.delegate = self
    }

    /// Convenience initializer that creates default implementations
    /// - Parameter map: The map containing navigation data
    public convenience init(map: LARMap) {
        let sceneRenderer = LARSceneRenderer()
        let mapRenderer = LARMapRenderer()
        let navigationGraph = LARNavigationGraphAdapter(map: map)
        let stateManager = LARNavigationStateManager()

        self.init(
            map: map,
            sceneRenderer: sceneRenderer,
            mapRenderer: mapRenderer,
            navigationGraph: navigationGraph,
            stateManager: stateManager
        )
    }

    // MARK: - Configuration

    /// Configure with SceneKit and MapKit views
    /// - Parameters:
    ///   - sceneNode: Root node for SceneKit rendering
    ///   - mapView: MapKit view for map rendering
    public func configure(sceneNode: SCNNode, mapView: MKMapView) {
        sceneRenderer.configure(with: sceneNode)
        mapRenderer.configure(with: mapView)

        // Load existing anchors and edges from the map
        loadExistingNavigationData()
    }

    // MARK: - Anchor Management

    /// Add a navigation point to the scene and map
    /// - Parameter anchor: The anchor to add
    public func addNavigationPoint(anchor: LARAnchor) {
        navigationGraph.addAnchor(anchor)
        sceneRenderer.addAnchorNode(for: anchor)

        if map.originReady {
            mapRenderer.addAnchorOverlay(for: anchor, using: map)
        }
    }

    /// Update a navigation point's transform
    /// - Parameters:
    ///   - anchor: The anchor to update
    ///   - transform: New transform matrix
    public func updateNavigationPoint(anchor: LARAnchor, transform: simd_float4x4) {
        sceneRenderer.updateAnchorNode(anchorId: anchor.id, transform: transform)
    }

    /// Remove a navigation anchor
    /// - Parameter anchorId: ID of the anchor to remove
    public func removeNavigationAnchor(id anchorId: Int32) {
        navigationGraph.removeAnchor(id: anchorId)
        sceneRenderer.removeAnchorNode(anchorId: anchorId)
        removeAnchorEdges(id: anchorId)
        refreshGuideNodes()
        updateMapOverlays()
    }

    // MARK: - Edge Management

    /// Add a navigation edge between two anchors
    /// - Parameters:
    ///   - from: ID of the source anchor
    ///   - to: ID of the destination anchor
    public func addNavigationEdge(from: Int32, to: Int32) {
        guard let fromAnchor = navigationGraph.anchors[from],
              let toAnchor = navigationGraph.anchors[to] else {
            print("Warning: Cannot create edge between anchors \(from) and \(to) - one or both anchors not found")
            return
        }

        navigationGraph.addEdge(from: from, to: to)

        // Add visual guide nodes
        let fromPos = simd_float3(fromAnchor.transform.position)
        let toPos = simd_float3(toAnchor.transform.position)
        sceneRenderer.addEdgeGuideNodes(from: fromPos, to: toPos)

        // Add map overlay
        if map.originReady {
            mapRenderer.addEdgeOverlay(from: fromAnchor, to: toAnchor, using: map)
        }
    }

    // MARK: - Selection Management

    /// Select an anchor
    /// - Parameter anchorId: ID of the anchor to select
    public func selectAnchor(id anchorId: Int32) {
        stateManager.selectAnchor(anchorId: anchorId)
        sceneRenderer.highlightAnchor(anchorId: anchorId)

        if let anchor = navigationGraph.anchors[anchorId] {
            delegate?.navigationCoordinator?(self, didSelectAnchor: anchor)
        }
    }

    /// Deselect an anchor
    /// - Parameter anchorId: ID of the anchor to deselect
    public func deselectAnchor(id anchorId: Int32) {
        stateManager.deselectAnchor(anchorId: anchorId)
        sceneRenderer.unhighlightAnchor(anchorId: anchorId)
    }

    /// Clear all selections
    public func clearAllSelections() {
        stateManager.clearSelection()
        sceneRenderer.clearAllHighlights()
    }

    /// Set anchor selection state (for backward compatibility)
    /// - Parameters:
    ///   - anchorId: ID of the anchor
    ///   - selected: Whether to select or deselect
    public func setAnchorSelection(id anchorId: Int32, selected: Bool) {
        if selected {
            selectAnchor(id: anchorId)
        } else {
            deselectAnchor(id: anchorId)
        }
    }

    /// Check if an anchor is selected
    /// - Parameter anchorId: ID of the anchor to check
    /// - Returns: True if the anchor is selected
    public func isAnchorSelected(id anchorId: Int32) -> Bool {
        return stateManager.isAnchorSelected(anchorId: anchorId)
    }

    /// Get an anchor node by ID
    /// - Parameter anchorId: ID of the anchor
    /// - Returns: The SceneKit node, or nil if not found
    public func getAnchorNode(id anchorId: Int32) -> LARSCNAnchorNode? {
        return sceneRenderer.getAnchorNode(anchorId: anchorId)
    }

    // MARK: - Preview Management

    /// Show preview nodes for position offset
    /// - Parameter positions: Array of (anchor ID, preview position) tuples
    public func showPreviewNodes(for positions: [(id: Int32, position: simd_float3)]) {
        sceneRenderer.showPreviewNodes(positions)
    }

    /// Hide all preview nodes
    public func hidePreviewNodes() {
        sceneRenderer.hidePreviewNodes()
    }

    // MARK: - User Location

#if canImport(UIKit)
    /// Update user location (iOS only)
    /// - Parameter position: User's position in map coordinates
    public func updateUserLocation(position: simd_float3) {
        guard map.originReady else { return }

        let newLocation = map.location(from: simd_double3(position))

        // Only update if location changed significantly
        if let currentLocation = stateManager.userLocation {
            let distance = currentLocation.distance(from: newLocation)
            if distance < 0.05 { // 5cm threshold
                return
            }
        }

        stateManager.updateUserLocation(newLocation)
        mapRenderer.updateUserLocation(newLocation, animated: true)
        delegate?.navigationCoordinator?(self, didUpdateUserLocation: newLocation)
    }
#endif

    // MARK: - Cleanup

    /// Remove all navigation elements
    public func removeAllNavigationElements() {
        navigationGraph.removeAllAnchors()
        navigationGraph.removeAllEdges()
        sceneRenderer.removeAllNavigationElements()
        mapRenderer.removeAllOverlays()
        stateManager.clearSelection()
    }

    /// Refresh guide nodes (e.g., after edge changes)
    public func refreshGuideNodes() {
        sceneRenderer.removeAllGuideNodes()
        regenerateGuideNodes()
    }

    /// Update map overlays (e.g., after origin changes or anchor updates)
    public func updateMapOverlays() {
        guard map.originReady else { return }
        mapRenderer.updateAllOverlays(
            anchors: navigationGraph.anchors,
            edges: navigationGraph.edges,
            using: map
        )
    }

    // MARK: - Private Helper Methods

    private func loadExistingNavigationData() {
        // Load anchors from map
        for anchor in map.anchors {
            addNavigationPoint(anchor: anchor)
        }

        // Load edges from map
        for (from_id, to_ids) in map.edges {
            let from = Int32(truncating: from_id)
            for to_id in to_ids {
                let to = Int32(truncating: to_id)
                if to <= from { continue } // Avoid duplicates
                addNavigationEdge(from: from, to: to)
            }
        }
    }

    private func removeAnchorEdges(id anchorId: Int32) {
        navigationGraph.removeEdges(for: anchorId)
    }

    private func regenerateGuideNodes() {
        for (fromId, toId) in navigationGraph.edges {
            guard let fromAnchor = navigationGraph.anchors[fromId],
                  let toAnchor = navigationGraph.anchors[toId] else {
                continue
            }

            let fromPos = simd_float3(fromAnchor.transform.position)
            let toPos = simd_float3(toAnchor.transform.position)
            sceneRenderer.addEdgeGuideNodes(from: fromPos, to: toPos)
        }
    }
}

// MARK: - MKMapViewDelegate Forwarding
extension LARNavigationCoordinator {
    /// Forward MKMapViewDelegate renderer method to internal map renderer
    /// This provides backward compatibility for apps that delegate map rendering to the coordinator
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Cast to concrete type to access MKMapViewDelegate methods
        guard let concreteRenderer = mapRenderer as? LARMapRenderer else {
            return MKOverlayRenderer(overlay: overlay)
        }
        return concreteRenderer.mapView(mapView, rendererFor: overlay)
    }

#if canImport(UIKit)
    /// Forward MKMapViewDelegate annotation view method to internal map renderer (iOS only)
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let concreteRenderer = mapRenderer as? LARMapRenderer else {
            return nil
        }
		return concreteRenderer.mapView(mapView, viewFor: annotation)
    }
#endif
}

// MARK: - LARMapDelegate
extension LARNavigationCoordinator: LARMapDelegate {
    public func map(_ map: LARMap, didAdd anchors: [LARAnchor]) {
        // Map delegate callback - anchors were added to map
        // We handle this through addNavigationPoint instead

        // Forward to additional delegate for app-specific logic
        additionalMapDelegate?.map?(map, didAdd: anchors)
    }

    public func map(_ map: LARMap, didUpdate anchors: [LARAnchor]) {
        // Map delegate callback - bulk anchor update
        for anchor in anchors {
            let floatTransform = simd_float4x4(
                simd_float4(anchor.transform.columns.0),
                simd_float4(anchor.transform.columns.1),
                simd_float4(anchor.transform.columns.2),
                simd_float4(anchor.transform.columns.3)
            )
            updateNavigationPoint(anchor: anchor, transform: floatTransform)
        }

        // Refresh visualizations once after all anchors updated
        refreshGuideNodes()
        updateMapOverlays()

        // Forward to additional delegate
        additionalMapDelegate?.map?(map, didUpdate: anchors)
    }

    public func map(_ map: LARMap, didUpdateOrigin transform: simd_double4x4) {
        // Map origin changed - update all map overlays and guide nodes
        updateMapOverlays()
        refreshGuideNodes()

        // Forward to additional delegate
        additionalMapDelegate?.map?(map, didUpdateOrigin: transform)
    }

    public func map(_ map: LARMap, willRemove anchors: [LARAnchor]) {
        // Map delegate callback - anchors will be removed from map
        for anchor in anchors {
            removeNavigationAnchor(id: anchor.id)
        }

        // Forward to additional delegate
        additionalMapDelegate?.map?(map, willRemove: anchors)
    }

    public func map(_ map: LARMap, didAddEdgeFrom fromId: Int32, to toId: Int32) {
        // Edge was added - forward to additional delegate
        additionalMapDelegate?.map?(map, didAddEdgeFrom: fromId, to: toId)
    }
}
