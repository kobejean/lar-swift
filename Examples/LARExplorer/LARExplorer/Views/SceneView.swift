//
//  SceneView.swift
//  LARExplorer
//
//  Created by Claude Code on 2025-06-30.
//

import SwiftUI
import AppKit
import SceneKit
import LocalizeAR

struct SceneView: NSViewRepresentable {
    @StateObject private var viewModel = SceneViewModel()
    let onSceneViewCreated: (SCNView, SCNNode) -> Void
    
    func makeNSView(context: Context) -> SCNView {
        let sceneView = SCNView()
        let scene = SCNScene()
        sceneView.scene = scene
        
        // Create map node
        let mapNode = SCNNode()
        scene.rootNode.addChildNode(mapNode)
        
        // Basic scene setup using configuration
        sceneView.backgroundColor = AppConfiguration.Scene.backgroundColor
        sceneView.allowsCameraControl = AppConfiguration.Scene.allowsCameraControl
        sceneView.showsStatistics = AppConfiguration.Scene.showsStatistics
        
        // Configure view model and notify parent
        DispatchQueue.main.async {
            viewModel.configure(sceneView: sceneView, mapNode: mapNode)
            onSceneViewCreated(sceneView, mapNode)
        }
        
        return sceneView
    }
    
    func updateNSView(_ sceneView: SCNView, context: Context) {
        // Update scene view if needed
    }
    
    // MARK: - Public Interface
    func loadPointCloud(from map: LARMap) {
        viewModel.loadPointCloud(from: map)
    }
    
    func togglePointCloudVisibility() {
        viewModel.togglePointCloudVisibility()
    }
}
