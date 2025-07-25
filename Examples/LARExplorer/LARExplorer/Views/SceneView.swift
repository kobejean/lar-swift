//
//  SceneView.swift
//  LARExplorer
//
//  Created by Jean Flaherty on 2025-06-30.
//

import SwiftUI
import AppKit
import SceneKit
import LocalizeAR

struct SceneView: NSViewRepresentable {
    @StateObject private var viewModel = SceneViewModel()
    @ObservedObject var editingService: EditingService
    let onSceneViewCreated: (SCNView, SCNNode, SceneViewModel) -> Void
    
    func makeNSView(context: Context) -> SCNView {
        let scene = SCNScene()
        
        // Create map node
        let mapNode = SCNNode()
        scene.rootNode.addChildNode(mapNode)
        
        // Create custom scene view that handles mouse events
        let customSceneView = ClickableSceneView(coordinator: context.coordinator)
        customSceneView.scene = scene
        customSceneView.backgroundColor = AppConfiguration.Scene.backgroundColor
        customSceneView.allowsCameraControl = AppConfiguration.Scene.allowsCameraControl
        customSceneView.showsStatistics = AppConfiguration.Scene.showsStatistics
        
        // Configure view model and notify parent
        DispatchQueue.main.async {
            viewModel.configure(sceneView: customSceneView, mapNode: mapNode)
            onSceneViewCreated(customSceneView, mapNode, viewModel)
        }
        
        return customSceneView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(editingService: editingService)
    }
    
    class Coordinator: NSObject {
        let editingService: EditingService
        
        init(editingService: EditingService) {
            self.editingService = editingService
        }
        
        func handleClick(at location: NSPoint, in sceneView: SCNView) {
            Task { @MainActor in
                // Hit test only anchor nodes using category bit mask
                let hitTestOptions: [SCNHitTestOption: Any] = [
                    .categoryBitMask: LARSCNAnchorNode.anchorCategory,
                    .firstFoundOnly: true
                ]
                let hitResults = sceneView.hitTest(location, options: hitTestOptions)
                
                if let hitResult = hitResults.first, let anchorNode = hitResult.node as? LARSCNAnchorNode {
                    await handleAnchorClick(anchorNode.anchorId)
                }
            }
        }
        
        @MainActor
        private func handleAnchorClick(_ anchorId: Int32) {
            switch editingService.selectedTool {
            case .editAnchors:
                editingService.selectAnchor(id: anchorId)
            case .editEdges:
                editingService.handleAnchorClickForEdgeCreation(anchorId)
            default:
                break
            }
        }
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
    
    
    // MARK: - ViewModel Access
    var sceneViewModel: SceneViewModel {
        return viewModel
    }
}

// Custom SCNView that properly handles mouse events
class ClickableSceneView: SCNView {
    weak var coordinator: SceneView.Coordinator?
    
    init(coordinator: SceneView.Coordinator) {
        self.coordinator = coordinator
        super.init(frame: .zero, options: nil)
    }
    
    override init(frame: NSRect, options: [String : Any]?) {
        super.init(frame: frame, options: options)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        let location = convert(event.locationInWindow, from: nil)
        coordinator?.handleClick(at: location, in: self)
    }
}
