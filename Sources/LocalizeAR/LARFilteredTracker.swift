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

    private static func failureResult() -> LARFilteredTrackerResult {
        LARFilteredTrackerResult(success: false, transform: simd_float4x4(1.0), confidence: 0.0,
                                 matchedLandmarkCount: 0, inlierCount: 0, inlierLandmarkIds: nil)
    }

    /// Measurement update from a captured image + frame (see `LARImageFrame`).
    ///
    /// Capture the `LARImageFrame` synchronously on the ARKit delegate thread (it copies the
    /// luma + pose, releasing the `ARFrame`), then call this from the background task.
    func measurementUpdate(_ imageFrame: LARImageFrame, query: LARSpatialQuery) -> LARFilteredTrackerResult {
        imageFrame.withImage { image in
            measurementUpdate(image: image, frame: imageFrame.frame, query: query)
        }
    }

    /// Measurement update directly from a VIO frame and a spatial query.
    /// - Note: Reads + processes the frame synchronously. For async use, capture a
    ///   `LARImageFrame` first and call `measurementUpdate(_:query:)` so the `ARFrame` isn't
    ///   pinned across the `await`.
    func measurementUpdate(frame: ARFrame, query: LARSpatialQuery) -> LARFilteredTrackerResult {
        guard let imageFrame = LARImageFrame(arFrame: frame) else { return Self.failureResult() }
        return measurementUpdate(imageFrame, query: query)
    }

    /// Simplified measurement update using a GPS coordinate as the query center.
    /// - Parameters:
    ///   - frame: VIO frame containing image and camera data (ARKit: ARFrame)
    ///   - gpsCoordinate: GPS coordinate (x, z) for spatial query
    ///   - queryRadius: Search radius around GPS coordinate (default: 50m)
    func measurementUpdate(frame: ARFrame, gpsCoordinate: simd_double2, queryRadius: Double = 50.0) -> LARFilteredTrackerResult {
        return measurementUpdate(frame: frame,
                                 query: LARSpatialQuery(x: gpsCoordinate.x, z: gpsCoordinate.y,
                                                        diameter: queryRadius * 2.0))
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
        return (currentTime - lastMeasurementTime) >= measurementInterval
    }
}

#endif
#endif