//
//  ViewController.swift
//  LARScan
//
//  Created by Jean Flaherty on 2022/01/23.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation
import LocalARObjC
import LocalAR
import CoreLocation

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, CLLocationManagerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var snapButton: UIButton!
    var collector: LARCollection!
    let locationMatcher = LARLocationMatcher()
    
    let locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
//        locationManager.headingFilter = 0.5
        locationManager.pausesLocationUpdatesAutomatically = false
//        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collector = LARCollection(directory: createSessionDirctory()!)
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.session.delegate = self
        locationManager.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ .showWorldOrigin, .showFeaturePoints ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.frameSemantics = .smoothedSceneDepth
        configuration.worldAlignment = .gravity

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func createSessionDirctory() -> URL? {
        let sessionName = Int(round(Date().timeIntervalSince1970 * 1e3)).description
        guard let sessionDirectory = try? FileManager.default
            .url(for: .documentDirectory,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: true)
            .appendingPathComponent(sessionName, isDirectory: true)
        else { return nil }
        try? FileManager.default.createDirectory(at: sessionDirectory, withIntermediateDirectories: true, attributes: nil)
        return sessionDirectory
    }
    
    // MARK: - IBAction
    
    @IBAction func snapFrame(_ button: UIButton) {
        guard let frame = sceneView.session.currentFrame else { return }
        collector.add(frame)
        AudioServicesPlaySystemSound(SystemSoundID(1108))
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        locationMatcher.observe(position: LARPositionObservation(frame: frame))
        
        for (location, position) in locationMatcher.matches() {
            collector.addGPSObservation(location, position: position)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            locationMatcher.observe(location: location)
        }
    }
}
