//
//  VisionManager+Detect.swift
//  
//
//  Created by Jean Flaherty on 6/14/21.
//

import Foundation
import ARKit
import LANumerics
import opencv2

extension VisionManager {
    
    
    // MARK: Detect Feature Points
    
    func detectFeaturePoints(buffer: CVPixelBuffer) throws -> UnzippedFeatures {
        
        // Lock/unlock base address
        CVPixelBufferLockBaseAddress(buffer, [.readOnly])
        defer { CVPixelBufferUnlockBaseAddress(buffer, [.readOnly]) }
        
        let formatType = CVPixelBufferGetPixelFormatType(buffer)
        let bufferHasExpectedFormatType = formatType == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
        
        guard bufferHasExpectedFormatType, let image = Mat(buffer: buffer, 0) else {
            throw VisionError.imageProcessingError
        }
        
        var featurePoints: UnzippedFeatures = ([], Mat())
        
        detector.detectAndCompute(
            image: image,
            mask: Mat(),
            keypoints: &featurePoints.keypoints,
            descriptors: featurePoints.descriptors
        )
        
        return featurePoints
    }
    
}
