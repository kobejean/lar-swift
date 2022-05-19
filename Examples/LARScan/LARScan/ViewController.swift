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
import LocalizeAR
import CoreLocation
import MapKit

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, CLLocationManagerDelegate, LARMapDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var modeControl: UISegmentedControl!
    @IBOutlet var actionButton: UIButton!
    
    var mapper: LARLiveMapper!
    var tracker: LARTracker!
    
    let locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()
    var currentLocation: CLLocation?
    var userLocationAnnotation: MKPointAnnotation?
    var userLocationAnnotationView: LARMKUserLocationAnnotationView?
    
    let mapAnchor = ARAnchor(name: "mapAnchor", transform: matrix_identity_float4x4)
    let mapNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapper = LARLiveMapper(directory: createSessionDirctory()!)
        Task { [mapper] in
            let map = await mapper!.data.map
            map.delegate = self
        }
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.session.delegate = self
        locationManager.delegate = self
        
//        mapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 1, maxCenterCoordinateDistance: 80)
        mapView.userTrackingMode = .follow
        
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
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
        sceneView.session.add(anchor: mapAnchor)
        
        // This constraint allows landmarks to be visible from far away
        guard let pointOfView = sceneView.pointOfView else { return }
        scaleConstraint = SCNScreenSpaceScaleConstraint(pointOfView: pointOfView)
        landmarkNode.constraints = [scaleConstraint]
        unusedLandmarkNode.constraints = [scaleConstraint]
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
    
    @MainActor
    func updateUserLocation(position: simd_float3) async {
        guard await mapper.data.gpsObservations.count >= 2,
            let global = await mapper.data.map.globalPoint(from: simd_double3(position))
        else { return }
        let location = CLLocation(latitude: global.x, longitude: global.y)
        let distance = currentLocation?.distance(from: location)
        guard distance == nil || distance! > 0.1 else { return }
        
        if userLocationAnnotation == nil {
            let annotaion = MKPointAnnotation()
            mapView.addAnnotation(annotaion)
            mapView.userTrackingMode = .none
            userLocationAnnotation = annotaion
        }
        userLocationAnnotation!.coordinate = location.coordinate
        currentLocation = location
        mapView.setCenter(location.coordinate, animated: true)
    }
    
    // MARK: - IBAction
    
    @IBAction func modeChanged(_ sender: UISegmentedControl) {
        let actionTitle = ["Snap", "Localize"][sender.selectedSegmentIndex]
        actionButton.setTitle(actionTitle, for: .normal)
        
        switch sender.selectedSegmentIndex {
            case 0: break
            case 1: Task { tracker = await LARTracker(map: mapper.data.map) }
            default: break
        }
    }
    
    @IBAction func actionButtonPressed(_ button: UIButton) {
        switch modeControl.selectedSegmentIndex {
            case 0: snap()
            case 1: localize()
            default: break
        }
    }
    
    @IBAction func handleSceneTap(_ sender: UITapGestureRecognizer) {
        // Hit test to find a place for a virtual object.
        guard let query = sceneView
                .raycastQuery(from: sender.location(in: sceneView), allowing: .estimatedPlane, alignment: .any),
              let result = sceneView.session.raycast(query).first
        else {
            return
        }
        let transform = simd_double4x4(
            simd_double4(result.worldTransform.columns.0),
            simd_double4(result.worldTransform.columns.1),
            simd_double4(result.worldTransform.columns.2),
            simd_double4(result.worldTransform.columns.3)
        )
        let anchor = LARAnchor(transform: transform)
        Task {
            await mapper.data.map.add(anchor)
            print(anchor)
        }
    }
    
    func snap() {
        guard let frame = sceneView.session.currentFrame else { return }
        
        AudioServicesPlaySystemSound(SystemSoundID(1108))
        Task.detached(priority: .low) { [self] in
            await mapper.add(frame: frame)
            await mapper.writeMetadata()
            await mapper.process()
            await renderDebug()
        }
    }
    
    func localize() {
        guard let frame = sceneView.session.currentFrame else { return }
        Task.detached(priority: .userInitiated) { [self] in
            if let transform = await tracker.localize(frame: frame) {
                print("t:", transform)
            }
        }
    }

    // MARK: - ARSCNViewDelegate
    
    var scaleConstraint: SCNTransformConstraint!
    
    let anchorNode = SCNNode.sphere(radius: 0.02, color: UIColor.magenta)
    let locationNode = SCNNode.sphere(radius: 0.005, color: UIColor.systemBlue)
//    let unusedLandmarkNode = SCNNode.sphere(radius: 0.002, color: UIColor.gray)
//    let landmarkNode = SCNNode.sphere(radius: 0.002, color: UIColor.green)
    let unusedLandmarkNode = SCNNode.axis(color: UIColor.gray)
    let landmarkNode = SCNNode.axis(color: UIColor.green)

//     Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        return anchor == mapAnchor ? mapNode : nil
    }
    
    var landmarkNodes: [SCNNode] = []
    var locationNodes: [SCNNode] = []
    
    func renderDebug() async {
        landmarkNodes.forEach { $0.removeFromParentNode() }
        landmarkNodes.removeAll()
        
        let (landmarks, gpsObservations) = await (mapper.data.map.landmarks, mapper.data.gpsObservations)
        
        // Populate landmark nodes
        for landmark in prioritizedLandmarks(landmarks, max: 1000) {
            let node = landmark.isUsable() ? landmarkNode.clone() : unusedLandmarkNode.clone()
            node.transform = transformFrom(position: landmark.position, orientation: landmark.orientation)
            mapNode.addChildNode(node)
            landmarkNodes.append(node)
        }
        
        // Populate location nodes
        for observation in gpsObservations.suffix(gpsObservations.count - locationNodes.count) {
            let node = locationNode.clone()
            node.transform = transformFrom(position: observation.relative)
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
        let timestamp = dateFrom(uptime: frame.timestamp)
        let position = simd_make_float3(frame.camera.transform.columns.3)
        Task {
            await updateUserLocation(position: position)
        }
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
    
    // MARK: LARMapDelegate
    
    func map(_ map: LARMap, didAdd anchor: LARAnchor) {
        let node = anchorNode.clone()
        node.transform = SCNMatrix4(anchor.transform)
        mapNode.addChildNode(node)
    }
    
}
