//
//  GeoARSCNView.swift
//  
//
//  Created by Jean Flaherty on 6/1/21.
//

import Foundation
import SceneKit
import ARKit

open class GeoARSCNView: ARSCNView {
    
    public struct DebugOptions: OptionSet {
        public let rawValue: Int

        public static let showLocationPoints = DebugOptions(rawValue: 1 << 0)
        public static let showFeaturePoints = DebugOptions(rawValue: 1 << 1)
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
    
    public var tracker = GeoARTracker()
    
    public var geoARDebugOptions: DebugOptions = []
    private let _debugRenderer = MapRenderer()
    
    
    // MARK: - Delegate Forwarding
    
    let delegateForwarder = ARSCNViewDelegateForwarder()
    public override weak var delegate: ARSCNViewDelegate? {
        set {
            delegateForwarder.externalDelegate = newValue
            super.delegate = delegateForwarder
        }
        get {
            return super.delegate
        }
    }
    
    // MARK: - Initialization
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        _setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }
    
    public override init(frame: CGRect, options: [String : Any]? = nil) {
        super.init(frame: frame, options: options)
        _setup()
    }
    
    private func _setup() {
        _debugRenderer.view = self
        // setup delegate forwarders
        delegateForwarder.internalDelegate = _debugRenderer
        super.delegate = delegateForwarder
        
        tracker.internalTracker.session = self.session
        tracker.internalTracker.delegate = _debugRenderer
        tracker.internalDelegate = _debugRenderer
    }
}
