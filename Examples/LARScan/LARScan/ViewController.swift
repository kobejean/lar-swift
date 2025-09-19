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
import Combine
import AVFoundation


class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, CLLocationManagerDelegate, LARMapDelegate, UIDocumentPickerDelegate {
	
	@IBOutlet var sceneView: ARSCNView!
	@IBOutlet var mapView: MKMapView!
	@IBOutlet var modeControl: UISegmentedControl!
	@IBOutlet var actionButton: UIButton!
	
	var audioPlayer: AVAudioPlayer!
	var mapper: LARLiveMapper!
	var anchorNodes = LARSCNNodeCollection()
	var larNavigation: LARNavigationManager!
	var pauseGPSRecord = false
	private var currentFolderURL: URL?
	private var selectedAnchorNode: LARSCNAnchorNode?
	
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
	
	// MARK: - UIViewController Lifecycle
	
	deinit {
		currentFolderURL?.stopAccessingSecurityScopedResource()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		mapper = LARLiveMapper(directory: createSessionDirctory()!)
		Task {
			let map = await mapper.data.map
			larNavigation = LARNavigationManager(map: map, mapView: mapView, mapNode: mapNode)
			larNavigation.additionalMapDelegate = self
		}
		
		// Set the view's delegate
		sceneView.delegate = self
		sceneView.session.delegate = self
		locationManager.delegate = self
		mapView.userTrackingMode = .follow
		
		// Show statistics such as fps and timing information
		sceneView.showsStatistics = true
		sceneView.debugOptions = [ .showWorldOrigin, .showFeaturePoints ]
//		startMusic()
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
	
	func startMusic() {
		// Configure audio session first
		do {
			try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
			try AVAudioSession.sharedInstance().setActive(true)
		} catch {
			print("Failed to set audio session category: \(error)")
			return
		}
		
		guard let path = Bundle.main.path(forResource: "Sunshower", ofType: "m4a") else {
			print("Audio file not found")
			return
		}
		
		let url = URL(fileURLWithPath: path)
		
		do {
			audioPlayer = try AVAudioPlayer(contentsOf: url)
			audioPlayer.numberOfLoops = -1
			audioPlayer?.play()
		} catch {
			print("Error playing audio: \(error)")
		}
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
			if let selectedNode = selectedAnchorNode, selectedNode != anchorNode {
				larNavigation.addNavigationEdge(from: selectedNode.anchorId, to: anchorNode.anchorId)
			}
			selectAnchorNode(anchorNode.isSelected ? nil : anchorNode)
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
				print(position)
				
			}
		}
	}
	
	func snap() {
		guard let frame = sceneView.session.currentFrame else { return }
		AudioServicesPlaySystemSound(SystemSoundID(1108))
		Task.detached(priority: .low) { [self] in
			await mapper.mapper.addFrame(frame)
//			await mapper.mapper.writeMetadata()
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
		
		// Get GPS location for spatial query
		guard let location = locationManager.location else {
			print("No GPS location available for spatial query")
			return
		}
		
		Task.detached(priority: .userInitiated) { [self, pose] in
			let gpsObservations = await mapper.data.gpsObservations
			
			// For now, let's try using the current device position from AR tracking
			// instead of GPS coordinates until we figure out the coordinate system
			let cameraPose = await mapNode.simdConvertTransform(frame.camera.transform, from: sceneView.scene.rootNode).toDouble()
			let queryX = cameraPose.columns.3.x
			let queryZ = cameraPose.columns.3.z
			
			// Use GPS accuracy to determine search diameter
			let gpsAccuracy = location.horizontalAccuracy
			let queryDiameter = min(max(gpsAccuracy * 2.0, 10.0), 100.0)
			
			print("AR-based spatial query: x=\(queryX), z=\(queryZ), diameter=\(queryDiameter)m (GPS accuracy: \(gpsAccuracy)m)")
			
			if let transform = await mapper.tracker.localize(frame: frame, gvec: gvec, queryX: queryX, queryZ: queryZ, queryDiameter: queryDiameter) {
				print("transform: \(transform)")
				await MainActor.run {
					mapNode.transform = SCNMatrix4((pose * transform.inverse).toFloat())
				}
				await renderDebug()
			}
		}
	}
	
	// MARK: - ARSCNViewDelegate
	
	var scaleConstraint: SCNTransformConstraint!
	let locationNode = SCNNode.sphere(radius: 0.005, color: UIColor.systemPurple)
	let unusedLandmarkNode = SCNNode.sphere(radius: 0.002, color: UIColor.red)
	let landmarkNode = SCNNode.sphere(radius: 0.002, color: UIColor.green)
	
	//     Override to create and configure nodes for anchors added to the view's session.
	func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
		return nil
	}
	
	var landmarkNodes: [SCNNode] = []
	var locationNodes: [SCNNode] = []
	// Add these properties to your ViewController class
	var boundsNodes: [SCNNode] = []
	var boundsLineNodes: [SCNNode] = []

	// Add this method to create a line between two points
	func createLine(from start: simd_double3, to end: simd_double3, color: UIColor = UIColor.green) -> SCNNode {
		let vector = end - start
		let distance = simd_length(vector)
		
		// Create cylinder geometry for the line
		let cylinder = SCNCylinder(radius: 0.001, height: CGFloat(distance))
		cylinder.firstMaterial?.diffuse.contents = color
		
		let lineNode = SCNNode(geometry: cylinder)
		
		// Position the line at the midpoint
		let midpoint = (start + end) / 2
		lineNode.position = SCNVector3(midpoint.x, midpoint.y, midpoint.z)
		
		// Rotate the line to point from start to end
		let direction = simd_normalize(vector)
		let up = simd_double3(0, 1, 0)
		
		// Calculate rotation to align cylinder with the line direction
		if simd_length(simd_cross(up, direction)) > 0.001 {
			let axis = simd_normalize(simd_cross(up, direction))
			let angle = acos(simd_clamp(simd_dot(up, direction), -1.0, 1.0))
			lineNode.rotation = SCNVector4(axis.x, axis.y, axis.z, angle)
		}
		
		return lineNode
	}

	@MainActor
	func renderDebug() async {
		return
		// Remove existing nodes
		landmarkNodes.forEach { $0.removeFromParentNode() }
		landmarkNodes.removeAll()
		
//		boundsNodes.forEach { $0.removeFromParentNode() }
//		boundsNodes.removeAll()
//		
//		boundsLineNodes.forEach { $0.removeFromParentNode() }
//		boundsLineNodes.removeAll()
		
		let (landmarks, gpsObservations) = await (mapper.data.map.landmarks, mapper.data.gpsObservations)
		
		// Populate landmark nodes
		for landmark in prioritizedLandmarks(landmarks, max: 500) {
			let node = landmark.isMatched ? landmarkNode.clone() : unusedLandmarkNode.clone()
			let position: simd_double3 = landmark.position
			node.transform = transformFrom(position: position)
			mapNode.addChildNode(node)
			landmarkNodes.append(node)
			
//			if landmark.isMatched {
//				// Draw visibility bounds rectangle
//				let boundsLowerXZ = landmark.boundsLower
//				let boundsUpperXZ = landmark.boundsUpper
//								
//				// Draw lines from landmark position to bounds corners
//				let corners = [
//					simd_make_double3(boundsLowerXZ.x, 10, boundsLowerXZ.y), // bottom-left
//					simd_make_double3(boundsUpperXZ.x, 10, boundsLowerXZ.y), // bottom-right
//					simd_make_double3(boundsUpperXZ.x, 10, boundsUpperXZ.y), // top-right
//					simd_make_double3(boundsLowerXZ.x, 10, boundsUpperXZ.y)  // top-left
//				]
//				
//				for corner in corners {
//					let lineNode = createLine(from: position, to: corner)
//					mapNode.addChildNode(lineNode)
//					boundsLineNodes.append(lineNode)
//				}
//			}
		}
		
		// Populate location nodes
		for observation in gpsObservations.suffix(max(0,gpsObservations.count - locationNodes.count)) {
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
		let transform = mapNode.simdConvertTransform(frame.camera.transform, from: sceneView.scene.rootNode)
		let position = simd_make_float3(transform.columns.3)
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
//			await mapper?.processor.updateGlobalAlignment()
//			await renderDebug()
//			larNavigation.updateMapOverlays()
		}
	}
	
	// MARK: - Selection Management
	
	private func selectAnchorNode(_ node: LARSCNAnchorNode?) {
		// Deselect previously selected node
		if let previousId = selectedAnchorNode?.anchorId {
			larNavigation.setAnchorSelection(id: previousId, selected: false)
		}
		
		// Select new node
		selectedAnchorNode = node
		if let newId = node?.anchorId {
			larNavigation.setAnchorSelection(id: newId, selected: true)
		}
	}
	
	// MARK: - LARMapDelegate
	
	func map(_ map: LARMap, didAdd anchor: LARAnchor) {
		larNavigation.addNavigationPoint(anchor: anchor)
		if let selectedId = selectedAnchorNode?.anchorId {
			map.addEdge(from: selectedId, to: anchor.id)
			larNavigation.addNavigationEdge(from: selectedId, to: anchor.id)
		}
		if let newAnchorNode = larNavigation.getAnchorNode(id: anchor.id) {
			selectAnchorNode(newAnchorNode)
		}
//		Task(priority: .low) { await renderDebug() }
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
			larNavigation = LARNavigationManager(map: map, mapView: mapView, mapNode: mapNode)
			larNavigation.additionalMapDelegate = self
			await mapper.updateTracker()
		}
	}
	
	func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
		print("Document picker was cancelled")
	}
	
}
