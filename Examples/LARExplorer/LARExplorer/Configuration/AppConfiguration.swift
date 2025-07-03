//
//  AppConfiguration.swift
//  LARExplorer
//
//  Created by Jean Flaherty on 2025-06-30.
//

import Foundation
import MapKit
import SceneKit
import AppKit

enum AppConfiguration {
    enum Map {
        static let defaultSpanDelta: Double = 0.002
        static let animationDuration: Double = 0.5
        
        static let defaultMapPath = "/Users/kobejean/Developer/GitHub/lar-swift/.Submodules/lar/output/map"
    }
    
    enum Scene {
        static let backgroundColor: NSColor = .black
        static let preferredFramesPerSecond: Int = 60
        static let allowsCameraControl: Bool = true
        static let showsStatistics: Bool = true
        
        // Camera settings
        static let cameraZNear: Double = 0.1
        static let cameraZFar: Double = 10000.0
        static let cameraFieldOfView: CGFloat = 60
        static let cameraInitialPosition = SCNVector3(0, 10, 0)
        
        // Lighting
        static let ambientLightIntensity: CGFloat = 300
    }
    
    enum PointCloud {
        static let sphereRadius: CGFloat = 0.02  // Red landmarks are smaller
        static let chunkSize: Int = 1000
        static let nodeNamePrefix = "landmark_"
        static let containerNodeName = "LandmarkPointCloud"
        
        // Colors
        static let matchedLandmarkColor: NSColor = .systemGreen
        static let usableLandmarkColor: NSColor = .systemRed
        
        // Localization Highlighting
        enum Localization {
            static let highlightRadius: CGFloat = 0.03  // Larger than base landmarks
            static let spatialQueryColor: NSColor = .white
            static let matchColor: NSColor = .orange
            static let inlierColor: NSColor = .green
            
            // Node names
            static let spatialQueryNodeName = "SpatialQueryHighlights"
            static let matchNodeName = "MatchHighlights"
            static let inlierNodeName = "InlierHighlights"
            
            // Scale constraint
            static let scaleDistanceFactor: CGFloat = 10.0  // Divides distance for reasonable scaling
            static let enableScaleConstraint = true
        }
    }
    
    enum UI {
        static let mapViewHeight: CGFloat = 400
        static let toolbarSpacing: CGFloat = 0
    }
}
