//
//  VisionManager+Verify+Straighten.swift
//  
//
//  Created by Jean Flaherty on 7/15/21.
//

import Foundation
import ARKit
import LANumerics
import opencv2

extension VisionManager {
    
    func verifyAlignmentAndStraighten(
        frame: ARFrame,
        matches: [Match],
        inliers: [Match],
        relativeTransform: simd_float4x4
    ) -> simd_float4x4? {
        
        let inlierCentroid = _inlierCentroid(inliers: inliers)
        let centroidDisplacement = (relativeTransform * inlierCentroid) - inlierCentroid
        
        guard verifyAlignment(
                relativeTransform: relativeTransform,
                inliers: inliers,
                matchCount: matches.count,
                centroid: inlierCentroid,
                centroidDisplacement: centroidDisplacement,
                camera: frame.camera)
        else { return nil }
         
        return straighten(
            relativeTransform: relativeTransform,
            centroidDisplacement: centroidDisplacement)
    }
    
    private func _inlierCentroid(inliers: [Match]) -> simd_float4 {
        var centroid = simd_float4(0,0,0,0)
        // Sum
        for inlier in inliers {
            centroid += inlier.old.featurePoint!.transform[3]
        }
        // Divide
        centroid *= (1 / Float(inliers.count))
        return centroid
    }
    
    
    // MARK: Verify Alignment
    
    func verifyAlignment(
        relativeTransform: simd_float4x4,
        inliers: [Match],
        matchCount: Int,
        centroid: simd_float4,
        centroidDisplacement: simd_float4,
        camera: ARCamera
    ) -> Bool {
        guard _verifyHasEnoughInliers(inliers: inliers, matchCount: matchCount),
              _verifyYAxisIsReasonable(relativeTransform: relativeTransform),
              _verifyCovarianceDeterminantIsReasonable(inliers: inliers),
              _verifyIsNotAnAnomaly(
                relativeTransform: relativeTransform,
                centroid: centroid,
                centroidDisplacement: centroidDisplacement,
                camera: camera)
        else { return false }
        
        tracker?.externalTracker?.debugString = ""
        return true
    }
    
    private func _verifyHasEnoughInliers(inliers: [Match], matchCount: Int) -> Bool {
        let inlierRatio = Float(inliers.count) / Float(matchCount)
        let hasEnoughInliers = inliers.count >= Self.minInliersForRegistration
        
        if #available(iOS 14, *) {
            logger.debug("""
            hasEnoughInliers: \(hasEnoughInliers)
            inliers.count: \(inliers.count)
            inlierRatio: \(inlierRatio)
            """)
        }
        if !hasEnoughInliers {
            tracker?.externalTracker?.debugString = "Not enough inliers: \(inliers.count)"
        }
        return hasEnoughInliers
    }
    
    private func _verifyYAxisIsReasonable(relativeTransform: simd_float4x4) -> Bool {
        let yAxisChangeCosine = relativeTransform[1,1]
        let yAxisIsReasonable = yAxisChangeCosine >= Self.minYAxisChangeCosine
        if #available(iOS 14, *) {
            logger.debug("""
            yAxisIsReasonable: \(yAxisIsReasonable)
            yAxisChangeCosine: \(yAxisChangeCosine)
            relativeTransform: \(Matrix(relativeTransform))
            """)
        }
        if !yAxisIsReasonable {
            tracker?.externalTracker?.debugString = "Y axis is not reasonable: \(yAxisChangeCosine)"
        }
        return yAxisIsReasonable
    }
    
    private func _verifyCovarianceDeterminantIsReasonable(inliers: [Match]) -> Bool {
        var keypointCentroid = simd_float2(0,0)
        var keyPoints = [simd_float2]()
        
        for inlier in inliers {
            let keyPoint = simd_float2(inlier.new.keypoint.pt.x, inlier.new.keypoint.pt.y)
            keypointCentroid += keyPoint
            keyPoints.append(keyPoint)
        }
        keypointCentroid *= 1 / Float(inliers.count)
        
        var covarianceMatrix = simd_float2x2()
        for keyPoint in keyPoints {
            let residual = keyPoint - keypointCentroid
            covarianceMatrix += .init([residual.x * residual.x, residual.x * residual.y],
                                      [residual.y * residual.x, residual.y * residual.y])
        }
        covarianceMatrix *= 1 / Float(inliers.count)
        
        let covarianceDeterminant = covarianceMatrix.determinant
        let covarianceDeterminantIsReasonable = covarianceDeterminant >= Self.minInlierCovarianceDeterminant
        let standardDeviationSquareLength = pow(covarianceDeterminant, 0.25)
        if #available(iOS 14, *) {
            logger.debug("""
            covarianceDeterminantIsReasonable: \(covarianceDeterminantIsReasonable)
            covarianceDeterminant: \(covarianceDeterminant)
            standardDeviationSquareLength: \(standardDeviationSquareLength)
            covarianceMatrix: \(Matrix(covarianceMatrix))
            """)
        }
        if !covarianceDeterminantIsReasonable {
            tracker?.externalTracker?.debugString = "Covariance determinant is not reasonable: \(covarianceDeterminant), d^0.25: \(standardDeviationSquareLength)"
        }
        return covarianceDeterminantIsReasonable
    }
    
    private func _verifyIsNotAnAnomaly(
        relativeTransform: simd_float4x4,
        centroid: simd_float4,
        centroidDisplacement: simd_float4,
        camera: ARCamera
    ) -> Bool {
        let cameraDisplacement = relativeTransform * camera.transform[3] - camera.transform[3]
        let cameraDisplacementTolerance = min(simd_distance(camera.transform[3], centroid) * 0.3, 1.5)
        
        // Check if we are re-localizing
        var isRelocalizing = false
        if case .relocalizing = tracker?.state {
            isRelocalizing = true
        }
        
        // Check if relativeTransform is similar to last anomaly
        var isSimilarToLastAnomaly = false
        if let lastAnomaly = _lastAnomalyRelativeTransform {
            let lastAnomalyCameraDisplacement = lastAnomaly * camera.transform[3] - camera.transform[3]
            let displacementDistance = simd_distance(lastAnomalyCameraDisplacement, cameraDisplacement)
            isSimilarToLastAnomaly = displacementDistance <= min(cameraDisplacementTolerance, 0.5)
        }
        
        
        let isTooFarFromCurrentPosition = simd_length(cameraDisplacement) > cameraDisplacementTolerance
        let isAnAnomaly = isTooFarFromCurrentPosition && !isRelocalizing && !isSimilarToLastAnomaly
        
        if #available(iOS 14, *) {
            logger.debug("""
            isNotAnAnomaly \(!isAnAnomaly)
            isTooFarFromCurrentPosition: \(isTooFarFromCurrentPosition)
            isRelocalizing: \(isRelocalizing)
            isSimilarToLastAnomaly: \(isSimilarToLastAnomaly)
            """)
        }
        
        _lastAnomalyRelativeTransform = isAnAnomaly ? relativeTransform : nil
        
        if isAnAnomaly {
            tracker?.externalTracker?.debugString = "Is anomaly. Camera displacement: \(cameraDisplacement.debugDescription)"
        }
        return !isAnAnomaly
    }
    
    
    // MARK: Straighten
    
    /// ARKit does a a really good job of keeping track of which way is up through sensor data and we want to avoid adjusting their y-axis predictions while keeping other realignment. We want to adjust our relative transform so that it is equivilant to the original relative transform, plus a rotation around the center of the inlier feature points that keeps the y-axis pointing upward.
    /// - Parameters:
    ///   - relativeTransform: The relative transform that moves the world and its objects to match the estimated camera pose.
    ///   - centroid: The center of all the inlier feature points
    /// - Returns: An adjusted `relativeTransform` that preserves the y-axis direction.
    func straighten(relativeTransform: simd_float4x4, centroidDisplacement: simd_float4) -> simd_float4x4 {
        // Straighten y-axis
        var relativeTransform = relativeTransform
        // First we pass our centroid through the original `relativeTransform`.
        // Then we subtract the original `centroid` from it. Now the y-component tells us the total
        // y-axis displacement of the centroid, and we will use that as the overall y-translation in
        // the final `relativeTransform` matrix.
        relativeTransform[3,1] = centroidDisplacement.y
        // We get the y-axis to point straight up by simply setting it to the identity matrix y-column.
        relativeTransform[1] = matrix_identity_float4x4[1]
        // We make the x-z plane level by removing the y component.
        // We're able to assume the plane in't upside down or anything because of the
        // checks we do in `_verifyEstimate`.
        relativeTransform[0,1] = 0
        relativeTransform[2,1] = 0
        // Now we just want to make sure the x and z axes are unit length
        relativeTransform[0] = simd_normalize(relativeTransform[0])
        relativeTransform[2] = simd_normalize(relativeTransform[2])
        return relativeTransform
    }
}
