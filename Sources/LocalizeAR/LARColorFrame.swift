//
//  LARColorFrame.swift
//  LocalizeAR
//
//  An owned color capture: a full-color image paired with the camera pose it was taken at.
//

import Foundation

#if os(iOS)
import ARKit

/// An owned full-color image together with the camera frame (pose + intrinsics + timestamp) it was
/// captured with — the input to a mapping `addFrame`.
///
/// The color counterpart to `LARImageFrame`. Both copy the source pixels so an `ARFrame` returns to
/// ARKit's pool immediately (avoiding the "ARSessionDelegate is retaining N ARFrames" stall when
/// work runs asynchronously). They differ in payload: `LARImageFrame` keeps only the grayscale luma
/// plane (localization uses `CV_8UC1`), while mapping needs color for COLMAP reconstruction, so this
/// keeps the whole biplanar YCbCr buffer (combined into BGR downstream by the mapper).
public struct LARColorFrame {
    /// Camera pose + intrinsics + timestamp captured with the image.
    public let frame: LARFrame
    /// Owned deep copy of the full (color, biplanar YCbCr) pixel buffer.
    public let pixelBuffer: CVPixelBuffer

    /// Pair a frame with an already-owned pixel buffer.
    public init(frame: LARFrame, pixelBuffer: CVPixelBuffer) {
        self.frame = frame
        self.pixelBuffer = pixelBuffer
    }

    /// Deep-copy an `ARFrame`'s captured image into an owned buffer so the `ARFrame` can return to
    /// ARKit's pool immediately.
    ///
    /// - Parameter transform: the (map-local) camera pose to record as the frame's extrinsics. The
    ///   caller supplies it because the VIO→map conversion needs the scene graph, and it differs
    ///   from localization, which uses the raw VIO `camera.transform`.
    /// - Returns: nil if the pixel buffer can't be copied.
    public init?(arFrame: ARFrame, transform: simd_float4x4) {
        guard let pixelBuffer = arFrame.capturedImage.larDeepCopy() else { return nil }
        self.init(frame: LARFrame(id: 0, timestamp: Int(arFrame.timestamp * 1000),
                                  intrinsics: arFrame.camera.intrinsics,
                                  extrinsics: transform),
                  pixelBuffer: pixelBuffer)
    }
}
#endif
