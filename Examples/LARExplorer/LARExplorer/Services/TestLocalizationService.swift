//
//  TestLocalizationService.swift
//  LARExplorer
//
//  Created by Jean Flaherty on 2025-07-03.
//

import SwiftUI
import AppKit
import SceneKit
import LocalizeAR
import simd

class TestLocalizationService: ObservableObject {
    @Published var selectedDirectory: URL?
    @Published var frames: [LARFrame] = []
    @Published var selectedFrameId: Int?
    @Published var localizationResult: LocalizationResult?
    @Published var isProcessing = false
    @Published var errorMessage: String?
    @Published var imageCache: [Int: NSImage] = [:]
    @Published var usedCameraPose = false
    
    private var tracker: LARTracker?
    private var map: LARMap?
    private weak var sceneView: SCNView?
    private var configuredImageSize: CGSize?
    
    var hasSceneView: Bool {
        return sceneView != nil
    }
    
    struct LocalizationResult: Equatable {
        let frameId: Int
        let originalTransform: simd_double4x4
        let localizedTransform: simd_double4x4
        let success: Bool
        let processingTime: TimeInterval
        let spatialQueryLandmarkIds: [Int]
        let matchLandmarkIds: [Int]
        let inlierLandmarkIds: [Int]
        let gravityAngleDifference: Double
        let inlierBounds: [(simd_double2, simd_double2)] // Lower and upper bounds for each inlier
        
        static func == (lhs: LocalizationResult, rhs: LocalizationResult) -> Bool {
            lhs.frameId == rhs.frameId &&
            lhs.success == rhs.success &&
            lhs.spatialQueryLandmarkIds == rhs.spatialQueryLandmarkIds &&
            lhs.matchLandmarkIds == rhs.matchLandmarkIds &&
            lhs.inlierLandmarkIds == rhs.inlierLandmarkIds
        }
        
        var position: simd_double3 {
            simd_double3(localizedTransform.columns.3.x, 
                        localizedTransform.columns.3.y, 
                        localizedTransform.columns.3.z)
        }
        
        var positionDifference: simd_double3 {
            let origPos = simd_double3(originalTransform.columns.3.x,
                                      originalTransform.columns.3.y,
                                      originalTransform.columns.3.z)
            return position - origPos
        }
    }
    
    func configure(with map: LARMap) {
        self.map = map
        // Uses default 1920x1440, will auto-reconfigure based on actual image size
        self.tracker = LARTracker(map: map)
    }
    
    func configure(sceneView: SCNView) {
        self.sceneView = sceneView
    }
    
    
    private func getCurrentCameraPose() -> simd_double4x4? {
        guard let sceneView = sceneView,
              let pointOfView = sceneView.pointOfView else {
            return nil
        }
        
        // Get the camera's world transform
        let cameraTransform = pointOfView.worldTransform
        
        // Convert SCNMatrix4 to simd_double4x4
        return simd_double4x4(
            simd_double4(Double(cameraTransform.m11), Double(cameraTransform.m12), Double(cameraTransform.m13), Double(cameraTransform.m14)),
            simd_double4(Double(cameraTransform.m21), Double(cameraTransform.m22), Double(cameraTransform.m23), Double(cameraTransform.m24)),
            simd_double4(Double(cameraTransform.m31), Double(cameraTransform.m32), Double(cameraTransform.m33), Double(cameraTransform.m34)),
            simd_double4(Double(cameraTransform.m41), Double(cameraTransform.m42), Double(cameraTransform.m43), Double(cameraTransform.m44))
        )
    }
    
    func selectDirectory() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = false
        openPanel.title = "Select Directory with frames.json"
        openPanel.prompt = "Select"
        
        if openPanel.runModal() == .OK, let url = openPanel.url {
            loadFrames(from: url)
        }
    }
    
    private func loadFrames(from directory: URL) {
        selectedDirectory = directory
        errorMessage = nil
        frames = []
        imageCache = [:]
        
        let framesURL = directory.appendingPathComponent("frames.json")
        
        // Use LARFrame's C++ JSON loading (same as lar_localize.cpp)
        guard let loadedFrames = LARFrame.loadFrames(fromFile: framesURL.path) else {
            errorMessage = "Failed to load frames.json"
            return
        }
        
        frames = loadedFrames
        
        // Preload first few images
        loadImagePreviews()
    }
    
    private func loadImagePreviews() {
        guard let directory = selectedDirectory else { return }
        
        // Load first 20 images or all if less
        let framesToLoad = min(20, frames.count)
        
        for i in 0..<framesToLoad {
            let frame = frames[i]
            loadImage(for: Int(frame.frameId))
        }
    }
    
    func loadImage(for frameId: Int) {
        guard let directory = selectedDirectory,
              imageCache[frameId] == nil else { return }
        
        let imagePath = getImagePath(directory: directory, frameId: frameId)
        
        if let image = NSImage(contentsOf: imagePath) {
            imageCache[frameId] = image
        }
    }
    
    private func getImagePath(directory: URL, frameId: Int) -> URL {
        let paddedId = String(format: "%08d", frameId)
        return directory.appendingPathComponent("\(paddedId)_image.jpeg")
    }
    
    func performLocalization(for frameId: Int) {
        guard let tracker = tracker,
              let directory = selectedDirectory,
              let frame = frames.first(where: { $0.frameId == frameId }) else {
            errorMessage = "Frame not found or tracker not configured"
            return
        }

        selectedFrameId = frameId
        isProcessing = true
        errorMessage = nil

        Task {
            do {
                let startTime = Date()

                // Load image as CGImage (opencv stays inside the C++/ObjC layer).
                let imagePath = getImagePath(directory: directory, frameId: frameId)
                guard let nsImage = NSImage(contentsOf: imagePath),
                      let cgImage = nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
                    throw LocalizationError.imageConversionFailed
                }

                // Ensure tracker is configured with actual image size
                let currentSize = CGSize(width: cgImage.width, height: cgImage.height)
                if configuredImageSize != currentSize {
                    configuredImageSize = currentSize
                    tracker.configureImageSize(withWidth: Int32(cgImage.width), height: Int32(cgImage.height))
                    print("Tracker reconfigured for image size: \(cgImage.width)x\(cgImage.height)")
                }

                // Get original transform from frame's internal data
                let originalTransform = getFrameTransform(frame)

                // Get camera position for spatial querying
                let cameraPose = getCurrentCameraPose()
                let (queryX, queryZ, queryDiameter) = extractSpatialQueryParams(cameraPose: cameraPose)

                await MainActor.run {
                    self.usedCameraPose = cameraPose != nil
                }

                print("Spatial query: x=\(queryX), z=\(queryZ), diameter=\(queryDiameter)")

                // Perform frame-based localization with spatial query parameters.
                let (success, transformRows) = tracker.localize(cgImage, frame: frame, queryX: queryX, queryZ: queryZ, queryDiameter: queryDiameter)

                let processingTime = Date().timeIntervalSince(startTime)

                if success, let transformRows = transformRows {
                    let localizedTransform = simd4x4(fromRows: transformRows)
                    
                    // Get diagnostic information from tracker
                    let spatialQueryLandmarkIds = tracker.spatialQueryLandmarkIds().map { $0.intValue }
                    let matchLandmarkIds = tracker.matchLandmarkIds().map { $0.intValue }
                    let inlierLandmarkIds = tracker.inlierLandmarkIds().map { $0.intValue }
                    let gravityAngleDifference = tracker.gravityAngleDifference()
                    
                    // Collect bounds for inlier landmarks
                    let landmarks = map!.landmarks
                    var inlierBounds: [(simd_double2, simd_double2)] = []
                    for inlierId in inlierLandmarkIds {
                        if let landmark = landmarks.first(where: { $0.id == inlierId }) {
                            inlierBounds.append((landmark.boundsLower, landmark.boundsUpper))
                        }
                    }
                    
                    print("Spatial query landmarks: \(spatialQueryLandmarkIds.count)")
                    print("Feature matches: \(matchLandmarkIds.count)")
                    print("Inliers: \(inlierLandmarkIds.count)")
                    print("Gravity vector angle difference: \(gravityAngleDifference) degrees")
                    
                    await MainActor.run {
                        self.localizationResult = LocalizationResult(
                            frameId: frameId,
                            originalTransform: originalTransform,
                            localizedTransform: localizedTransform,
                            success: true,
                            processingTime: processingTime,
                            spatialQueryLandmarkIds: spatialQueryLandmarkIds,
                            matchLandmarkIds: matchLandmarkIds,
                            inlierLandmarkIds: inlierLandmarkIds,
                            gravityAngleDifference: gravityAngleDifference,
                            inlierBounds: inlierBounds
                        )
                        self.isProcessing = false
                    }
                } else {
                    // Even on failure, collect diagnostic information for debugging
                    let spatialQueryLandmarkIds = tracker.spatialQueryLandmarkIds().map { $0.intValue }
                    let matchLandmarkIds = tracker.matchLandmarkIds().map { $0.intValue }
                    let inlierLandmarkIds: [Int] = [] // No inliers on failure
                    let gravityAngleDifference = tracker.gravityAngleDifference()
                    
                    print("LOCALIZATION FAILED - Diagnostic info:")
                    print("Spatial query landmarks: \(spatialQueryLandmarkIds.count)")
                    print("Feature matches: \(matchLandmarkIds.count)")
                    print("Inliers: 0 (failed)")
                    print("Gravity vector angle difference: \(gravityAngleDifference) degrees")
                    
                    await MainActor.run {
                        self.localizationResult = LocalizationResult(
                            frameId: frameId,
                            originalTransform: originalTransform,
                            localizedTransform: cameraPose ?? simd_double4x4(1.0), // Use camera pose or identity as fallback
                            success: false,
                            processingTime: processingTime,
                            spatialQueryLandmarkIds: spatialQueryLandmarkIds,
                            matchLandmarkIds: matchLandmarkIds,
                            inlierLandmarkIds: inlierLandmarkIds,
                            gravityAngleDifference: gravityAngleDifference,
                            inlierBounds: [] // No inlier bounds on failure
                        )
                        self.isProcessing = false
                    }
                }
                
            } catch {
                await MainActor.run {
                    self.errorMessage = "Localization failed: \(error.localizedDescription)"
                    self.isProcessing = false
                    self.localizationResult = nil
                }
            }
        }
    }
    
    private func getFrameTransform(_ frame: LARFrame) -> simd_double4x4 {
        // Access the frame's internal extrinsics matrix
        // For now, create a dummy transform - this should be improved to access the actual data
        return simd_double4x4(1.0)  // Identity matrix as placeholder
    }
    
    /// Build a column-major simd_double4x4 from the row-major [[Double]] returned by
    /// LARTracker.localize(_:frame:queryX:queryZ:queryDiameter:).
    private func simd4x4(fromRows rows: [[Double]]) -> simd_double4x4 {
        simd_double4x4(columns: (
            simd_double4(rows[0][0], rows[1][0], rows[2][0], rows[3][0]),
            simd_double4(rows[0][1], rows[1][1], rows[2][1], rows[3][1]),
            simd_double4(rows[0][2], rows[1][2], rows[2][2], rows[3][2]),
            simd_double4(rows[0][3], rows[1][3], rows[2][3], rows[3][3])
        ))
    }
    
    private func extractSpatialQueryParams(cameraPose: simd_double4x4?) -> (Double, Double, Double) {
        guard let pose = cameraPose else {
            // No camera pose available - use global search
            return (0.0, 0.0, 0.0) // diameter 0 means search all landmarks
        }
        
        // Extract position from camera pose (XZ plane coordinates)
        let queryX = pose.columns.3.x
        let queryZ = pose.columns.3.z
        let queryDiameter = 10.0 // 10 meter search diameter
        
        return (queryX, queryZ, queryDiameter)
    }
    
    func reset() {
        selectedDirectory = nil
        frames = []
        selectedFrameId = nil
        localizationResult = nil
        errorMessage = nil
        imageCache = [:]
        
        // Note: Visualization clearing is now handled by ContentView observing this reset
    }
    
}

enum LocalizationError: LocalizedError {
    case imageConversionFailed
    case localizationFailed
    
    var errorDescription: String? {
        switch self {
        case .imageConversionFailed:
            return "Failed to convert image to proper format"
        case .localizationFailed:
            return "Localization algorithm failed to find position"
        }
    }
}
