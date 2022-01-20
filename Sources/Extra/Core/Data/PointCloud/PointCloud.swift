//
//  PointCloud.swift
//
//
//  Created by Jean Flaherty on 6/24/21.
//

import Foundation
import ARKit
import GameKit
import LANumerics

class PointCloud: Codable {
    
    // TODO: Implement custom R-tree
    var featurePointsRTree = GKRTree<FeaturePoint>(maxNumberOfChildren: 9)
    
    
    // MARK: Core proporties
    
    var featurePoints: Set<FeaturePoint>
    var locationPoints: Array<LocationPoint>
    var cameraPoints: Array<CameraPoint>
    
    
    // MARK: Cache
    
    var _locationCentroids: (real: CLLocation, virtual: simd_float4)?
    var _locationlRotationMatrix: simd_float2x2?
    var _locationCrossCovarianceMatrix: simd_float2x2?
    
    init() {
        self.featurePoints = []
        self.locationPoints = []
        self.cameraPoints = []
    }
    
    
    // MARK: Codable
    
    enum CodingKeys: String, CodingKey {
        case featurePoints = "featurePoints"
        case locationPoints = "locationPoints"
        case cameraPoints = "cameraPoints"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.featurePoints = try container.decode(Set<FeaturePoint>.self, forKey: .featurePoints)
        self.featurePointsRTree.add(Array(featurePoints))
        
        self.locationPoints = try container.decode(Array<LocationPoint>.self, forKey: .locationPoints)
        self.cameraPoints = try container.decode(Array<CameraPoint>.self, forKey: .cameraPoints)
    }
    
}
