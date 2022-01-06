//
//  InternalTracker.swift
//  
//
//  Created by Jean Flaherty on 6/1/21.
//

import Foundation
import ARKit
import OSLog

class InternalTracker: NSObject {
    
    var locationManager = LocationManager()
    var visionManager = VisionManager()
    var snapshotManager = SnapshotManager()
    
    var map = GeoARMap()
    var mapAnchor: GeoARMapAnchor?
    
    var state: GeoARTrackerState = .normal {
        didSet {
            guard let externalTracker = externalTracker else { return }
            externalTracker.internalDelegate?.tracker(externalTracker, didChange: state)
            externalTracker.delegate?.tracker(externalTracker, didChange: state)
        }
    }
    var mode: GeoARTrackerMode = .tracking
    
    weak var session: ARSession? {
        didSet {
            // Let world tracker own forwarder to retain it
            _sessionDelegateForwarder = ARSessionDelegateForwarder(
                internalDelegate: self, externalDelegate: session?.delegate)
            
            // Manage key value observers
            oldValue?.removeObserver(self, forKeyPath: "delegate")
            // Observe session delegate so that we can immediately replace it with our forwarder
            session?.addObserver(self, forKeyPath: "delegate", options: [.new, .old, .initial], context: nil)
        }
    }
    weak var delegate: InternalTrackerDelegate?
    weak var externalTracker: GeoARTracker?
    
    @available(iOS 14, *)
    lazy var logger = Logger(subsystem: "com.kobejean.GeoAR", category: "InternalTracker")
    
    
    // MARK: ARSessionInternalDelegate Proporties
    
    var isPausingDelegateCalls = false
    var isCallingDelegateManually = false
    
    // Needed to retain forwarder
    private var _sessionDelegateForwarder: ARSessionDelegateForwarder!
    
    var _snapNextFrame = false
    
    
    func run() {
        locationManager.requestAuthorization()
    }
    
    func setMap(_ map: GeoARMap) {
        if let mapAnchor = mapAnchor {
            session?.remove(anchor: mapAnchor)
        }
        
        // TODO: Figure out a cleaner solution
        _populateNavigationGraphs(anchors: map.anchors)
        
        self.map = map
        let mapAnchor = GeoARMapAnchor(transform: matrix_identity_float4x4, map: map)
        session?.add(anchor: mapAnchor)
        self.mapAnchor = mapAnchor
        state = .relocalizing
    }
    
    
    // MARK: Snap Frame
    
    func snapFrame() {
        _snapNextFrame = true
    }
    
    /// saved navigation graphs should have `adjacencyList` populated but we need to manually populate `vertices`
    private func _populateNavigationGraphs(anchors: [GeoARAnchor]) {
        let navigationGraphs = anchors.compactMap({ ($0 as? GeoARNavigationGraphAnchor)?.graph })
        let navigationAnchors = anchors.compactMap({ $0 as? GeoARNavigationAnchor })
        let vertices = Dictionary(uniqueKeysWithValues: navigationAnchors.map{ ($0.identifier, $0) })
        
        for navigationGraph in navigationGraphs {
            // Just add the vertices we need
            navigationGraph.vertices = vertices.filter({ navigationGraph.adjacencyList[$0.key] != nil })
        }
    }
    
    
    // MARK: Key Value Observation
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let session = object as? ARSession,
              let keyPath = keyPath,
              let newValue = change?[.newKey] else { return }
        
        switch keyPath {
        case "delegate":
            // Add back session delegate forwarder if delegate has been set to something else
            guard !(newValue is ARSessionDelegateForwarder) else { return }
            
            let newDelegate = newValue as? ARSessionDelegate
            _sessionDelegateForwarder.externalDelegate = newDelegate
            session.delegate = _sessionDelegateForwarder
        default:
            break
        }
    }
    
    
    // MARK: Initialization
    
    override init() {
        super.init()
        locationManager.tracker = self
        visionManager.tracker = self
    }
    
    
    // MARK: Deitialization
    
    deinit {
        session?.removeObserver(self, forKeyPath: "delegate")
    }
}
