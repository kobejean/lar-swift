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
    
    func localize(frame: ARFrame) -> simd_double4x4? {
        let buffer = frame.capturedImage
        // Lock/unlock base address
        CVPixelBufferLockBaseAddress(buffer, [.readOnly])
        defer { CVPixelBufferUnlockBaseAddress(buffer, [.readOnly]) }
        
        guard let image = Mat(buffer: buffer, 0) else { return nil }
        let intrinsics = frame.camera.intrinsics.toMat()
        let transform = frame.camera.transform.toDouble().toMat()
        let success = self.localize(image, intrinsics: intrinsics, transform: transform)
        return success ? transform.toSIMD() : nil
    }
    
}

#endif
