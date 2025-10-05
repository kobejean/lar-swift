//
//  LARFilteredTracker.swift
//  LocalizeAR
//
//  Created by Jean Flaherty on 2025-09-22.
//

// Enable filtered tracker Swift extensions
#if true

#if os(iOS)

import ARKit
import opencv2

/// Result of a filtered tracker measurement update
public extension LARFilteredTrackerResult {
    /// IDs of inlier landmarks as Swift array of integers
    var inlierIds: [Int]? {
        return self.inlierLandmarkIds?.map { $0.intValue }
    }
}

/// Swift extensions for LARFilteredTracker
public extension LARFilteredTracker {

    // Note: convenience init(map:) already provided by Objective-C implementation

    /// Measurement update using VIO frame with GPS coordinates
    /// - Parameters:
    ///   - frame: VIO frame containing image and camera data (ARKit: ARFrame)
    ///   - queryX: GPS query center X coordinate
    ///   - queryZ: GPS query center Z coordinate
    ///   - queryDiameter: GPS query radius in meters
    /// - Returns: Measurement result with success status and transform
    func measurementUpdate(frame: ARFrame, queryX: Double, queryZ: Double, queryDiameter: Double) -> LARFilteredTrackerResult {
        let buffer = frame.capturedImage
        // Lock/unlock base address
        CVPixelBufferLockBaseAddress(buffer, [.readOnly])
        defer { CVPixelBufferUnlockBaseAddress(buffer, [.readOnly]) }

        guard let image = Mat(buffer: buffer, 0) else {
            return LARFilteredTrackerResult(
                success: false,
                transform: simd_float4x4(1.0),
                confidence: 0.0,
                matchedLandmarkCount: 0,
                inlierCount: 0,
                inlierLandmarkIds: nil
            )
        }

        // Create a LARFrame with the intrinsics and transform
        let intrinsics = frame.camera.intrinsics
        let extrinsics = frame.camera.transform
        let larFrame = LARFrame(id: 0, timestamp: Int(frame.timestamp * 1000),
                               intrinsics: intrinsics,
                               extrinsics: extrinsics)

        return measurementUpdate(withImage: image,
                               frame: larFrame,
                               queryX: queryX,
                               queryZ: queryZ,
                               queryDiameter: queryDiameter)
    }

    /// Simplified measurement update using GPS coordinates
    /// - Parameters:
    ///   - frame: VIO frame containing image and camera data (ARKit: ARFrame)
    ///   - gpsCoordinate: GPS coordinate (x, z) for spatial query
    ///   - queryRadius: Search radius around GPS coordinate (default: 50m)
    /// - Returns: Measurement result
    func measurementUpdate(frame: ARFrame, gpsCoordinate: simd_double2, queryRadius: Double = 50.0) -> LARFilteredTrackerResult {
        return measurementUpdate(frame: frame,
                               queryX: gpsCoordinate.x,
                               queryZ: gpsCoordinate.y,
                               queryDiameter: queryRadius * 2.0)
    }

    /// Apply filtered transform to a VIO pose to get map-aligned pose
    /// - Parameter vioPose: Pose in VIO world coordinates (ARKit, ARCore, etc.)
    /// - Returns: Pose in LAR map coordinates
    func transformPose(_ vioPose: simd_float4x4) -> simd_float4x4 {
        return getFilteredTransform() * vioPose
    }

    /// Check if it's time for a measurement update based on interval
    /// - Parameter lastMeasurementTime: Time of last measurement
    /// - Returns: Whether a measurement update should be performed
    func shouldPerformMeasurementUpdate(lastMeasurementTime: TimeInterval) -> Bool {
        let currentTime = CACurrentMediaTime()
        return (currentTime - lastMeasurementTime) >= 2.0 // Default 2s interval
    }
}

#endif
#endif