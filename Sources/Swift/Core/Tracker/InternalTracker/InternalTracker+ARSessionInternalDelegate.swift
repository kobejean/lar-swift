//
//  InternalTracker+ARSessionInternalDelegate.swift
//  
//
//  Created by Jean Flaherty on 6/1/21.
//

import Foundation
import ARKit

extension InternalTracker: ARSessionInternalDelegate {
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        if #available(iOS 14, *) {
            logger.info("Tracking state: \(camera.trackingState)")
        }
        
        switch camera.trackingState {
            case .limited(let reason):
                _handleLimitedTackingState(session: session, camera: camera, reason: reason)
                break
            case .normal:
                run()
                break
            default: break
        }
        
        delegate?.session?(session, cameraDidChangeTrackingState: camera)
        session.externalDelegate?.session?(session, cameraDidChangeTrackingState: camera)
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        if _snapNextFrame {
            try? snapshotManager.snap(frame: frame)
            _snapNextFrame = false
        }
        
        // Only process frames when in a stable state
        if case .normal = frame.camera.trackingState {
            locationManager.process(frame: frame)
            visionManager.process(frame: frame)
        } else if case .relocalizing = state {
            visionManager.relocalize(frame: frame)
        }
        
        delegate?.session?(session, didUpdate: frame)
        session.externalDelegate?.session?(session, didUpdate: frame)
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        // Don't forward delegate while updating and call update delegate manually
        guard !isPausingDelegateCalls else { return }
        
        delegate?.session?(session, didAdd: anchors)
        session.externalDelegate?.session?(session, didAdd: anchors)
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        // Don't forward delegate while updating and call update delegate manually
        guard !isPausingDelegateCalls else { return }
        
        delegate?.session?(session, didRemove: anchors)
        session.externalDelegate?.session?(session, didRemove: anchors)
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        if let mapAnchor = anchors.first(where: { $0 is GeoARMapAnchor }) as? GeoARMapAnchor {
            // Check if this is in-fact preventing ARKit from updating
            let _isPausingDelegateCalls = isPausingDelegateCalls
            isPausingDelegateCalls = true
            session.remove(anchor: mapAnchor)
            session.add(anchor: self.mapAnchor!)
            isPausingDelegateCalls = _isPausingDelegateCalls
        }
        
        delegate?.session?(session, didUpdate: anchors)
        session.externalDelegate?.session?(session, didUpdate: anchors)
    }
    
    
    // MARK: Tracking State Helpers
    
    private func _handleLimitedTackingState(session: ARSession, camera: ARCamera, reason: ARCamera.TrackingState.Reason) {
        switch reason {
        case .initializing:
            _handleInitializingTrackingState(session: session)
        default:
            break
        }
    }
    
    private func _handleInitializingTrackingState(session: ARSession) {
        // TODO: Make this a little more readable/understandable
        if let mapAnchor = session.currentFrame?.mapAnchor {
            self.map = mapAnchor.map
            self.mapAnchor = mapAnchor
        } else {
            // At this point it seems there is no `GeoARMapAnchor` defined anywhere so lets create a new one
            let anchor = GeoARMapAnchor(transform: matrix_identity_float4x4, map: map)
            self.mapAnchor = anchor
            session.add(anchor: anchor)
        }
        
    }
    
}
