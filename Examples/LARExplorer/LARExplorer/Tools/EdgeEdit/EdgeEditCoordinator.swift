//
//  EdgeEditCoordinator.swift
//  LARExplorer
//
//  Created by Claude Code on 2026-01-04.
//

import Combine
import CoreLocation
import simd

/// Coordinator for the Edge Edit tool
/// Manages the two-click edge creation/removal flow
@MainActor
final class EdgeEditCoordinator: ToolCoordinator, ObservableObject {
    // MARK: - Published State

    @Published private(set) var state = EdgeEditState.initial

    // MARK: - Dependencies

    private let mapRepository: MapRepository
    private let renderingService: RenderingService

    // MARK: - ToolCoordinator Properties

    let kind: ToolKind = .edgeEdit

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
        renderingService.clearAnchorHighlights()
        renderingService.clearEdgeHighlights()
    }

    // MARK: - ToolCoordinator Input Handling

    func handleSceneClick(at point: CGPoint, hitAnchorId: Int32?, hitLandmarkId: Int?) {
        if let anchorId = hitAnchorId {
            dispatch(.clickAnchor(id: anchorId))
        } else {
            // Click on empty space cancels edge creation
            dispatch(.cancelEdgeCreation)
        }
    }

    func handleMapClick(at coordinate: CLLocationCoordinate2D) {
        // Edge edit doesn't respond to map clicks
    }

    // MARK: - Action Dispatch

    func dispatch(_ action: EdgeEditAction) {
        let (newState, sideEffect) = action.reduce(state)
        state = newState
        updateRendering()

        // Handle side effects
        if let effect = sideEffect {
            Task { await handleSideEffect(effect) }
        }
    }

    // MARK: - Private Methods

    private func updateRendering() {
        // Highlight source anchor if awaiting target
        if let sourceId = state.sourceAnchorId {
            renderingService.highlightAnchors([sourceId], style: .selected)
        } else {
            renderingService.clearAnchorHighlights()
        }
    }

    private func handleSideEffect(_ action: EdgeEditAction) async {
        switch action {
        case .toggleEdge(let fromId, let toId):
            // Check if edge exists and toggle
            if mapRepository.edgeExists(from: fromId, to: toId) {
                mapRepository.removeEdge(from: fromId, to: toId)
            } else {
                mapRepository.addEdge(from: fromId, to: toId)
            }

            // Refresh rendering
            renderingService.refreshAll()

        default:
            break
        }
    }
}
