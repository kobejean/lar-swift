//
//  LandmarkInspectionStrategy.swift
//  LARExplorer
//
//  Created by Assistant on 2025-09-19.
//

import Foundation
import SceneKit
import LocalizeAR

/// Strategy for inspecting landmarks
@MainActor
class LandmarkInspectionStrategy: ToolInteractionStrategy {
    private let landmarkInspectionService: LandmarkInspectionService
    private let explorerViewModel: LARExplorerViewModel
    private let hitTestManager = HitTestManager()

    init(landmarkInspectionService: LandmarkInspectionService,
         explorerViewModel: LARExplorerViewModel) {
        self.landmarkInspectionService = landmarkInspectionService
        self.explorerViewModel = explorerViewModel
    }

    func handleClick(at location: NSPoint, in sceneView: SCNView) {
        guard let result = hitTestManager.performHitTest(at: location, in: sceneView) else {
            // No hit - clear selection
            landmarkInspectionService.clearSelection()
            return
        }

        // Only handle landmark selections
        if case .landmark(let index) = result.type {
            // Get landmark from map data
            if let landmarks = explorerViewModel.mapData?.landmarks,
               index < landmarks.count {
                let landmark = landmarks[index]
                landmarkInspectionService.selectLandmark(landmark)
            }
        } else {
            // Hit something else - clear selection
            landmarkInspectionService.clearSelection()
        }
    }

    func deactivate() {
        // Clear selection when switching away from this tool
        landmarkInspectionService.clearSelection()
    }
}