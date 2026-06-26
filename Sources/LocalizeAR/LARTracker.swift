//
//  LARTracker.swift
//
//
//  Created by Jean Flaherty on 2022/01/21.
//

import simd

#if os(iOS)

import ARKit

public extension LARTracker {

    func localize(frame: ARFrame, gvec: simd_double3? = nil, queryX: Double, queryZ: Double, queryDiameter: Double) -> simd_double4x4? {
        let buffer = frame.capturedImage
        CVPixelBufferLockBaseAddress(buffer, [.readOnly])
        defer { CVPixelBufferUnlockBaseAddress(buffer, [.readOnly]) }

        // Plane 0 of the YCbCr buffer is the full-resolution luma (grayscale).
        guard let base = CVPixelBufferGetBaseAddressOfPlane(buffer, 0) else { return nil }
        let width = CVPixelBufferGetWidthOfPlane(buffer, 0)
        let height = CVPixelBufferGetHeightOfPlane(buffer, 0)
        let bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(buffer, 0)

        let larFrame = LARFrame(id: 0, timestamp: Int(frame.timestamp * 1000),
                               intrinsics: frame.camera.intrinsics,
                               extrinsics: frame.camera.transform)

        var transform = matrix_identity_double4x4
        let success = self.localize(withGrayscaleData: base,
                                    width: Int32(width), height: Int32(height),
                                    bytesPerRow: Int32(bytesPerRow),
                                    frame: larFrame,
                                    queryX: queryX, queryZ: queryZ, queryDiameter: queryDiameter,
                                    outputTransform: &transform)
        return success ? transform : nil
    }

}

#endif

#if os(macOS)

import CoreGraphics

public extension LARTracker {

    /// Convenience initializer with CGSize
    convenience init(map: LARMap, imageSize: CGSize) {
        self.init(
            map: map,
            imageWidth: Int32(imageSize.width),
            imageHeight: Int32(imageSize.height)
        )
    }

    /// Localize using CGImage with spatial query.
    func localize(
        _ image: CGImage,
        frame: LARFrame,
        queryX: Double,
        queryZ: Double,
        queryDiameter: Double
    ) -> (success: Bool, transform: [[Double]]?) {
        let width = image.width
        let height = image.height

        // Render to grayscale bytes (CoreGraphics only — no opencv).
        var pixelData = [UInt8](repeating: 0, count: width * height)
        guard let context = CGContext(
            data: &pixelData,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width,
            space: CGColorSpaceCreateDeviceGray(),
            bitmapInfo: CGImageAlphaInfo.none.rawValue
        ) else {
            return (false, nil)
        }
        context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))

        var transform = matrix_identity_double4x4
        let success = pixelData.withUnsafeBytes { raw -> Bool in
            self.localize(withGrayscaleData: raw.baseAddress!,
                          width: Int32(width), height: Int32(height),
                          bytesPerRow: Int32(width),
                          frame: frame,
                          queryX: queryX, queryZ: queryZ, queryDiameter: queryDiameter,
                          outputTransform: &transform)
        }
        guard success else { return (false, nil) }

        // [[Double]] is row-major; simd is column-major (transform[col][row]).
        var rows: [[Double]] = []
        for i in 0..<4 {
            rows.append([transform[0][i], transform[1][i], transform[2][i], transform[3][i]])
        }
        return (true, rows)
    }
}

#endif
