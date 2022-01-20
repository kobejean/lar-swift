//
//  GeoARView.MapRenderer+InternalTrackerDelegate.swift
//  
//
//  Created by Jean Flaherty on 7/7/21.
//

import Foundation
import RealityKit
import ARKit

extension GeoARView.DebugRenderer: InternalTrackerDelegate {
    
    
    // MARK: ARSessionDelegate
    
    public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        
        if let anchor = anchors.first(where: { $0 is GeoARMapAnchor }) {
            mapDataEntity.removeFromParent()
            // RealityKit doesn't seem to work on the simulator
            #if !targetEnvironment(simulator)
            mapDataEntity.anchoring = AnchoringComponent(anchor)
            #endif
            view.scene.addAnchor(mapDataEntity)
        }
        
    }
    
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
    }
    
    public func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        
    }
    
    
    // MARK: InternalTrackerDelegate
    
    func visionManager(_ visionManager: VisionManager, didGather featurePoints: [FeaturePoint]) {
        removeAllEntities(of: .gatheredFeaturePoint)

        guard view.geoARDebugOptions.contains(.showFeaturePoints) else { return }
        
        for featurePoint in featurePoints.prefix(400) {
            let entity = Self.gatheredFeaturePoint.clone(recursive: false)
            entity.transform = Transform(matrix: featurePoint.transform)
            mapDataEntity.addChild(entity)
        }
    }
    
    func visionManager(_ visionManager: VisionManager, didAdd featurePoints: [FeaturePoint]) {
        removeAllEntities(of: .addedFeaturePoint)
        
        guard view.geoARDebugOptions.contains(.showFeaturePoints) else { return }
        
        for featurePoint in featurePoints.prefix(200) {
            let entity = Self.addedFeaturePoint.clone(recursive: false)
            entity.transform = Transform(matrix: featurePoint.transform)
            mapDataEntity.addChild(entity)
        }
    }
    
    func visionManager(_ visionManager: VisionManager, didUpdate featurePoints: [FeaturePoint]) {
        removeAllEntities(of: .trackedFeaturePoint)
        
        guard view.geoARDebugOptions.contains(.showFeaturePoints) else { return }
        
        for featurePoint in featurePoints.prefix(200) {
            let entity = Self.trackedFeaturePoint.clone(recursive: false)
            entity.transform = Transform(matrix: featurePoint.transform)
            mapDataEntity.addChild(entity)
        }
    }
    
    func visionManager(_ visionManager: VisionManager, didRegister featurePoints: [FeaturePoint]) {
        self.removeAllEntities(of: .addedFeaturePoint)
        self.visionManager(visionManager, didUpdate: featurePoints)
    }
    
}
