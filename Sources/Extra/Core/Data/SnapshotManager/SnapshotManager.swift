//
//  SnapshotManager.swift
//  
//
//  Created by Jean Flaherty on 11/10/21.
//

import Foundation
import ARKit
import MobileCoreServices
import opencv2
import LocalARObjC

class SnapshotManager {
    
    enum SnapshotError: Error {
        case imageProcessingError
    }
    
    class Metadata: Codable {
        var frames = [FrameMetadata]()
        var coordinateMeasurements = [LocationPoint]()
    }
    
    let sessionName = Date().timeIntervalSince1970.description
    var frameCount = 0
    let sessionDirectory: URL!
    var metadata = Metadata()
    
    init() {
        sessionDirectory = try? FileManager.default
            .url(for: .documentDirectory,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: true)
            .appendingPathComponent(sessionName, isDirectory: true)
        try? FileManager.default.createDirectory(at: sessionDirectory, withIntermediateDirectories: true, attributes: nil)
    }
    
    func snap(frame: ARFrame) throws {
        defer { frameCount += 1 }
        
        try _saveBufferJpeg(frame.capturedImage,
                         type: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
                         name: String(format: "%08d_image", frameCount))
        metadata.frames.append(FrameMetadata(id: frameCount, frame: frame))

        if #available(iOS 14.0, *), let depthData = frame.smoothedSceneDepth {
            try _saveBufferTiff(depthData.depthMap,
                                type: kCVPixelFormatType_DepthFloat32,
                                name: String(format: "%08d_depth", frameCount),
                                cvType: CvType.CV_32FC1)
            try _saveBufferTiff(depthData.confidenceMap!,
                                type: kCVPixelFormatType_OneComponent8,
                                name: String(format: "%08d_confidence", frameCount),
                                cvType: CvType.CV_8UC1)
        }
    }
    
    func snap(locationPoints: [LocationPoint]) {
        metadata.coordinateMeasurements.append(contentsOf: locationPoints)
    }
    
    func save() -> URL? {
        do {
            let path = sessionDirectory.appendingPathComponent("metadata.json")
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(metadata)
            try data.write(to: path, options: [.atomic])
            
            let processor = LARMapProcessor()
            processor.createMap(sessionDirectory.path)
            return sessionDirectory
        } catch {
            fatalError("Can't get file save URL: \(error.localizedDescription)")
        }
        return nil
    }
    
    private func _saveBufferTiff(_ buffer: CVPixelBuffer, type: OSType, name: String, cvType: Int32) throws {
        // Lock/unlock base address
        CVPixelBufferLockBaseAddress(buffer, [.readOnly])
        defer { CVPixelBufferUnlockBaseAddress(buffer, [.readOnly]) }
        
        let bufferHasExpectedFormatType = CVPixelBufferGetPixelFormatType(buffer) == type
        
        guard bufferHasExpectedFormatType else {
            throw SnapshotError.imageProcessingError
        }
        
        guard let mat = Mat(buffer: buffer, 0, cvType) else { return }
        
        
        let path = sessionDirectory.appendingPathComponent("\(name).pfm")
        Imgcodecs.imwrite(filename: path.path, img: mat)
    }
    
    private func _saveBufferJpeg(_ buffer: CVPixelBuffer, type: OSType, name: String) throws {
        // Lock/unlock base address
        CVPixelBufferLockBaseAddress(buffer, [.readOnly])
        defer { CVPixelBufferUnlockBaseAddress(buffer, [.readOnly]) }
        
        let bufferHasExpectedFormatType = CVPixelBufferGetPixelFormatType(buffer) == type
        
        guard bufferHasExpectedFormatType else {
            throw SnapshotError.imageProcessingError
        }
        
        let ciimage = CIImage(cvPixelBuffer: buffer)
        let context = CIContext.init(options: nil)
        guard let cgImage = context.createCGImage(ciimage, from: ciimage.extent) else { return }
        let uiImage = UIImage(cgImage: cgImage)
        
        do {
            let path = sessionDirectory.appendingPathComponent("\(name).jpeg")
            try uiImage.jpegData(compressionQuality: 0.5)?.write(to: path, options: [.atomic])
        } catch {
            fatalError("Can't get file save URL: \(error.localizedDescription)")
        }
    }
    
}
