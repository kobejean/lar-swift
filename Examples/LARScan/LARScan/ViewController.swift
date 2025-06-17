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

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, CLLocationManagerDelegate, LARMapDelegate, UIDocumentPickerDelegate, MKMapViewDelegate {
	
	@IBOutlet var sceneView: ARSCNView!
	@IBOutlet var mapView: MKMapView!
	@IBOutlet var modeControl: UISegmentedControl!
	@IBOutlet var actionButton: UIButton!
	
	var mapper: LARLiveMapper!
	var anchorNodes = LARSCNNodeCollection()
	var larNavigation: LARNavigationManager!
	var pauseGPSRecord = false
	private var currentFolderURL: URL?
	
	let locationManager: CLLocationManager = {
		let locationManager = CLLocationManager()
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.distanceFilter = kCLDistanceFilterNone
		locationManager.pausesLocationUpdatesAutomatically = false
		locationManager.startUpdatingLocation()
		locationManager.requestWhenInUseAuthorization()
		return locationManager
	}()
	
	let mapNode = SCNNode()
	var userLocationAnnotationView: LARMKUserLocationAnnotationView?
	
	// MARK: - UIViewController Lifecycle
	
	deinit {
		currentFolderURL?.stopAccessingSecurityScopedResource()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		mapper = LARLiveMapper(directory: createSessionDirctory()!)
		Task {
			let map = await mapper.data.map
			map.delegate = self
			larNavigation = LARNavigationManager(map: map, mapView: mapView, mapNode: mapNode)
		}
		
		// Set the view's delegate
		sceneView.delegate = self
		sceneView.session.delegate = self
		locationManager.delegate = self
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
		sceneView.scene.rootNode.addChildNode(mapNode)
		
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
		mapNode.removeFromParentNode()
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
	
	@IBAction func saveButtonPressed(_ button: UIButton) {
		Task.detached(priority: .low) { [weak mapper] in await mapper?.mapper.writeMetadata() }
	}
	
	@IBAction func openButtonPressed(_ button: UIButton) {
		let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
		documentPicker.delegate = self
		documentPicker.allowsMultipleSelection = false
		
		// Start in the app's document directory
		if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			documentPicker.directoryURL = documentsURL
		}
		
		present(documentPicker, animated: true)
	}
	
	@IBAction func modeChanged(_ sender: UISegmentedControl) {
		let actionTitle = ["Snap", "Localize"][sender.selectedSegmentIndex]
		actionButton.setTitle(actionTitle, for: .normal)
		switch sender.selectedSegmentIndex {
		case 0: break
		case 1: Task(priority: .low) { await mapper.updateTracker() }
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
		let location = sender.location(in: sceneView)
		
		// Hit test only anchor nodes
		let hitTestOptions: [SCNHitTestOption: Any] = [
			.categoryBitMask: LARSCNAnchorNode.anchorCategory,
			.firstFoundOnly: true
		]
		let hitResults = sceneView.hitTest(location, options: hitTestOptions)
		
		if let hitResult = hitResults.first, let anchorNode = hitResult.node as? LARSCNAnchorNode {
			// Connect from selected anchorNode
			if let selectedNode = LARSCNAnchorNode.selectedNode, selectedNode != anchorNode {
				larNavigation.addNavigationEdge(from: selectedNode.anchorId, to: anchorNode.anchorId)
			}
			anchorNode.isSelected = !anchorNode.isSelected
		} else {
			// No anchor node tapped, do raycast placement
			guard let query = sceneView.raycastQuery(from: location, allowing: .estimatedPlane, alignment: .any),
				  let result = sceneView.session.raycast(query).first
			else { return }
			Task {
				let position = mapNode.simdConvertPosition(
					result.worldTransform.position,
					from: sceneView.scene.rootNode
				)
				let anchor = await mapper.mapper.createAnchor(transform: position.transform)
				sceneView.session.add(anchor: LARARAnchor(anchor: anchor, transform: result.worldTransform))
			}
		}
	}
	
	func snap() {
		guard let frame = sceneView.session.currentFrame else { return }
		AudioServicesPlaySystemSound(SystemSoundID(1108))
		Task.detached(priority: .low) { [self] in
			await mapper.mapper.addFrame(frame)
			await mapper.mapper.writeMetadata()
		}
	}
	
	func localize() {
		guard let frame = sceneView.session.currentFrame else { return }
		let pose = frame.camera.transform.toDouble()
		// Extract gravity vector from frame extrinsics
		let worldGravity = simd_double3(0.0, -1.0, 0.0)
		let rotation = simd_double3x3(
			simd_double3(pose.columns.0.x, pose.columns.0.y, pose.columns.0.z),
			simd_double3(pose.columns.1.x, pose.columns.1.y, pose.columns.1.z),
			simd_double3(pose.columns.2.x, pose.columns.2.y, pose.columns.2.z)
		)
		let cameraGravity = rotation.inverse * worldGravity
		let gvec = simd_double3(cameraGravity.x, -cameraGravity.y, -cameraGravity.z)
		
		Task.detached(priority: .userInitiated) { [self, pose] in
			if let transform = await mapper.tracker.localize(frame: frame, gvec: gvec) {
				await MainActor.run {
					mapNode.transform = SCNMatrix4((pose * transform.inverse).toFloat())
				}
				await renderDebug()
			}
		}
	}
	
	// MARK: - ARSCNViewDelegate
	
	var scaleConstraint: SCNTransformConstraint!
	let locationNode = SCNNode.sphere(radius: 0.005, color: UIColor.systemBlue)
	let unusedLandmarkNode = SCNNode.sphere(radius: 0.001, color: UIColor.red)
	let landmarkNode = SCNNode.sphere(radius: 0.001, color: UIColor.green)
	
	//     Override to create and configure nodes for anchors added to the view's session.
	func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
		return nil
	}
	
	var landmarkNodes: [SCNNode] = []
	var locationNodes: [SCNNode] = []
	
	@MainActor
	func renderDebug() async {
		landmarkNodes.forEach { $0.removeFromParentNode() }
		landmarkNodes.removeAll()
		
		let (landmarks, gpsObservations) = await (mapper.data.map.landmarks, mapper.data.gpsObservations)
		
		// Populate landmark nodes
		for landmark in prioritizedLandmarks(landmarks, max: 1000) {
			let node = landmark.isMatched ? landmarkNode.clone() : unusedLandmarkNode.clone()
			node.transform = transformFrom(position: landmark.position)
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
	
	// MARK: - ARSessionDelegate
	
	func session(_ session: ARSession, didFailWithError error: Error) {
		// Present an error message to the user
		
	}
	
	func sessionWasInterrupted(_ session: ARSession) {
		// Inform the user that the session has been interrupted, for example, by presenting an overlay
		
	}
	
	func sessionInterruptionEnded(_ session: ARSession) {
		// Reset tracking and/or remove existing anchors if consistent tracking is required
	}
	
	func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
		let anchors = anchors.compactMap { anchor in anchor as? LARARAnchor }
		if anchors.isEmpty { return }
		var updates: [(LARARAnchor, simd_float4x4)] = []
		for anchor in anchors {
			// TODO: see if we can use transform directly when mapping by just keeping map node at origin
			let transform = mapNode.simdConvertTransform(anchor.transform, from: sceneView.scene.rootNode)
			updates.append((anchor, transform))
		}
		Task.detached(priority: .low) { [weak mapper] in
			guard let mapper else { return }
			let map = await mapper.data.map
			for (anchor, transform) in updates {
				map.updateAnchor(anchor.anchor, transform: transform)
			}
		}
	}
	
	func session(_ session: ARSession, didUpdate frame: ARFrame) {
		let timestamp = dateFrom(uptime: frame.timestamp)
		let position = simd_make_float3(frame.camera.transform.columns.3)
		larNavigation.updateUserLocation(position: position)
		Task(priority: .low) { [weak mapper] in
			await mapper?.mapper.addPosition(position, timestamp: timestamp)
		}
	}
	
	// MARK: - CLLocationManagerDelegate
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if pauseGPSRecord { return }
		Task(priority: .low) { // TODO: investigate why detaching is bad here
			await mapper?.mapper.addLocations(locations)
		}
	}
	
	// MARK: - LARMapDelegate
	
	func map(_ map: LARMap, didAdd anchor: LARAnchor) {
		larNavigation.addNavigationPoint(anchor: anchor)
		if let selectedId = LARSCNAnchorNode.selectedNode?.anchorId {
			map.addEdge(from: selectedId, to: anchor.id)
			larNavigation.addNavigationEdge(from: selectedId, to: anchor.id)
		}
		larNavigation.selectAnchor(id: anchor.id)
	}
	
	// MARK: - UIDocumentPickerDelegate
	
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
		guard let selectedURL = urls.first else { return }
		
		// Stop accessing the previous folder if there was one
		if let previousURL = currentFolderURL {
			previousURL.stopAccessingSecurityScopedResource()
		}
		
		// Start accessing the new security-scoped resource
		guard selectedURL.startAccessingSecurityScopedResource() else {
			print("Failed to gain access to selected folder")
			return
		}
		
		// Store the URL for persistent access
		currentFolderURL = selectedURL
		
		print("Selected folder: \(selectedURL)")
		
		// Initialize your mapper with the selected directory
		pauseGPSRecord = true
		mapper = LARLiveMapper(directory: selectedURL)
		Task {
			// TODO: consider detaching
			await mapper.mapper.readMetadata()
			let map = await mapper.data.map
			map.delegate = self
			larNavigation = LARNavigationManager(map: map, mapView: mapView, mapNode: mapNode)
			larNavigation.userLocationAnnotationView = userLocationAnnotationView
			await mapper.updateTracker()
		}
	}
	
	func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
		print("Document picker was cancelled")
	}
	
	// MARK: - MKMapViewDelegate
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if annotation is MKUserLocation {
			let pin = LARMKUserLocationAnnotationView(annotation: annotation, color: .green, reuseIdentifier: nil)
			pin.alpha = 0.25
			larNavigation?.userLocationAnnotationView = pin
			userLocationAnnotationView = pin
			return pin
			
		} else if let annotation = annotation as? MKPointAnnotation,
				  let userLocationAnnotation = larNavigation.userLocationAnnotation,
				  annotation == userLocationAnnotation {
			let pin = LARMKUserLocationAnnotationView(annotation: annotation, color: view.tintColor, reuseIdentifier: nil)
			return pin
		}
		return nil
	}
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if let circle = overlay as? LARMKNavigationGuideNodeOverlay {
			let renderer = MKCircleRenderer(circle: circle)
			renderer.fillColor = view.tintColor
			return renderer
		} else if let circle = overlay as? LARMKNavigationNodeOverlay {
			let renderer = MKCircleRenderer(circle: circle)
			renderer.fillColor = .white
			return renderer
		}
		
		return MKOverlayRenderer(overlay: overlay)
	}
	//
	//    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
	//        if !mapRegionIsMovedProgramatically {
	//            mapRegionIsMovedByUser = true
	//        }
	//    }
	//
	//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
	//        if !mapRegionIsMovedProgramatically {
	//            mapRegionFreezeTimer?.invalidate()
	//            mapRegionFreezeTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { [weak self] timer in
	//                self?.mapRegionIsMovedByUser = false
	//            }
	//        } else {
	//            mapRegionIsMovedProgramatically = false
	//        }
	//    }
	
}
