//
//  CVPixelBuffer.swift
//  LocalizeAR
//

import CoreVideo

public extension CVPixelBuffer {
    /// Returns an independent copy of the pixel buffer, so the source (e.g. an `ARFrame`'s
    /// `capturedImage`) can be released back to ARKit's pool while downstream code keeps working
    /// on the copy. Handles both planar (e.g. biplanar YCbCr) and packed formats.
    func larDeepCopy() -> CVPixelBuffer? {
        let width = CVPixelBufferGetWidth(self)
        let height = CVPixelBufferGetHeight(self)
        let format = CVPixelBufferGetPixelFormatType(self)
        let attrs: CFDictionary = [
            kCVPixelBufferIOSurfacePropertiesKey: [:] as CFDictionary
        ] as CFDictionary

        var maybeCopy: CVPixelBuffer?
        guard CVPixelBufferCreate(kCFAllocatorDefault, width, height, format, attrs, &maybeCopy) == kCVReturnSuccess,
              let copy = maybeCopy else { return nil }

        CVPixelBufferLockBaseAddress(self, .readOnly)
        CVPixelBufferLockBaseAddress(copy, [])
        defer {
            CVPixelBufferUnlockBaseAddress(copy, [])
            CVPixelBufferUnlockBaseAddress(self, .readOnly)
        }

        if CVPixelBufferIsPlanar(self) {
            for plane in 0..<CVPixelBufferGetPlaneCount(self) {
                guard let src = CVPixelBufferGetBaseAddressOfPlane(self, plane),
                      let dst = CVPixelBufferGetBaseAddressOfPlane(copy, plane) else { return nil }
                let srcBPR = CVPixelBufferGetBytesPerRowOfPlane(self, plane)
                let dstBPR = CVPixelBufferGetBytesPerRowOfPlane(copy, plane)
                let planeHeight = CVPixelBufferGetHeightOfPlane(self, plane)
                let rowBytes = min(srcBPR, dstBPR)
                for row in 0..<planeHeight {
                    memcpy(dst + row * dstBPR, src + row * srcBPR, rowBytes)
                }
            }
        } else {
            guard let src = CVPixelBufferGetBaseAddress(self),
                  let dst = CVPixelBufferGetBaseAddress(copy) else { return nil }
            let srcBPR = CVPixelBufferGetBytesPerRow(self)
            let dstBPR = CVPixelBufferGetBytesPerRow(copy)
            let rowBytes = min(srcBPR, dstBPR)
            for row in 0..<height {
                memcpy(dst + row * dstBPR, src + row * srcBPR, rowBytes)
            }
        }
        return copy
    }
}
