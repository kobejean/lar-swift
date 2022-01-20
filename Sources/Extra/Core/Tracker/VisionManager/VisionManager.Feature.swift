//
//  VisionManager.Feature.swift
//  
//
//  Created by Jean Flaherty on 6/25/21.
//

import Foundation
import ARKit
import LANumerics
import opencv2

extension VisionManager {
    
    typealias UnzippedFeatures = (keypoints: [KeyPoint], descriptors: Mat)
    typealias UnzippedPlacedFeatures = (keypoints: [KeyPoint], descriptors: Mat, featurePoints: [FeaturePoint])
    
    class Feature {
        
        static let descriptorSize = 61
        
        let keypoint: KeyPoint
        let descriptor: [UInt8]
        var featurePoint: FeaturePoint?
        
        init(keypoint: KeyPoint, descriptor: [UInt8], featurePoint: FeaturePoint? = nil) {
            self.keypoint = keypoint
            self.descriptor = descriptor
            self.featurePoint = featurePoint
        }
        
        
        // MARK: Unzipping
        
        static func unzip(_ featurePoints: [Feature]) -> UnzippedFeatures {
            var keypoints = [KeyPoint]()
            var descriptorsArray = [UInt8]()
            
            for featurePoint in featurePoints {
                keypoints.append(featurePoint.keypoint)
                descriptorsArray.append(contentsOf: featurePoint.descriptor)
            }
            
            // Convert `descriptorsArray` to one single `Mat` object
            let descriptorData = Data(descriptorsArray)
            let cols = Int32(Feature.descriptorSize)
            let rows = Int32(descriptorsArray.count) / cols
            let descriptors = Mat(rows: rows, cols: cols, type: CvType.CV_8UC1, data: descriptorData)
            
            return (keypoints, descriptors)
        }
        
        static func unzip(_ featurePoints: [Feature]) -> UnzippedPlacedFeatures {
            let (keypoints, descriptors) = Self.unzip(featurePoints)
            let featurePoints = featurePoints.map({ $0.featurePoint! })
            return (keypoints, descriptors, featurePoints)
        }
        
        
        // MARK: Zipping
        
        /// Zips unzipped feature points
        /// - Parameter unzipped: Unzipped feature points.
        /// - Returns: An array of ``Feature`` types.
        static func zip(_ unzipped: UnzippedFeatures) -> [Feature] {
            let (keypoints, descriptors) = unzipped
            assert(keypoints.count == descriptors.rows(), "keypoints and descriptors do not match")
            
            return keypoints.enumerated().map { (i, keypoint) in
                let descriptor = _descriptor(at: i, descriptors: descriptors)
                return Feature(keypoint: keypoint, descriptor: descriptor)
            }
        }
        
        /// Zips unzipped placed feature points
        /// - Parameter unzipped: Unzipped anchored feature points.
        /// - Returns: An array of ``Feature`` types.
        static func zip(_ unzipped: UnzippedPlacedFeatures) -> [Feature] {
            let (keypoints, descriptors, featurePoints) = unzipped
            assert(keypoints.count == descriptors.rows(), "keypoints and descriptors do not match")
            assert(keypoints.count == featurePoints.count, "keypoints and featurePoints do not match")
            
            return keypoints.enumerated().map { (i, keypoint) in
                let descriptor = _descriptor(at: i, descriptors: descriptors)
                let featurePoint = featurePoints[i]
                return Feature(keypoint: keypoint, descriptor: descriptor, featurePoint: featurePoint)
            }
        }
        
        private static func _descriptor(at row: Int, descriptors: Mat) -> [UInt8] {
            let row = descriptors.row(Int32(row))
            return row.flatArray()
        }
    }
    
}
