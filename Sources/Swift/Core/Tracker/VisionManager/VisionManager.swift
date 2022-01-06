//
//  VisionManager.swift
//  
//
//  Created by Jean Flaherty on 6/5/21.
//

import Foundation
import ARKit
import LANumerics
import opencv2
import OSLog
import CoreLocation


class VisionManager: NSObject {
    
    enum VisionError: Error {
        case imageProcessingError
    }
    
    
    // MARK: Parameters
    
    static let processDelay: TimeInterval = 3.0
    static let featurePointAnchorAdditionLimit = 400
    static let minFeaturePointExtent: Float = 0.01
    static let minFeaturePointDistance: Float = 0.5
    
    
    // MARK: Registration Parameters
    
    static let minMatchesForRegistration = 5
    static let minInliersForRegistration = 5
    static let minYAxisChangeCosine: Float = 0.990 // within acos(0.99) ~= 8.1 deg
    static let minInlierCovarianceDeterminant: Float = pow(35, 4)
    
    
    // MARK: Proporties
    
    let detector = AKAZE.create(
        descriptor_type: .DESCRIPTOR_MLDB,
        descriptor_size: 0,
        descriptor_channels: 3,
        threshold: 0.0008)
    let matcher = BFMatcher(normType: .NORM_HAMMING)
    let processDispatchQueue = DispatchQueue(
        label: "com.kobejean.GeoAR.VisionManager",
        qos: .init(qosClass: .background, relativePriority: -10))
    
    weak var tracker: InternalTracker?
    
    @available(iOS 14, *)
    lazy var logger = Logger(subsystem: "com.kobejean.GeoAR", category: "VisionManager")
    
    
    // MARK: - Private Proporties
    
    // Proporties for throttling
    private var _lastProcessTimestamp: TimeInterval = 0
    private var _isWaitingForCompletetion = false
    private var _lastWorkItem: DispatchWorkItem?
    private var _isWaitingForRelocalizing = false
    
    var _lastAnomalyRelativeTransform: simd_float4x4?
    
    
    // MARK: - Process
    
    func process(frame: ARFrame) {
        _throttle { [weak self] in
            guard let self = self, let tracker = self.tracker else { return }
            
            switch tracker.mode {
            case .mapping: self.map(frame: frame)
            case .tracking: self.track(frame: frame)
            }
        }
    }
    
    
    // MARK: Map
    
    /// Detects feature point anchors and updates/extends world map with ``ARFrame`` data.
    /// - Parameter frame: The ``ARFrame`` object that contains data to update/extend the world map with.
    func map(frame: ARFrame) {
        guard let result = try? _detectAndMatch(frame: frame) else { return }
        
        let updated = updateFeaturePoints(frame: frame, matches: result.matches)
        let added = addFeaturePoints(frame: frame, nonMatches: result.nonMatches)
        
        _addCameraPoint(frame: frame, updated: updated, added: added)
    }
    
    private func _addCameraPoint(frame: ARFrame, updated: [Feature], added: [Feature]) {
        // Add camera point to point cloud
        guard let mapAnchor = frame.mapAnchor else { return }
        let cameraPoint = CameraPoint(camera: frame.camera)
        cameraPoint.add(added)
        cameraPoint.add(updated)
        let mapSpaceCameraPoint = mapAnchor.moveIn(cameraPoint)
        tracker?.map.pointCloud.add(mapSpaceCameraPoint)
    }
    
    
    // MARK: Track
    
    /// Detects feature point anchors and updates  camera position with ``ARFrame`` data.
    /// - Parameter frame: The ``ARFrame`` object that contains data to track the camera position with.
    func track(frame: ARFrame) {
        guard let result = try? _detectAndMatch(frame: frame) else { return }
        
        register(matches: result.matches, frame: frame)
    }
    
    
    // MARK: Detect and Match
    
    /// Performs feature point detection and matching on the provided ``ARFrame`` object.
    /// - Parameter frame: The frame to perform feature point detection and matching on.
    /// - Throws: Throws VisionError when image processing fails.
    /// - Returns: A tuple of `matches` and `nonMatches`:
    ///   - `matches`: An array of matched feature points.
    ///   - `nonMatches`: A tuple with new and old unmatched zipped feature points.
    private func _detectAndMatch(frame: ARFrame) throws -> (matches: [Match], nonMatches: NonMatches) {
        let buffer = frame.capturedImage
        
        let new = try detectFeaturePoints(buffer: buffer)
        let old = gatherFeaturePoints(frame: frame)
        
        return matchFeaturePoints(new: new, old: old)
    }
    
    
    // MARK: Relocalize
    
    func relocalize(frame: ARFrame) {
        // TODO: Figure out a cleaner way to reset queue for relocalization
        // while still throttling
        if !_isWaitingForRelocalizing {
            // If this is our first relocalization frame invalidate process
            _invalidateProcess()
            _isWaitingForRelocalizing = true
        }
        _throttle { [weak self] in
            self?.track(frame: frame)
        }
    }
    
    func relocalize(relativeTransform: simd_float4x4) {
        guard let tracker = tracker, let session = tracker.session else { return }
        
        session.alignWorld(relativeTransform: relativeTransform)
        _isWaitingForRelocalizing = false
        tracker.state = .normal
    }
    
    
    // MARK: - Throttling
    
    private func _isReadyToProcess() -> Bool {
        let now = Date().timeIntervalSinceBootup()
        let delayHasPassed = now >= _lastProcessTimestamp + Self.processDelay
        return !_isWaitingForCompletetion && delayHasPassed
    }
    
    
    private func _invalidateProcess() {
        _lastProcessTimestamp = 0
        _isWaitingForCompletetion = false
        _lastWorkItem?.cancel()
        _lastWorkItem = nil
    }
    
    private func _throttle(execute work: @escaping () -> Void) {
        guard _isReadyToProcess() else { return }
        _isWaitingForCompletetion = true
        
        let startTime = Date().timeIntervalSinceBootup()
        
        let workItem = DispatchWorkItem { [weak self] in
            work()
                
            let endTime = Date().timeIntervalSinceBootup()
            self?._lastProcessTimestamp = endTime
            self?._isWaitingForCompletetion = false
            
            if #available(iOS 14.0, *) {
                self?.logger.info("Duration: \(endTime - startTime)")
            }
        }
        
        processDispatchQueue.async(execute: workItem)
        _lastWorkItem = workItem
    }
    
    func syncWithSession(execute work: @escaping () -> Void) {
        // If false it means task was canceled
        guard _isWaitingForCompletetion else { return }
        let dispatchQueue = tracker?.session?.delegateQueue ?? DispatchQueue.main
        dispatchQueue.async(execute: work)
    }
}
