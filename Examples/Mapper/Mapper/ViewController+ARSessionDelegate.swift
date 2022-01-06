//
//  ViewController+ARSessionDelegate.swift
//  Mapper
//
//  Created by Jean Flaherty on 5/28/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import SceneKit
import ARKit
import GeoAR

extension ViewController: ARSessionDelegate {
    
    // MARK: - ARSessionDelegate
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        updateSessionInfoLabel(for: session.currentFrame!, trackingState: camera.trackingState)
        
        if case .limited(.initializing) = camera.trackingState {
            let anchors = sceneView.tracker.map.anchors
            if let navigationGraph = anchors.first(where: { $0 is GeoARNavigationGraphAnchor }) as? GeoARNavigationGraphAnchor {
                self.navigationGraph = navigationGraph.graph
            } else {
                let anchor = GeoARNavigationGraphAnchor(graph: navigationGraph)
                sceneView.tracker.add(anchor: anchor)
            }
        }
    }
    
    /// - Tag: CheckMappingStatus
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        statusLabel.text = """
        ARKit Mapping: \(frame.worldMappingStatus.description)
        ARKit Tracking: \(frame.camera.trackingState.description)
        GeoAR State: \(sceneView.tracker.state)
        GeoAR Mode: \(sceneView.tracker.mode)
        Debug: \(sceneView.tracker.debugString)
        """
        updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
    }
    
    
    // MARK: - ARSessionObserver
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay.
        sessionInfoLabel.text = "Session was interrupted"
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required.
        sessionInfoLabel.text = "Session interruption ended"
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        sessionInfoLabel.text = "Session failed: \(error.localizedDescription)"
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        
        // Remove optional error messages.
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            // Present an alert informing about the error that has occurred.
            let alertController = UIAlertController(title: "The AR session failed.", message: errorMessage, preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
                alertController.dismiss(animated: true, completion: nil)
                self.resetTracking(nil)
            }
            alertController.addAction(restartAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - AR session management
    
    @IBAction func resetTracking(_ sender: UIButton?) {
        sceneView.session.run(defaultConfiguration, options: [.resetTracking, .removeExistingAnchors])
        isRelocalizingMap = false
    }
    
    @IBAction func resetSceneReconstruction(_ sender: UIButton?) {
        let configuration = sceneView.session.configuration ?? defaultConfiguration
        sceneView.session.run(configuration, options: [.resetSceneReconstruction])
        isRelocalizingMap = false
    }
    
    private func updateSessionInfoLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
        // Update the UI to provide feedback on the state of the AR experience.
        let message: String
        
        switch (trackingState, frame.worldMappingStatus) {
        case (.normal, .mapped),
             (.normal, .extending):
            message = "Tap on the screen to place a navigation point."
            
        case (.normal, _) where mapDataFromFile != nil && !isRelocalizingMap:
            message = "Move around to map the environment or tap 'Load Experience' to load a saved experience."
            
        case (.normal, _) where mapDataFromFile == nil:
            message = "Move around to map the environment."
            
        case (.limited(.relocalizing), _) where isRelocalizingMap:
            message = "Move your device to the location shown in the image."
            
        default:
            message = trackingState.localizedFeedback
        }
        
        sessionInfoLabel.text = message
        sessionInfoView.isHidden = message.isEmpty
    }
}
