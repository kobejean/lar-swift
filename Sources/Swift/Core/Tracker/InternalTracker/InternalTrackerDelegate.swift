//
//  GeoARMapTrackerDelegate.swift
//  
//
//  Created by Jean Flaherty on 6/13/21.
//

import Foundation
import ARKit


protocol InternalTrackerDelegate: ARSessionDelegate {
    
    func locationManager(_ locationManager: LocationManager, didAdd locationPoints: [LocationPoint])
    
    func visionManager(_ visionManager: VisionManager, didGather featurePoints: [FeaturePoint])
    
    func visionManager(_ visionManager: VisionManager, didAdd featurePoints: [FeaturePoint])
    
    func visionManager(_ visionManager: VisionManager, didUpdate featurePoints: [FeaturePoint])
    
    func visionManager(_ visionManager: VisionManager, didRemove featurePoints: [FeaturePoint])
    
    func visionManager(_ visionManager: VisionManager, didRegister featurePoints: [FeaturePoint])
    
}

extension InternalTrackerDelegate {
    
    func locationManager(_ locationManager: LocationManager, didAdd locationPoints: [LocationPoint]) {
        
    }
    
    func visionManager(_ visionManager: VisionManager, didGather featurePoints: [FeaturePoint]) {
        
    }
    
    func visionManager(_ visionManager: VisionManager, didAdd featurePoints: [FeaturePoint]) {
        
    }
    
    func visionManager(_ visionManager: VisionManager, didUpdate featurePoints: [FeaturePoint]) {
        
    }
    
    func visionManager(_ visionManager: VisionManager, didRemove featurePoints: [FeaturePoint]) {
        
    }
    
    func visionManager(_ visionManager: VisionManager, didRegister featurePoints: [FeaturePoint]) {
        
    }
    
}
