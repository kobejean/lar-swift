//
//  GeoARView.swift
//  
//
//  Created by Jean Flaherty on 6/12/21.
//

import Foundation
import RealityKit
import ARKit


open class GeoARView: ARView {
    
    public struct DebugOptions: OptionSet {
        public let rawValue: Int

        public static let showLocationAnchors = DebugOptions(rawValue: 1 << 0)
        public static let showFeaturePoints = DebugOptions(rawValue: 1 << 1)
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
    
    public var tracker = GeoARTracker()
    
    public var geoARDebugOptions: DebugOptions = []
    private let _debugRenderer = DebugRenderer()
    
    
    // MARK: - Initialization
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        _setup()
    }
    
    public required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        _setup()
    }
    
    private func _setup() {
        self._debugRenderer.view = self
        // RealityKit doesn't seem to work on the simulator
//        #if !targetEnvironment(simulator)
//        tracker.internalTracker.session = self.session
//        #endif
//        tracker.internalTracker.delegate = self._debugRenderer
    }
}
