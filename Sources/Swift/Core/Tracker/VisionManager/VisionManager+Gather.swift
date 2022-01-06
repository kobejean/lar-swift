//
//  VisionManager+Gather.swift
//  
//
//  Created by Jean Flaherty on 6/10/21.
//

import Foundation
import ARKit
import LANumerics
import opencv2
import CoreLocation

extension VisionManager {
    
    
    // MARK: Gather Feature Points
    
    func gatherFeaturePoints(frame: ARFrame) -> UnzippedPlacedFeatures {
        let featurePoints = _gatherFeaturePointsNearby(frame: frame)
            .filter(_filter(camera: frame.camera))
        return _unzippedPlacedFeatures(camera: frame.camera, featurePoints: featurePoints)
    }
    
    
    // MARK: Helper Methods
    
    private func _gatherFeaturePointsNearby(frame: ARFrame) -> [FeaturePoint] {
        guard let tracker = tracker,
              let mapAnchor = frame.mapAnchor,
              let (point, radius) = _pointAndRadius(frame: frame)
        else { return [] }
        let mapSpacePoint = mapAnchor.moveIn(point)
        let mapSpaceFeaturePoints = tracker.map.pointCloud.featurnPoints(inBoundCenter: mapSpacePoint, radius: radius)
        
        syncWithSession { [weak self] in
            guard let self = self else { return }
            self.tracker?.delegate?.visionManager(self, didGather: mapSpaceFeaturePoints)
        }
        return mapAnchor.moveOut(mapSpaceFeaturePoints)
    }
    
    private func _pointAndRadius(frame: ARFrame) -> (point: simd_float2, radius: Float)? {
        let transform = frame.camera.transform
        var radius: Float = 10
        var point = simd_float2(transform[3,0], transform[3,2])
        
        if case .relocalizing = tracker?.state {
            // TODO: Clean up
            if let result = tracker?.locationManager.estimatedVirtualLocation(frame: frame) {
                radius = max(radius, result.accuracy)
                point = result.point
            } else {
                // We don't have a clue where we are
                return nil
            }
        }
        return (point, radius)
    }
    
    /// A higher-order functuon that creates a map from ``ARAnchor`` to ``GeoARKeyPointAnchor`` if the anchor is relevant to the associated camera
    /// - Parameter camera: The camera that the anchors are associated with. Used to get camera orientation and view matrix to store it once so that it doesn't need to be recomputed.
    /// - Returns: A closure that maps from an ``ARAnchor`` to ``GeoARKeyPointAnchor`` if it is relevant.
    private func _filter(camera: ARCamera) -> (FeaturePoint) -> Bool {
//        let cameraOrientation = simd_normalize(camera.transform.columns.2)
//        let viewMatrix = camera.viewMatrix(for: .landscapeRight)
        let trackingState = tracker?.state
        
        return { featurePoint in
            
            if case .relocalizing = trackingState {
                // if relocalizing forget about subsequent checks
                return true
            }
            return true
            
//            let featurePointOrientation = simd_normalize(featurePoint.transform.columns.2)
//            let featurePointDirection = simd_normalize(simd_make_float3(viewMatrix * featurePoint.transform.columns.3))
//
//            let orientationCosine = simd_dot(cameraOrientation, featurePointOrientation)
//            let directionCosine = -featurePointDirection.z
//
//            return orientationCosine > 0.5 && directionCosine > 0.5
        }
    }
    
    /// Creates unzipped feature points from feature point anchors.
    /// - Parameters:
    ///   - camera: The ``ARCamera`` is used to compute the projection from 3d to 2d.
    ///   - anchors: Prefiltered anchors to convert to feature points.
    /// - Returns: Unzipped anchored feature points.
    private func _unzippedPlacedFeatures(camera: ARCamera, featurePoints: [FeaturePoint]) -> UnzippedPlacedFeatures {
        var keypoints = [KeyPoint]()
        var descriptorsArray = [UInt8]()
        
        let projectionMap = _projectionMap(camera: camera)
        
        // Populate `keypoints` and `descriptorsArray`
        for featurePoint in featurePoints {
            let point = projectionMap(featurePoint.transform.columns.3)
            let extentPoint = projectionMap(featurePoint.transform.columns.3 + featurePoint.transform.columns.1)
            
            let delta = extentPoint - point
            let size = simd_length(delta) * 2
            let angle = atan2(delta.x, -delta.y)
            
            let keypoint = KeyPoint(x: point.x, y: point.y, size: size, angle: angle, response: featurePoint.response)
            
            keypoints.append(keypoint)
            descriptorsArray.append(contentsOf: featurePoint.descriptor)
        }
        
        // Convert `descriptorsArray` to one single `Mat` object
        let descriptorData = Data(descriptorsArray)
        let cols: Int32 = Int32(Feature.descriptorSize)
        let rows: Int32 = Int32(descriptorsArray.count) / cols
        let descriptors = Mat(rows: rows, cols: cols, type: CvType.CV_8UC1, data: descriptorData)
        
        return (keypoints, descriptors, featurePoints)
    }
    
    private func _projectionMap(camera: ARCamera) -> (simd_float4) -> simd_float2 {
        // Store matricies so that that do not have to be re-computed
        let viewMatrix = camera.viewMatrix(for: .landscapeRight)
        var intrinsics = camera.intrinsics
        intrinsics[0,0] = -intrinsics[0,0]
        return { point in
            let cameraSpace4 = viewMatrix * point
            let cameraSpace = simd_make_float3(cameraSpace4) / cameraSpace4.w
            let imageSpace3 = intrinsics * cameraSpace
            let imageSpace = simd_make_float2(imageSpace3) / imageSpace3.z
            return imageSpace
        }
    }
    
}
