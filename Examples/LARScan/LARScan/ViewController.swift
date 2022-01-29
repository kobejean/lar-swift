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
import LocalAR
import CoreLocation
import Collections

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, CLLocationManagerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var snapButton: UIButton!
    
    var mapper: LARLiveMapper!
    
    let locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()
    
    let mapAnchor = ARAnchor(name: "mapAnchor", transform: matrix_identity_float4x4)
    let mapNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapper = LARLiveMapper(directory: createSessionDirctory()!)
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.session.delegate = self
        locationManager.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ .showWorldOrigin, .showFeaturePoints ]
        
        scaleConstraint = SCNTransformConstraint(inWorldSpace: true) { node, transform in
            guard let camPosition = self.sceneView.pointOfView?.worldPosition else { return transform }
            let scale = max(simd_distance(simd_float3(camPosition), simd_float3(node.worldPosition)), 0.5)
            var newTransform = transform
            newTransform.m11 = scale
            newTransform.m22 = scale
            newTransform.m33 = scale
            return newTransform
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.frameSemantics = .smoothedSceneDepth
        configuration.worldAlignment = .gravity

        // Run the view's session
        sceneView.session.run(configuration)
        sceneView.session.add(anchor: mapAnchor)
        
        sceneView.pointOfView?.camera?.usesOrthographicProjection = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        sceneView.session.remove(anchor: mapAnchor)
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
        
        AudioServicesPlaySystemSound(SystemSoundID(1108))
        Task.detached(priority: .low) { [self] in
            await mapper.add(frame: frame)
            await mapper.writeMetadata()
            await mapper.process()
            await renderDebug()
        }
    }

    // MARK: - ARSCNViewDelegate
    
    var scaleConstraint: SCNTransformConstraint!
    
    let locationNode = { () -> SCNNode in
        let node = SCNNode()
        node.geometry = SCNSphere(radius: 0.005)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.systemBlue
        return node
    }()
    
    let unusedLandmarkNode = { () -> SCNNode in
        let node = SCNNode()
        node.geometry = SCNSphere(radius: 0.002)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        return node
    }()
    
    let landmarkNode = { () -> SCNNode in
        let node = SCNNode()
        node.geometry = SCNSphere(radius: 0.002)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        return node
    }()

//     Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        if (anchor == mapAnchor) {
            return mapNode
        }
        return nil
    }
    
    var landmarkNodes: [SCNNode] = []
    var locationNodes: [SCNNode] = []
    
    func renderDebug() async {
        landmarkNodes.forEach { $0.removeFromParentNode() }
        landmarkNodes.removeAll()
        
        let (landmarks, gps_observations) = await (mapper.data.map.landmarks, mapper.data.gps_observations)
        
        let landmarkConstraints: [SCNConstraint] = [scaleConstraint]
        let filteredLandmarks = landmarks.sorted(by: {
            $0.lastSeen > $1.lastSeen || ($0.lastSeen == $1.lastSeen && $0.isUsable())
        }).prefix(upTo: 1000)
        for landmark in filteredLandmarks {
            let usable = landmark.isUsable()
            
            let node = usable ? landmarkNode.clone() : unusedLandmarkNode.clone()
            var transform = SCNMatrix4Identity
            transform.m41 = Float(landmark.position.x)
            transform.m42 = Float(landmark.position.y)
            transform.m43 = Float(landmark.position.z)
            node.transform = transform
            node.constraints = landmarkConstraints
            mapNode.addChildNode(node)
            landmarkNodes.append(node)
        }
        
        let filteredObservations = gps_observations.suffix(gps_observations.count - locationNodes.count)
        for observation in filteredObservations {
            let node = locationNode.clone()
            var transform = SCNMatrix4Identity
            transform.m41 = Float(observation.relative.x)
            transform.m42 = Float(observation.relative.y)
            transform.m43 = Float(observation.relative.z)
            node.transform = transform
            mapNode.addChildNode(node)
            locationNodes.append(node)
        }
    }

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    
    // MARK: ARSessionDelegate
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let timestamp = Date(timeIntervalSinceNow: frame.timestamp - ProcessInfo.processInfo.systemUptime)
        let position = simd_make_float3(frame.camera.transform.columns.3)
        Task.detached(priority: .low) { [mapper] in
            await mapper?.add(position: position, timestamp: timestamp)
        }
    }
    
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task.detached(priority: .low) { [mapper] in
            await mapper?.add(locations: locations)
        }
    }
}
