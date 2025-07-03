//
//  SceneViewModel.swift
//  LARExplorer
//
//  Created by Jean Flaherty on 2025-06-30.
//

import SwiftUI
import SceneKit
import LocalizeAR

@MainActor
class SceneViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isPointCloudVisible = true
    @Published var visualizationState: LocalizationVisualization.State = .empty {
        didSet {
            updateLandmarkHighlights()
        }
    }
    
    // MARK: - Internal Properties
    private weak var sceneView: SCNView?
    private weak var mapNode: SCNNode?
    private var pointCloudRenderer: PointCloudRenderer?
    
    // MARK: - Configuration
    func configure(sceneView: SCNView, mapNode: SCNNode) {
        self.sceneView = sceneView
        self.mapNode = mapNode
        self.pointCloudRenderer = PointCloudRenderer()
        
        do {
            try setupSceneView()
        } catch {
            print("SceneViewModel: Failed to setup scene: \(error)")
        }
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
    
    private func updateLandmarkHighlights() {
        guard let mapNode = mapNode,
              let renderer = pointCloudRenderer,
              let sceneView = sceneView else { return }
        
        if let highlights = visualizationState.highlights {
            renderer.highlightLandmarks(
                spatialQueryIds: highlights.spatialQueryIds,
                matchIds: highlights.matchIds,
                inlierIds: highlights.inlierIds,
                in: mapNode,
                landmarks: highlights.landmarks,
                sceneView: sceneView
            )
        } else {
            renderer.clearLandmarkHighlights(in: mapNode)
        }
    }
    
    func updateVisualization(state: LocalizationVisualization.State) {
        visualizationState = state
    }
    
    func clearLandmarkHighlights() {
        visualizationState = .empty
    }
    
    // MARK: - Private Methods
    private func setupSceneView() throws {
        guard let sceneView = sceneView else {
            throw SceneViewModelError.sceneViewNotConfigured
        }
        
        sceneView.backgroundColor = NSColor.black
        sceneView.preferredFramesPerSecond = 60
        sceneView.allowsCameraControl = true
        sceneView.showsStatistics = true
        
        try setupLighting()
        try setupCamera()
    }
    
    private func setupLighting() throws {
        guard let scene = sceneView?.scene else {
            throw SceneViewModelError.sceneNotAvailable
        }
        
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = 300
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        scene.rootNode.addChildNode(ambientLightNode)
    }
    
    private func setupCamera() throws {
        guard let scene = sceneView?.scene else {
            throw SceneViewModelError.sceneNotAvailable
        }
        
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

// MARK: - Error Types
enum SceneViewModelError: LocalizedError {
    case sceneViewNotConfigured
    case sceneNotAvailable
    
    var errorDescription: String? {
        switch self {
        case .sceneViewNotConfigured:
            return "SceneView not properly configured"
        case .sceneNotAvailable:
            return "Scene not available for setup"
        }
    }
}
