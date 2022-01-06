//
//  GeoARSCNView.MapRenderer+InternalTrackerDelegate.swift
//  
//
//  Created by Jean Flaherty on 7/7/21.
//

import Foundation
import SceneKit
import ARKit


extension GeoARSCNView.MapRenderer: InternalTrackerDelegate {
    
    
    // MARK: InternalTrackerDelegate
    
    func locationManager(_ locationManager: LocationManager, didAdd locationPoints: [LocationPoint]) {
        guard view?.geoARDebugOptions.contains(.showLocationPoints) == true else { return }
        
        let transforms = locationPoints.map({ $0.transform })
        addNodes(of: .locationPoint, with: transforms)
    }
    
    func visionManager(_ visionManager: VisionManager, didGather featurePoints: [FeaturePoint]) {
        removeAllNodes(of: .gatheredFeaturePoint)
        
        guard view?.geoARDebugOptions.contains(.showFeaturePoints) == true else { return }
        
        let transforms = featurePoints.shuffled().prefix(400).map({ $0.transform })
        addNodes(of: .gatheredFeaturePoint, with: transforms)
    }
    
    func visionManager(_ visionManager: VisionManager, didAdd featurePoints: [FeaturePoint]) {
        removeAllNodes(of: .addedFeaturePoint)
        
        guard view?.geoARDebugOptions.contains(.showFeaturePoints) == true else { return }
        
        let transforms = featurePoints.prefix(200).map({ $0.transform })
        addNodes(of: .addedFeaturePoint, with: transforms)
    }
    
    func visionManager(_ visionManager: VisionManager, didUpdate featurePoints: [FeaturePoint]) {
        removeAllNodes(of: .trackedFeaturePoint)
        
        guard view?.geoARDebugOptions.contains(.showFeaturePoints) == true else { return }
        
        let transforms = featurePoints.prefix(200).map({ $0.transform })
        addNodes(of: .trackedFeaturePoint, with: transforms)
    }
    
    func visionManager(_ visionManager: VisionManager, didRegister featurePoints: [FeaturePoint]) {
        self.removeAllNodes(of: .addedFeaturePoint)
        self.visionManager(visionManager, didUpdate: featurePoints)
    }
    
    
    // MARK: ARSessionDelegate
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        if case .limited(.initializing) = camera.trackingState {
            _initialize(session: session)
        }
    }
    
    private func _initialize(session: ARSession) {
        _populateNavigationGraphs()
        updateNavigationGuideNodes()
        renderLocationPoints(session: session)
    }
    
    /// saved navigation graphs should have `adjacencyList` populated but we need to manually populate `vertices`
    private func _populateNavigationGraphs() {
        let anchors = view?.tracker.map.anchors ?? []
        let navigationGraphs = anchors.compactMap({ ($0 as? GeoARNavigationGraphAnchor)?.graph })
        let navigationAnchors = anchors.compactMap({ $0 as? GeoARNavigationAnchor })
        let vertices = Dictionary(uniqueKeysWithValues: navigationAnchors.map{ ($0.identifier, $0) })
        
        for navigationGraph in navigationGraphs {
            // Just add the vertices we need
            navigationGraph.vertices = vertices.filter({ navigationGraph.adjacencyList[$0.key] != nil })
        }
    }
}
