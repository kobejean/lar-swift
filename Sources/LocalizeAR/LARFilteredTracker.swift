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

/// A self-contained, value-copied snapshot of an `ARFrame`'s grayscale (luma) image plus
/// its camera parameters.
///
/// ARKit hands out frames from a small fixed pool (~16). If an `ARFrame` is captured into an
/// async task and held across an `await` (e.g. while waiting on a busy actor or running CV),
/// ARKit can't recycle it and starts dropping camera frames
/// ("ARSessionDelegate is retaining N ARFrames"). Capturing this snapshot on the delegate/main
/// thread and passing *it* into the async work lets the `ARFrame` return to the pool immediately.
public struct LARGrayscaleFrameSnapshot {
    /// Copied luma plane (one byte per pixel, `bytesPerRow`-strided).
    public let pixels: Data
    public let width: Int32
    public let height: Int32
    public let bytesPerRow: Int32
    /// Camera intrinsics/extrinsics + timestamp, as a LARFrame.
    public let frame: LARFrame

    /// Copies the full-resolution luma plane out of an `ARFrame` so the frame can be released.
    /// Returns `nil` if the buffer's base address is unavailable.
    public init?(frame arFrame: ARFrame) {
        let buffer = arFrame.capturedImage
        CVPixelBufferLockBaseAddress(buffer, [.readOnly])
        defer { CVPixelBufferUnlockBaseAddress(buffer, [.readOnly]) }

        // Plane 0 of the YCbCr buffer is the full-resolution luma (grayscale).
        guard let base = CVPixelBufferGetBaseAddressOfPlane(buffer, 0) else { return nil }
        let height = CVPixelBufferGetHeightOfPlane(buffer, 0)
        let bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(buffer, 0)

        self.pixels = Data(bytes: base, count: bytesPerRow * height)
        self.width = Int32(CVPixelBufferGetWidthOfPlane(buffer, 0))
        self.height = Int32(height)
        self.bytesPerRow = Int32(bytesPerRow)
        self.frame = LARFrame(id: 0, timestamp: Int(arFrame.timestamp * 1000),
                              intrinsics: arFrame.camera.intrinsics,
                              extrinsics: arFrame.camera.transform)
    }
}

/// Swift extensions for LARFilteredTracker
public extension LARFilteredTracker {

    // Note: convenience init(map:) already provided by Objective-C implementation

    private static func failureResult() -> LARFilteredTrackerResult {
        LARFilteredTrackerResult(success: false, transform: simd_float4x4(1.0), confidence: 0.0,
                                 matchedLandmarkCount: 0, inlierCount: 0, inlierLandmarkIds: nil)
    }

    /// Measurement update from a pre-copied grayscale snapshot (see `LARGrayscaleFrameSnapshot`).
    ///
    /// Prefer this over `measurementUpdate(frame:)` for asynchronous work: capture the snapshot
    /// synchronously on the ARKit delegate thread so the `ARFrame` is released, then call this
    /// from the background task.
    func measurementUpdate(snapshot: LARGrayscaleFrameSnapshot, query: LARSpatialQuery) -> LARFilteredTrackerResult {
        return snapshot.pixels.withUnsafeBytes { raw -> LARFilteredTrackerResult in
            guard let base = raw.baseAddress else { return Self.failureResult() }
            let image = LARImageInput(data: base, width: snapshot.width,
                                      height: snapshot.height, bytesPerRow: snapshot.bytesPerRow)
            return measurementUpdate(image: image, frame: snapshot.frame, query: query)
        }
    }

    /// Measurement update using a VIO frame and a spatial query.
    /// - Note: Reads + processes the frame synchronously. For async use, capture a
    ///   `LARGrayscaleFrameSnapshot` first and call `measurementUpdate(snapshot:query:)` so the
    ///   `ARFrame` isn't pinned across the `await`.
    func measurementUpdate(frame: ARFrame, query: LARSpatialQuery) -> LARFilteredTrackerResult {
        guard let snapshot = LARGrayscaleFrameSnapshot(frame: frame) else { return Self.failureResult() }
        return measurementUpdate(snapshot: snapshot, query: query)
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