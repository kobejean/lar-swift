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
    @ObservedObject var landmarkInspectionService: LandmarkInspectionService
    @ObservedObject var explorerViewModel: LARExplorerViewModel
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
        Coordinator(editingService: editingService, landmarkInspectionService: landmarkInspectionService, explorerViewModel: explorerViewModel)
    }
    
    class Coordinator: NSObject {
        let editingService: EditingService
        let landmarkInspectionService: LandmarkInspectionService
        let explorerViewModel: LARExplorerViewModel

        init(editingService: EditingService, landmarkInspectionService: LandmarkInspectionService, explorerViewModel: LARExplorerViewModel) {
            self.editingService = editingService
            self.landmarkInspectionService = landmarkInspectionService
            self.explorerViewModel = explorerViewModel
        }
        
        func handleClick(at location: NSPoint, in sceneView: SCNView) {
            Task { @MainActor in
                print("Click detected at \(location), current tool: \(editingService.selectedTool)")

                // Hit test only anchor nodes using category bit mask
                let anchorHitTestOptions: [SCNHitTestOption: Any] = [
                    .categoryBitMask: LARSCNAnchorNode.anchorCategory,
                    .firstFoundOnly: true
                ]
                let anchorHitResults = sceneView.hitTest(location, options: anchorHitTestOptions)
                print("Anchor hit test found \(anchorHitResults.count) results")

                if let hitResult = anchorHitResults.first, let anchorNode = hitResult.node as? LARSCNAnchorNode {
                    print("Anchor hit: \(anchorNode.anchorId)")
                    await handleAnchorClick(anchorNode.anchorId)
                    return
                }

                // If no anchor hit and in landmark inspection mode, try landmark hit test
                if editingService.selectedTool == .inspectLandmarks {
                    print("Trying landmark hit test")
                    await handleLandmarkClick(at: location, in: sceneView)
                } else {
                    print("Not in landmark inspection mode, click ignored")
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

        @MainActor
        private func handleLandmarkClick(at location: NSPoint, in sceneView: SCNView) {
            print("Handling landmark click at \(location)")

            // Hit test landmark nodes directly using their category
            let landmarkHitTestOptions: [SCNHitTestOption: Any] = [
                .categoryBitMask: PointCloudRenderer.landmarkHitTestCategory,
                .firstFoundOnly: true
            ]
            let landmarkHitResults = sceneView.hitTest(location, options: landmarkHitTestOptions)
            print("Landmark hit test found \(landmarkHitResults.count) results")

            if let hitResult = landmarkHitResults.first,
               let landmarks = explorerViewModel.mapData?.landmarks,
               let nodeName = hitResult.node.name,
               nodeName.hasPrefix("landmark_") {

                print("Hit landmark node: \(nodeName)")

                // Extract landmark index from node name
                let indexString = String(nodeName.dropFirst("landmark_".count))
                if let landmarkIndex = Int(indexString), landmarkIndex < landmarks.count {
                    let landmark = landmarks[landmarkIndex]
                    print("Selected landmark at index \(landmarkIndex), ID: \(landmark.id)")
                    landmarkInspectionService.selectLandmark(landmark)
                } else {
                    print("Invalid landmark index: \(indexString)")
                    landmarkInspectionService.clearSelection()
                }
            } else {
                print("No landmark hit or no current map")
                // Clear selection if no hit
                landmarkInspectionService.clearSelection()
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
