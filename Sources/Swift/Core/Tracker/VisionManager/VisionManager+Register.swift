//
//  VisionManager+Register.swift
//  
//
//  Created by Jean Flaherty on 6/14/21.
//

import Foundation
import ARKit
import LANumerics
import opencv2

extension VisionManager {
    
    
    // MARK: Register Camera Pose
    
    func register(matches: [Match], frame: ARFrame) {
        // TODO: Check x,y variances to make sure matches are spread apart enough to solve PnP
        if #available(iOS 14, *) {
            logger.debug("""
            hasEnoughMatches: \(matches.count >= Self.minMatchesForRegistration)
            matchCount: \(matches.count)
            """)
        }
        guard matches.count >= Self.minMatchesForRegistration else {
            tracker?.externalTracker?.debugString = "Not enough matches: \(matches.count)"
            return
        }
        
        // Setup Parameters
        let objectPoints = _objectPoints(matches: matches)
        let imagePoints = _imagePoints(matches: matches)
        let cameraMatrix = _cameraMatrix(camera: frame.camera)
        // No distortion since ARKit images are already rectified
        let distCoeffs = Mat()
        // Start with our current camera rotaion and translation.
        let rvec = _rvec(frame: frame)
        let tvec = _tvec(frame: frame)
        let inlierMat = Mat()
        let usacParams = UsacParams()
//        usacParams.confidence = 0.9
        usacParams.threshold = 5 // 1.5
        
        // Solve Perspective-n-Point
        guard Calib3d.solvePnPRansac(
            objectPoints: objectPoints,
            imagePoints: imagePoints,
            cameraMatrix: cameraMatrix,
            distCoeffs: distCoeffs,
            rvec: rvec,
            tvec: tvec,
            inliers: inlierMat,
            params: usacParams
        ) else { return }
        
        let relativeTransform = _relativeTransform(camera: frame.camera, rvec: rvec, tvec: tvec)
        let inliers = _inliers(matches: matches, inlierMat: inlierMat)
        
        guard let straightenedTransform = verifyAlignmentAndStraighten(
                frame: frame,
                matches: matches,
                inliers: inliers,
                relativeTransform: relativeTransform)
        else { return }
        
        syncWithSession { [weak self] in
            guard let self = self, let tracker = self.tracker else { return }
            
            if case .relocalizing = tracker.state {
                self.relocalize(relativeTransform: straightenedTransform)
            } else {
                tracker.session?.alignWorld(relativeTransform: straightenedTransform)
            }
            
            // TODO: Clean this up
            let featurePoints = tracker.map.pointCloud.featurePoints
            let inlierFeaturePoints = inliers.map({ $0.old.featurePoint! })
            let mapSpaceFeaturePoints = Array(featurePoints.intersection(inlierFeaturePoints))
            tracker.delegate?.visionManager(self, didRegister: mapSpaceFeaturePoints)
        }
    }
    
    
    // MARK: Construct Parameters
    
    private func _objectPoints(matches: [Match]) -> Mat {
        let rows = Int32(matches.count)
        let flattened = matches.reduce(into: [Float]()) { array, match in
            let objectPoint = match.old.featurePoint!.transform.columns.3
            array.append(objectPoint.x)
            array.append(objectPoint.y)
            array.append(objectPoint.z)
        }
        return Mat(rows: rows, cols: 3, data: flattened)
    }
    
    private func _imagePoints(matches: [Match]) -> Mat {
        let rows = Int32(matches.count)
        let flattened = matches.reduce(into: [Float]()) { array, match in
            let imagePoint = match.new.keypoint.pt
            array.append(imagePoint.x)
            array.append(imagePoint.y)
        }
        return Mat(rows: rows, cols: 2, data: flattened)
    }
    
    private func _cameraMatrix(camera: ARCamera) -> Mat {
        let intrinsics = camera.intrinsics
        let flattened = [
            intrinsics[0,0], intrinsics[1,0], intrinsics[2,0],
            intrinsics[0,1], intrinsics[1,1], intrinsics[2,1],
            intrinsics[0,2], intrinsics[1,2], intrinsics[2,2]
        ]
        return Mat(rows: 3, cols: 3, data: flattened)
    }
    
    private func _rvec(frame: ARFrame) -> Mat {
        var transform = frame.camera.transform
        
        // if localizing use location data
        if case .relocalizing = tracker?.state {
            if let result = tracker?.locationManager.estimatedVirtualLocation(frame: frame) {
                // TODO: Use CoreLocation heading or rotation matrix from accumulated location points
                transform[3,0] = result.point.x
                transform[3,2] = result.point.y
            } else {
                // Return empty `Mat` when localizing and no virtualLocation estimate
                return Mat()
            }
        }
        
        // OpenCV camera transform is the inverse of ARKit (transpose works because it's orthogonal)
        // Also y,z-axis needs to be flipped hence the negative signs
        let rotationMatrix = Mat(rows: 3, cols: 3, data: [
            transform[0,0], transform[0,1], transform[0,2],
            -transform[1,0], -transform[1,1], -transform[1,2],
            -transform[2,0], -transform[2,1], -transform[2,2]
        ])
        let rvec = Mat(rows: 3, cols: 1, type: CvType.CV_64FC1)
        Calib3d.Rodrigues(src: rotationMatrix, dst: rvec)
        return rvec
    }
    
    private func _tvec(frame: ARFrame) -> Mat {
        // TODO: Find a way to perform matrix multiplication with `Mat` objects
        // so that we don't need to create rotation matrix twice.
        
        var transform = frame.camera.transform
        
        // If re-localizing use location data
        if case .relocalizing = tracker?.state {
            // TODO: Clean up
            if let result = tracker?.locationManager.estimatedVirtualLocation(frame: frame) {
                transform[3,0] = result.point.x
                transform[3,2] = result.point.y
            } else {
                // Return empty `Mat` when localizing and no virtualLocation estimate
                return Mat()
            }
        }
        
        // To switch to OpenCV coordinates, the camera transform is inverse of ARKit
        // so calculate inverse translation using: `-R'*t`
        // Also y,z-axis needs to be flipped hence the negative signs
        let rotationMatrix = simd_float3x3(
            simd_make_float3(transform[0]),
            -simd_make_float3(transform[1]),
            -simd_make_float3(transform[2])
        ).transpose
        let translation = -rotationMatrix * simd_make_float3(transform[3])
        return Mat(rows: 3, cols: 1, data: [translation.x, translation.y, translation.z])
    }
    
    
    // MARK: Convert Outputs
    
    func _inliers(matches: [Match], inlierMat: Mat) -> [Match] {
        let indices = inlierMat.flatArray() as [UInt32]
        var inliers = [Match]()
        
        for index in indices {
            inliers.append(matches[Int(index)])
        }
        
        return inliers
    }
    
    
    func _relativeTransform(camera: ARCamera, rvec: Mat, tvec: Mat) -> simd_float4x4 {
        // Get the OpenCV rotaion matrix
        let rmat = Mat()
        Calib3d.Rodrigues(src: rvec, dst: rmat)
        
        // Convert to swift types.
        // The `as [Double]` is needed because data in pointer is double and type inference does not work here.
        // Then we can convert to `Float`.
        let tvecArray = (tvec.flatArray() as [Double]).map(Float.init)
        let rmatArray = (rmat.flatArray() as [Double]).map(Float.init)
        
        
        // The rotation and translation we recieve is already the inverse of ARKit `camera.transform`
        // also rows for y and z-azis needs to be flipped to convert from OpenCV to ARKit coordinate system
        let inverseNewTransform = simd_float4x4(
            simd_float4(rmatArray[0], -rmatArray[3], -rmatArray[6], 0),
            simd_float4(rmatArray[1], -rmatArray[4], -rmatArray[7], 0),
            simd_float4(rmatArray[2], -rmatArray[5], -rmatArray[8], 0),
            simd_float4(tvecArray[0], -tvecArray[1], -tvecArray[2], 1)
        )

        // We will move the world alignment instead of moving the camera since there is no such api interface
        // for updating camera position, the net effect will be the same.
        // To do this we need a relative transform that would take the new camera pose and move it to the old pose
        // since the world will move (realtive to the camera) opposite from the camera's motion.
        return camera.transform * inverseNewTransform
    }
}
