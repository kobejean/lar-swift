/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main view controller for the AR experience.
*/

import UIKit
import MapKit
import SceneKit
import ARKit
import LocalAR

class ViewController: UIViewController {
    // MARK: - IBOutlets
    
    static var instance: ViewController?
    
    @IBOutlet weak var sessionInfoView: UIView!
    @IBOutlet weak var sessionInfoLabel: UILabel!
    @IBOutlet weak var sceneView: GeoARSCNView!
    @IBOutlet weak var saveExperienceButton: UIButton!
    @IBOutlet weak var loadExperienceButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var isRelocalizingMap = false
    var mapRegionIsMovedProgramatically = false
    var mapRegionIsMovedByUser = false
    var mapRegionFreezeTimer: Timer?
    var lastUserLocation: CLLocation?
    var lastTrackerState: GeoARTrackerState = .initializing

    var defaultConfiguration: ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        if #available(iOS 14.0, *) {
            configuration.frameSemantics = .smoothedSceneDepth
        }
        configuration.environmentTexturing = .automatic
        configuration.worldAlignment = .gravity
        return configuration
    }
    var userLocationAnnotation: MKPointAnnotation?
    var navigationNodeOverlays = [GeoARMKNavigationNodeOverlay]()
    var navigationGuideNodeOverlays = [GeoARMKNavigationGuideNodeOverlay]()
    
    // MARK: - View Life Cycle
    
    // Lock the orientation of the app to the orientation in which it is launched
    override var shouldAutorotate: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Read in any already saved map to see if we can load one.
        if mapJsonDataFromFile != nil {
            self.loadExperienceButton.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("""
                ARKit is not available on this device. For apps that require ARKit
                for core functionality, use the `arkit` key in the key in the
                `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
                the app from installing. (If the app can't be installed, this error
                can't be triggered in a production scenario.)
                In apps where AR is an additive feature, use `isSupported` to
                determine whether to show UI for launching AR experiences.
            """) // For details, see https://developer.apple.com/documentation/arkit
        }
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 1, maxCenterCoordinateDistance: 80)
        mapView.userTrackingMode = .follow//WithHeading
        
        sceneView.tracker.locationManager.delegate = self
        
        // Start the view's AR session.
        sceneView.session.delegate = self
        sceneView.session.run(defaultConfiguration)
        
        sceneView.debugOptions = [ .showWorldOrigin, .showFeaturePoints ]
        sceneView.geoARDebugOptions = [ .showFeaturePoints, .showLocationPoints ]
        
        // Prevent the screen from being dimmed after a while as users will likely
        // have long periods of interaction without touching the screen or buttons.
        UIApplication.shared.isIdleTimerDisabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ViewController.instance = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's AR session.
        sceneView.session.pause()
    }
    
    
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
    }
    
    // MARK: - Persistence: Saving and Loading
    lazy var mapSaveURL: URL = {
        do {
            return try FileManager.default
                .url(for: .documentDirectory,
                     in: .userDomainMask,
                     appropriateFor: nil,
                     create: true)
                .appendingPathComponent("map.arexperience")
        } catch {
            fatalError("Can't get file save URL: \(error.localizedDescription)")
        }
    }()
    lazy var mapJsonSaveURL: URL = {
        do {
            return try FileManager.default
                .url(for: .documentDirectory,
                     in: .userDomainMask,
                     appropriateFor: nil,
                     create: true)
                .appendingPathComponent("map.json")
        } catch {
            fatalError("Can't get file save URL: \(error.localizedDescription)")
        }
    }()
    
    /// - Tag: GetWorldMap
    @IBAction func saveExperience(_ button: UIButton) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            let path = self.sceneView.tracker.save()
            guard let mapPath = path?.appendingPathComponent("map.json").path,
                  let frame = self.sceneView.session.currentFrame
            else { return }
            let map = LARMap(fromFile: mapPath)
            let tracker = LARTracking(map: map)
            let positions = map.landmarks.map { landmark in landmark.position }
            guard let transform = tracker.localize(frame: frame) else { return }
            print("transform: \(transform)")
            print("positions.count: \(positions.count)")
            print("positions[0]: \(positions[0])")
        }
    }
    
    
    @IBAction func snapFrame(_ button: UIButton) {
        sceneView.tracker.snapFrame()
    }
    
    // Called opportunistically to verify that map data can be loaded from filesystem.
    var mapDataFromFile: Data? {
        return try? Data(contentsOf: mapSaveURL)
    }
    
    // Called opportunistically to verify that map data can be loaded from filesystem.
    var mapJsonDataFromFile: Data? {
        return try? Data(contentsOf: mapJsonSaveURL)
    }
    
    /// - Tag: RunWithWorldMap
    @IBAction func loadExperience(_ button: UIButton) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let map: GeoARMap = {
                guard let data = self.mapJsonDataFromFile
                    else { fatalError("Map data should already be verified to exist before Load button is enabled.") }
                do {
                    let decoder = JSONDecoder()
                    let map = try decoder.decode(GeoARMap.self, from: data)
                    return map
                } catch {
                    fatalError("Can't unarchive ARWorldMap from file data: \(error)")
                }
            }()
        
            self.sceneView.tracker.setMap(map)
            DispatchQueue.main.async {
                self.displayNavigationMapOverlays(map: map)
            }
        }
    }

    func displayNavigationMapOverlays(map: GeoARMap) {
        mapView.removeOverlays(navigationNodeOverlays)
        mapView.removeOverlays(navigationGuideNodeOverlays)
        
        let navigationNodeTransforms = map.anchors.compactMap({ ($0 as? GeoARNavigationAnchor)?.transform })
        let navigationNodeLocations = map.locationsForTransforms(navigationNodeTransforms)
        navigationNodeOverlays = navigationNodeLocations.map({ GeoARMKNavigationNodeOverlay(coordinate: $0.coordinate) })
        mapView.addOverlays(navigationNodeOverlays)
        
        let navigationGraphs = map.anchors.compactMap({ ($0 as? GeoARNavigationGraphAnchor)?.graph })
        navigationGuideNodeOverlays = [GeoARMKNavigationGuideNodeOverlay]()
        
        for navigationGraph in navigationGraphs {
            let transforms = navigationGraph.trail()
            let coordinates = map.locationsForTransforms(transforms).map({ $0.coordinate })
            let overlays = coordinates.map({ GeoARMKNavigationGuideNodeOverlay(coordinate: $0) })
            navigationGuideNodeOverlays.append(contentsOf: overlays)
        }
        mapView.addOverlays(navigationGuideNodeOverlays)
        
    }
    
    // MARK: - Placing AR Content
    
    /// - Tag: PlaceObject
    @IBAction func handleSceneTap(_ sender: UITapGestureRecognizer) {
        // Hit test to find a place for a virtual object.
        guard let hitTestResult = sceneView
            .hitTest(sender.location(in: sceneView), types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
            .first
        else { return }
        let navigationAnchor = GeoARNavigationAnchor(transform: hitTestResult.worldTransform)
        if navigationGraph.start == nil {
            navigationGraph.start = navigationAnchor.identifier
            sourceNavigationAnchor = navigationAnchor
        }
        if let currentNavigationAnchor = currentNavigationAnchor {
            navigationGraph.add(from: currentNavigationAnchor, to: navigationAnchor)
        }
        currentNavigationAnchor = navigationAnchor
        navigationGraph.end = navigationAnchor.identifier
        sceneView.tracker.add(anchor: navigationAnchor)
        
        self.displayNavigationMapOverlays(map: sceneView.tracker.map)
    }
    
    var navigationGraph = GeoARNavigationGraph()
    var sourceNavigationAnchor: GeoARNavigationAnchor?
    var currentNavigationAnchor: GeoARNavigationAnchor?
    
}

