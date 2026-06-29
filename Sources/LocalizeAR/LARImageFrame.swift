//
//  LARImageFrame.swift
//  LocalizeAR
//
//  An owned capture: a grayscale image paired with the camera pose it was taken at.
//

import Foundation

#if canImport(ARKit)
import ARKit
#endif

/// An owned grayscale image together with the camera frame (pose + intrinsics) it was captured
/// with — the input to a localization / measurement update.
///
/// This is the *owning* counterpart to `LARImage` (which is just a non-owning view at the C++
/// interop boundary). Capturing an `LARImageFrame` copies the pixels, so the source — e.g. an
/// `ARFrame` — can be released immediately. That's what avoids ARKit's
/// "ARSessionDelegate is retaining N ARFrames" stall when localization runs asynchronously.
///
/// `LARFrame` is kept image-less (it mirrors the serializable `lar::Frame` metadata and is even
/// loaded from JSON without pixels); this composition pairs the two only where both exist.
public struct LARImageFrame {
    /// Camera pose + intrinsics + timestamp captured with the image.
    public let frame: LARFrame
    /// Owned copy of the grayscale (luma) pixels.
    private let pixels: Data
    /// Image dimensions, held as a `LARImage`. Its `data` is nil at rest and filled in per call
    /// by `withImage`, which is the only thing that can produce a valid pointer into `pixels`.
    private let layout: LARImage

    /// Pair an existing frame with an owned grayscale buffer (e.g. offline: a frame loaded from
    /// JSON plus an image decoded from disk).
    public init(frame: LARFrame, pixels: Data, width: Int32, height: Int32, bytesPerRow: Int32) {
        self.frame = frame
        self.pixels = pixels
        self.layout = LARImage(data: nil, width: width, height: height, bytesPerRow: bytesPerRow)
    }

    /// Run `body` with a `LARImage` view into the owned pixels. The view (its `data` pointer) is
    /// valid only for the duration of the call.
    func withImage<R>(_ body: (LARImage) throws -> R) rethrows -> R {
        precondition(!pixels.isEmpty, "LARImageFrame has no pixel data")
        return try pixels.withUnsafeBytes { raw in
            var image = layout
            image.data = raw.baseAddress  // non-nil: pixels is non-empty
            return try body(image)
        }
    }
}

#if canImport(ARKit)
public extension LARImageFrame {
    /// Copy the full-resolution luma (grayscale) plane out of an `ARFrame` into an owned buffer,
    /// so the `ARFrame` can return to ARKit's pool immediately. Returns nil if the buffer's base
    /// address is unavailable.
    init?(arFrame: ARFrame) {
        let buffer = arFrame.capturedImage
        CVPixelBufferLockBaseAddress(buffer, [.readOnly])
        defer { CVPixelBufferUnlockBaseAddress(buffer, [.readOnly]) }

        // Plane 0 of the YCbCr buffer is the full-resolution luma (grayscale).
        guard let base = CVPixelBufferGetBaseAddressOfPlane(buffer, 0) else { return nil }
        let height = CVPixelBufferGetHeightOfPlane(buffer, 0)
        let bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(buffer, 0)

        self.init(frame: LARFrame(id: 0, timestamp: Int(arFrame.timestamp * 1000),
                                  intrinsics: arFrame.camera.intrinsics,
                                  extrinsics: arFrame.camera.transform),
                  pixels: Data(bytes: base, count: bytesPerRow * height),
                  width: Int32(CVPixelBufferGetWidthOfPlane(buffer, 0)),
                  height: Int32(height),
                  bytesPerRow: Int32(bytesPerRow))
    }
}
#endif
