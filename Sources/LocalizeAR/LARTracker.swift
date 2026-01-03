//
//  LARTracker.swift
//
//
//  Created by Jean Flaherty on 2022/01/21.
//

#if os(iOS)

import ARKit
import opencv2

public extension LARTracker {

    func localize(frame: ARFrame, gvec: simd_double3? = nil, queryX: Double, queryZ: Double, queryDiameter: Double) -> simd_double4x4? {
        let buffer = frame.capturedImage
        // Lock/unlock base address
        CVPixelBufferLockBaseAddress(buffer, [.readOnly])
        defer { CVPixelBufferUnlockBaseAddress(buffer, [.readOnly]) }

        guard let image = Mat(buffer: buffer, 0) else { return nil }

        // Create a LARFrame with the intrinsics and a dummy transform
        let intrinsics = frame.camera.intrinsics
        let extrinsics = frame.camera.transform
        let larFrame = LARFrame(id: 0, timestamp: Int(frame.timestamp * 1000),
                               intrinsics: intrinsics,
                               extrinsics: extrinsics)

        // Output transform - create properly typed matrix for doubles
        let outputTransform = Mat(rows: 4, cols: 4, type: CvType.CV_64F)
        let success = self.localize(withImage: image, frame: larFrame,
                                   queryX: queryX, queryZ: queryZ, queryDiameter: queryDiameter,
                                   outputTransform: outputTransform)

        return success ? outputTransform.toSIMD() : nil
    }

}

#endif

#if os(macOS)

import CoreGraphics
import opencv2

/// Convert CGImage to OpenCV Mat (grayscale)
/// - Parameter cgImage: Input CGImage (will be converted to grayscale)
/// - Returns: Mat instance or nil if conversion fails
private func createMat(from cgImage: CGImage) -> Mat? {
    let width = cgImage.width
    let height = cgImage.height

    // Create grayscale color space
    let colorSpace = CGColorSpaceCreateDeviceGray()
    let bytesPerRow = width
    var pixelData = [UInt8](repeating: 0, count: width * height)

    // Create CGContext to render image as grayscale
    guard let context = CGContext(
        data: &pixelData,
        width: width,
        height: height,
        bitsPerComponent: 8,
        bytesPerRow: bytesPerRow,
        space: colorSpace,
        bitmapInfo: CGImageAlphaInfo.none.rawValue
    ) else {
        return nil
    }

    // Draw CGImage into grayscale context
    context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

    // Create Mat from pixel data (CV_8U = 8-bit unsigned grayscale)
    let mat = Mat(rows: Int32(height), cols: Int32(width), type: CvType.CV_8U)

    // Copy pixel data into Mat
    do {
        try mat.put(row: 0, col: 0, data: pixelData)
        return mat
    } catch {
        return nil
    }
}

public extension LARTracker {

    /// Convenience initializer with CGSize
    convenience init(map: LARMap, imageSize: CGSize) {
        self.init(
            map: map,
            imageWidth: Int32(imageSize.width),
            imageHeight: Int32(imageSize.height)
        )
    }

    /// Localize using CGImage with spatial query
    /// - Parameters:
    ///   - image: Input image as CGImage
    ///   - frame: LARFrame with camera intrinsics/extrinsics
    ///   - queryX: Spatial query X coordinate (meters)
    ///   - queryZ: Spatial query Z coordinate (meters)
    ///   - queryDiameter: Search diameter (meters)
    /// - Returns: Tuple of (success, transform matrix as 4x4 array)
    func localize(
        _ image: CGImage,
        frame: LARFrame,
        queryX: Double,
        queryZ: Double,
        queryDiameter: Double
    ) -> (success: Bool, transform: [[Double]]?) {
        // Convert CGImage to Mat (grayscale)
        guard let mat = createMat(from: image) else {
            return (false, nil)
        }

        // Create output transform matrix (4x4 double matrix)
        let outputTransform = Mat(rows: 4, cols: 4, type: CvType.CV_64F)

        // Call ObjC bridge localize method
        let success = self.localize(
            withImage: mat,
            frame: frame,
            queryX: queryX,
            queryZ: queryZ,
            queryDiameter: queryDiameter,
            outputTransform: outputTransform
        )

        // Convert Mat to [[Double]] if successful
        if success {
            var transform: [[Double]] = []
            for i in 0..<4 {
                var row: [Double] = []
                for j in 0..<4 {
                    let value = outputTransform.get(row: Int32(i), col: Int32(j))
                    row.append(value[0])
                }
                transform.append(row)
            }
            return (true, transform)
        }

        return (false, nil)
    }
}

#endif
