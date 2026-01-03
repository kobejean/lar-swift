//
//  LandmarksCoordinator.swift
//  LARExplorer
//
//  Created by Claude Code on 2026-01-04.
//

import Combine
import CoreLocation
import simd

/// Coordinator for the Landmarks tool
/// Manages landmark selection and display
@MainActor
final class LandmarksCoordinator: ToolCoordinator, ObservableObject {
    // MARK: - Published State

    @Published private(set) var state = LandmarksState.initial

    // MARK: - Dependencies

    private let mapRepository: MapRepository
    private let renderingService: RenderingService

    // MARK: - ToolCoordinator Properties

    let kind: ToolKind = .landmarks

    // MARK: - Initialization

    init(mapRepository: MapRepository, renderingService: RenderingService) {
        self.mapRepository = mapRepository
        self.renderingService = renderingService
    }

    // MARK: - ToolCoordinator Lifecycle

    func activate() {
        state = .initial
        updateRendering()
    }

    func deactivate() {
        state = .initial
        renderingService.clearLandmarkHighlights()
    }

    // MARK: - ToolCoordinator Input Handling

    func handleSceneClick(at point: CGPoint, hitAnchorId: Int32?, hitLandmarkId: Int?) {
        if let landmarkId = hitLandmarkId {
            dispatch(.selectLandmark(id: landmarkId))
        } else {
            dispatch(.clearSelection)
        }
    }

    func handleMapClick(at coordinate: CLLocationCoordinate2D) {
        // Landmarks tool doesn't respond to map clicks
    }

    // MARK: - Action Dispatch

    func dispatch(_ action: LandmarksAction) {
        state = action.reduce(state)
        updateRendering()
    }

    // MARK: - Private Methods

    private func updateRendering() {
        if let selectedId = state.selectedLandmarkId {
            renderingService.highlightLandmarks([selectedId], style: .selected)
        } else {
            renderingService.clearLandmarkHighlights()
        }
    }
}
