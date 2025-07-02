//
//  MapConfigurationService.swift
//  LARExplorer
//
//  Created by Claude Code on 2025-06-30.
//

import Foundation
import MapKit
import SceneKit
import LocalizeAR

@MainActor
struct MapConfigurationService {
    
    // MARK: - Map Region Configuration
    static func configureMapRegion(mapView: MKMapView, for map: LARMap) {
        let location = map.location(from: simd_double3())
        let region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(
                latitudeDelta: AppConfiguration.Map.defaultSpanDelta,
                longitudeDelta: AppConfiguration.Map.defaultSpanDelta
            )
        )
        
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - Scene Configuration
    static func configureScene(sceneView: SCNView) {
        sceneView.backgroundColor = AppConfiguration.Scene.backgroundColor
        sceneView.preferredFramesPerSecond = AppConfiguration.Scene.preferredFramesPerSecond
        sceneView.allowsCameraControl = AppConfiguration.Scene.allowsCameraControl
        sceneView.showsStatistics = AppConfiguration.Scene.showsStatistics
    }
    
    // MARK: - Navigation Initialization
    static func createNavigationManager(
        with map: LARMap,
        mapView: MKMapView,
        mapNode: SCNNode
    ) -> LARNavigationManager {
        let navigationManager = LARNavigationManager(
            map: map,
            mapView: mapView,
            mapNode: mapNode
        )
        return navigationManager
    }
    
    // MARK: - Point Cloud Operations
    static func loadPointCloud(
        from map: LARMap,
        into mapNode: SCNNode,
        progressHandler: @escaping (Double) -> Void = { _ in }
    ) async throws {
        let renderer = PointCloudRenderer()
        do {
            await renderer.loadPointCloud(
                from: map,
                into: mapNode,
                progressHandler: progressHandler
            )
        } catch {
            print("Failed to load point cloud: \(error)")
            throw error
        }
    }
    
    static func togglePointCloudVisibility(in mapNode: SCNNode, isVisible: Bool) {
        mapNode.childNode(withName: AppConfiguration.PointCloud.containerNodeName, recursively: false)?.isHidden = !isVisible
    }
}