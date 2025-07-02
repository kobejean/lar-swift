//
//  SceneViewModel.swift
//  LARExplorer
//
//  Created by Claude Code on 2025-06-30.
//

import SwiftUI
import SceneKit
import LocalizeAR

@MainActor
class SceneViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isPointCloudVisible = true
    
    // MARK: - Internal Properties
    private weak var sceneView: SCNView?
    private weak var mapNode: SCNNode?
    private var pointCloudRenderer: PointCloudRenderer?
    
    // MARK: - Configuration
    func configure(sceneView: SCNView, mapNode: SCNNode) {
        self.sceneView = sceneView
        self.mapNode = mapNode
        self.pointCloudRenderer = PointCloudRenderer()
        setupSceneView()
    }
    
    func loadPointCloud(from map: LARMap) {
        guard let mapNode = mapNode,
              let renderer = pointCloudRenderer else { return }
        
        Task {
            await renderer.loadPointCloud(
                from: map,
                into: mapNode,
                progressHandler: { progress in
                    print("Point cloud loading: \(Int(progress * 100))%")
                }
            )
        }
    }
    
    func togglePointCloudVisibility() {
        isPointCloudVisible.toggle()
        mapNode?.childNode(withName: AppConfiguration.PointCloud.containerNodeName, recursively: false)?.isHidden = !isPointCloudVisible
    }
    
    // MARK: - Private Methods
    private func setupSceneView() {
        guard let sceneView = sceneView else { return }
        
        sceneView.backgroundColor = NSColor.black
        sceneView.preferredFramesPerSecond = 60
        sceneView.allowsCameraControl = true
        sceneView.showsStatistics = true
        
        setupLighting()
        setupCamera()
    }
    
    private func setupLighting() {
        guard let scene = sceneView?.scene else { return }
        
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = 300
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        scene.rootNode.addChildNode(ambientLightNode)
    }
    
    private func setupCamera() {
        guard let scene = sceneView?.scene else { return }
        
        let camera = SCNCamera()
        camera.zNear = 0.1
        camera.zFar = 10000.0
        camera.fieldOfView = 60
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 10, 0)
        cameraNode.look(at: SCNVector3Zero)
        scene.rootNode.addChildNode(cameraNode)
    }
}