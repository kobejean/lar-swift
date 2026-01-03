//
//  LocalizationWorker.swift
//  LARBenchmark
//
//  Per-thread worker that wraps LARTracker for localization
//

import Foundation
import CoreGraphics
import LocalizeAR

/// Per-thread worker for localization
/// Each thread creates its own instance to avoid LARTracker thread-safety issues
class LocalizationWorker {
    private let tracker: LARTracker
    private let threadId: Int

    init(map: LARMap, imageSize: CGSize, threadId: Int = 0) {
        // Use convenience initializer from Swift extension
        self.tracker = LARTracker(map: map, imageSize: imageSize)
        self.threadId = threadId
    }

    /// Localize a single frame
    func localize(frameData: FrameData) -> (success: Bool, transform: [[Double]]?) {
        // Extract query position from frame extrinsics
        let extrinsics = frameData.frame.extrinsics
        let queryX = Double(extrinsics[0][3])  // Convert Float to Double
        let queryZ = Double(extrinsics[2][3])  // Convert Float to Double
        let searchDiameter = 20.0  // 20 meter search radius (same as C++ version)

        // Call LARTracker.localize() using macOS Swift extension
        let result = tracker.localize(
            frameData.image,        // CGImage
            frame: frameData.frame, // LARFrame
            queryX: queryX,         // Double
            queryZ: queryZ,         // Double
            queryDiameter: searchDiameter  // Double
        )

        return result  // Returns (success: Bool, transform: [[Double]]?)
    }
}
