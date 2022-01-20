//
//  GeoARView.MapRenderer.swift
//  
//
//  Created by Jean Flaherty on 7/7/21.
//

import Foundation
import RealityKit
import ARKit


extension GeoARView {
    
    class DebugRenderer: NSObject {
        
        weak var view: GeoARView!
        
        var mapDataEntity = AnchorEntity()
        
        
        // MARK: Entity Definitions
        
        enum EntityType: String {
    //        case locationPoint = "locationPoint"
            case addedFeaturePoint = "addedFeaturePoint"
            case gatheredFeaturePoint = "gatheredFeaturePoint"
            case trackedFeaturePoint = "trackedFeaturePoint"
        }
        
        static let addedFeaturePoint = FeaturePointEntity(
            color: UIColor.orange, name: EntityType.addedFeaturePoint.rawValue)
        static let gatheredFeaturePoint = FeaturePointEntity(
            color: UIColor.gray.withAlphaComponent(0.8), name: EntityType.gatheredFeaturePoint.rawValue)
        static let trackedFeaturePoint = FeaturePointEntity(
            color: UIColor.green, name: EntityType.trackedFeaturePoint.rawValue)
        
        
        // MARK: Helpers
        
        func removeAllEntities(of type: EntityType) {
            let entities = mapDataEntity.children.filter({ entity in entity.name == type.rawValue })
            for entity in entities {
                entity.removeFromParent()
            }
        }
        
        func removeAllEntities() {
            let types = Set([
                EntityType.addedFeaturePoint.rawValue,
                EntityType.gatheredFeaturePoint.rawValue,
                EntityType.trackedFeaturePoint.rawValue
            ])

            let entities = mapDataEntity.children.filter({ entity in types.contains(entity.name) })
            for entity in entities {
                entity.removeFromParent()
            }
        }
        
    }
    
    class FeaturePointEntity: Entity, HasModel {
        
        required init(color: UIColor, name: String) {
            super.init()
            self.name = name
            self.model = ModelComponent(
                mesh: .generatePlane(width: 2.0, height: 2.0),
                materials: [UnlitMaterial(color: color)])
        }
        
        required init() {
            super.init()
        }
        
    }
    
}
