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
        self.tracker = LARTracker(map: map, imageSize: imageSize)
        self.threadId = threadId
    }

    /// Localize a single frame
    func localize(frameData: FrameData) -> (success: Bool, transform: [[Double]]?) {
        // Extract query position from frame extrinsics
        let extrinsics = frameData.frame.extrinsics
        let queryX = extrinsics[0][3]
        let queryZ = extrinsics[2][3]
        let searchDiameter = 20.0  // 20 meter search radius (same as C++ version)

        // Call LARTracker.localize()
        let result = tracker.localize(
            frameData.image,
            frame: frameData.frame,
            queryX: queryX,
            queryZ: queryZ,
            queryDiameter: searchDiameter
        )

        return (result.success, result.transform)
    }
}
