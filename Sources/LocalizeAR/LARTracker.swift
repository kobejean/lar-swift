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
    
	func localize(frame: ARFrame, gvec: simd_double3? = nil, pose: simd_double4x4? = nil) -> simd_double4x4? {
        let buffer = frame.capturedImage
        // Lock/unlock base address
        CVPixelBufferLockBaseAddress(buffer, [.readOnly])
        defer { CVPixelBufferUnlockBaseAddress(buffer, [.readOnly]) }
        
        guard let image = Mat(buffer: buffer, 0) else { return nil }
        let intrinsics = frame.camera.intrinsics.toMat()
        let transform = (pose ?? frame.camera.transform.toDouble()).toMat()
		let gvec = gvec?.toMat() ?? Mat()
		let success = self.localize(image, intrinsics: intrinsics, transform: transform, gvec: gvec)
        return success ? transform.toSIMD() : nil
    }
    
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
