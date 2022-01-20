//
//  VisionManager+Update.swift
//  
//
//  Created by Jean Flaherty on 6/10/21.
//

import Foundation
import ARKit
import LANumerics
import opencv2

extension VisionManager {
    
    
    // MARK: Update Feature Points
    
    @discardableResult
    func updateFeaturePoints(frame: ARFrame, matches: [Match]) -> [Feature] {
        var add = [FeaturePoint]()
        var remove = [FeaturePoint]()
        
        let featurePointFromFeature = _featurePointFromFeature(camera: frame.camera)
        
        for (new, old) in matches {
            new.featurePoint = featurePointFromFeature(new, old.featurePoint?.identifier)
        }
        
        // Populate `add` and `remove`
        for (new, old) in matches {
            guard new.keypoint.response > old.keypoint.response,
                  let newFeaturePoint = new.featurePoint,
                  let oldFeaturePoint = old.featurePoint
            else { continue }
            add.append(newFeaturePoint)
            remove.append(oldFeaturePoint)
        }
        
        guard let mapAnchor = frame.mapAnchor else { return [] }
        
        let mapSpaceRemoved = mapAnchor.moveIn(remove)
        let mapSpaceAdded = mapAnchor.moveIn(add)
        let mapSpaceFeatures = zip(matches, mapSpaceAdded).reduce(into: [Feature]()) { result, item in
            let feature = item.0.new
            feature.featurePoint = item.1
            result.append(feature)
        }
        
        syncWithSession { [weak self] in
            guard let self = self,
                  let tracker = self.tracker
            else { return }
            
            tracker.map.pointCloud.remove(mapSpaceRemoved)
            tracker.map.pointCloud.add(mapSpaceAdded)
            
            tracker.delegate?.visionManager(self, didUpdate: mapSpaceAdded)
        }
        
        return mapSpaceFeatures
    }
    
    private func _featurePointFromFeature(camera: ARCamera) -> (Feature, UUID?) -> FeaturePoint? {
        let origin = simd_make_float3(camera.transform.columns.3)
        let directionMatrix = camera.directionMatrix
        return { [weak self] feature, identifier in
            let keypoint = feature.keypoint
            let θ = keypoint.angle.degreesToRadians
            let r = keypoint.size / 2
            let pointAndExtent = simd_float2x3(
                .init(keypoint.pt.x, keypoint.pt.y, 1),
                .init(keypoint.pt.x + r * sin(θ), keypoint.pt.y - r * cos(θ), 1)
            )
            let (direction, extentDirection) = (directionMatrix * pointAndExtent).columns
            let query = ARRaycastQuery(
                origin: origin,
                direction: direction,
                allowing: .estimatedPlane,
                alignment: .any
            )
            let result = self?.tracker?.session?.raycast(query)
            
            guard let firstResult = result?.first else { return nil }
            
            // We want z-axis to point toward us
            let point = firstResult.worldTransform.columns.3
            let pointToCamera = origin - simd_make_float3(point)
            let extentVector = extentDirection - direction
            let zVector = simd_normalize(pointToCamera)
            // Use cross-product to make axes orthogonal
            let xVector = simd_normalize(simd_cross(extentVector, zVector))
            let yVector = simd_cross(zVector, xVector)
            // Calculate distance from camera and feature point extent to scale axses
            let distance = simd_length(pointToCamera)
            let extent = distance * simd_length(extentVector)
            
            // Not worth saving if its too small or too close
            guard extent >= Self.minFeaturePointExtent,
                  distance >= Self.minFeaturePointDistance else { return nil }
            
            let transform = simd_float4x4(
                simd_make_float4(xVector * extent),
                simd_make_float4(yVector * extent),
                simd_make_float4(zVector * distance),
                point
            )
            return FeaturePoint(
                transform: transform,
                descriptor: feature.descriptor,
                response: keypoint.response,
                identifier: identifier ?? UUID())
        }
    }
    
    
    // MARK: Add Feature Points
    
    @discardableResult
    func addFeaturePoints(frame: ARFrame, nonMatches: NonMatches) -> [Feature] {
        let featurePointFromFeature = _featurePointFromFeature(camera: frame.camera)
        let featurePoints = _filteredFeatures(nonMatches.new)
            .compactMap({ featurePointFromFeature($0, nil) })
        
        
        guard let mapAnchor = frame.mapAnchor else { return [] }
        
        let mapSpaceAdded = mapAnchor.moveIn(featurePoints)
        let mapSpaceFeatures = zip(nonMatches.new, mapSpaceAdded).reduce(into: [Feature]()) { result, item in
            let feature = item.0
            feature.featurePoint = item.1
            result.append(feature)
        }
        
        syncWithSession { [weak self] in
            guard let self = self,
                  let tracker = self.tracker
            else { return }
            
            tracker.map.pointCloud.add(mapSpaceAdded)
            
            tracker.delegate?.visionManager(self, didAdd: mapSpaceAdded)
        }
        
        return mapSpaceFeatures
    }

    private func _filteredFeatures(_ features: [Feature]) -> AnySequence<Feature> {
        return AnySequence(
            features
                .sorted(by: { $0.keypoint.response >= $1.keypoint.response })
                .prefix(Self.featurePointAnchorAdditionLimit)
        )
    }
    
}
