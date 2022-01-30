//
//  LARTracker.swift
//  
//
//  Created by Jean Flaherty on 2022/01/21.
//

#if os(iOS)

import ARKit
import LocalizeARObjC

public extension LARTracker {
    
    func localize(frame: ARFrame) -> simd_double4x4? {
        let buffer = frame.capturedImage
        // Lock/unlock base address
        CVPixelBufferLockBaseAddress(buffer, [.readOnly])
        defer { CVPixelBufferUnlockBaseAddress(buffer, [.readOnly]) }
        
        guard let image = Mat(buffer: buffer, 0) else { return nil }
        let intrinsics = frame.camera.intrinsics.toMat()
        let transform = frame.camera.transform.toDouble().toMat()
        self.localize(image, intrinsics: intrinsics, transform: transform)
        
        return transform.toSIMD()
    }
    
}

#endif
