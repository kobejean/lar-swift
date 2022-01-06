//
//  VisionManager+Match.swift
//  
//
//  Created by Jean Flaherty on 6/11/21.
//

import Foundation
import ARKit
import LANumerics
import opencv2

extension VisionManager {
    
    
    // MARK: Type Aliases
    
    typealias Match = (new: Feature, old: Feature)
    typealias NonMatches = (new: [Feature], old: [Feature])
    
    
    // MARK: Private Parameters
    
    private static let _nearestNeighborMatchRatio: Float = 0.8
    private static let _inlierThreshold: Float = 200.0 // 30
    
    
    // MARK: Match Feature Points
    
    /// Matches new feature points with old ones.
    /// - Parameters:
    ///   - new: New unziped feature points to match with old ones.
    ///   - old: Old unziped feature points to match with new ones.
    /// - Returns: A tuple of `matches` and `nonMatches`:
    ///   - `matches`: An array of matched feature points.
    ///   - `nonMatches`: A tuple with new and old unmatched zipped feature points.
    func matchFeaturePoints(new: UnzippedFeatures, old: UnzippedPlacedFeatures) -> (matches: [Match], nonMatches: NonMatches) {
        let newFeatures = Feature.zip(new)
        guard !old.descriptors.empty() else { return ([], (newFeatures, [])) }
        let oldFeatures = Feature.zip(old)
        
        var descriptorMatches = [[DMatch]]()
        matcher.knnMatch(
            queryDescriptors: old.descriptors,
            trainDescriptors: new.descriptors,
            matches: &descriptorMatches,
            k: 2
        )
        
        return _matchesAndNonMatches(
            descriptorMatches: descriptorMatches,
            new: new,
            old: old,
            newFeatures: newFeatures,
            oldFeatures: oldFeatures)
    }
    
    
    // MARK: Convert Output
    
    func _matchesAndNonMatches(
        descriptorMatches: [[DMatch]],
        new: UnzippedFeatures,
        old: UnzippedPlacedFeatures,
        newFeatures: [Feature],
        oldFeatures: [Feature]) -> (matches: [Match], nonMatches: NonMatches) {
        var discardOutliers = false
        if case .mapping = tracker?.mode {
            discardOutliers = true
        }
        
        var matches = [Match]()
        var newNonMatchesMap: [Int : Feature] = newFeatures.enumerated().reduce(into: [:]) { result, item in
            result[item.offset] = item.element
        }
        var oldNonMatchesMap: [Int : Feature] = oldFeatures.enumerated().reduce(into: [:]) { result, item in
            result[item.offset] = item.element
        }
        
        for queryMatches in descriptorMatches {
            guard queryMatches.count >= 2 else { continue }
            
            let firstMatch = queryMatches[0]
            let secondMatch = queryMatches[1]
            
            let newKeypoint = new.keypoints[Int(firstMatch.trainIdx)]
            let oldKeypoint = old.keypoints[Int(firstMatch.queryIdx)]
            
            // Calculate distance from matched point
            let newPoint = simd_float2(newKeypoint.pt.x, newKeypoint.pt.y)
            let oldPoint = simd_float2(oldKeypoint.pt.x, oldKeypoint.pt.y)
            let displacement = newPoint - oldPoint
            let distance = simd_length(displacement)
            
            let isMatch = firstMatch.distance < Self._nearestNeighborMatchRatio * secondMatch.distance
            let isInlier = distance < Self._inlierThreshold
            
            if isMatch && (!discardOutliers || isInlier) {
                let newMatchedIndex = Int(firstMatch.trainIdx)
                let oldMatchedIndex = Int(firstMatch.queryIdx)
                let newFeaturePoint = newFeatures[newMatchedIndex]
                let oldFeaturePoint = oldFeatures[oldMatchedIndex]
                
                matches.append((newFeaturePoint, oldFeaturePoint))
                newNonMatchesMap[newMatchedIndex] = nil
                oldNonMatchesMap[newMatchedIndex] = nil
            }
            
        }
        
        let newNonMatches = Array(newNonMatchesMap.values)
        let oldNonMatches = Array(oldNonMatchesMap.values)
        return (matches, (newNonMatches, oldNonMatches))
    }
}
