//
//  RelocalizationCoordinator.swift
//  LARExplorer
//
//  Created by Claude Code on 2026-01-04.
//

import Combine
import CoreLocation
import simd

/// Coordinator for the Relocalization tool
/// Manages frame selection, localization testing, and result visualization
@MainActor
final class RelocalizationCoordinator: ToolCoordinator, ObservableObject {
    // MARK: - Published State

    @Published private(set) var state = RelocalizationState.initial

    // MARK: - Dependencies

    private let mapRepository: MapRepository
    private let renderingService: RenderingService

    // MARK: - ToolCoordinator Properties

    let kind: ToolKind = .relocalization

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
        // Relocalization doesn't respond to scene clicks
    }

    func handleMapClick(at coordinate: CLLocationCoordinate2D) {
        // Relocalization doesn't respond to map clicks
    }

    // MARK: - Action Dispatch

    func dispatch(_ action: RelocalizationAction) {
        state = action.reduce(state)
        updateRendering()

        // Handle side effects
        Task { await handleSideEffect(action) }
    }

    // MARK: - Private Methods

    private func updateRendering() {
        // Visualize localization results if available
        guard let result = state.lastResult else {
            renderingService.clearLandmarkHighlights()
            return
        }

        // Show different highlight styles for different landmark groups
        // Note: We'd need multiple calls to show different styles
        // For now, highlight inliers as they're the most important
        if !result.inlierIds.isEmpty {
            renderingService.highlightLandmarks(result.inlierIds, style: .inlier)
        } else if !result.matchedIds.isEmpty {
            renderingService.highlightLandmarks(result.matchedIds, style: .matched)
        } else if !result.spatialQueryIds.isEmpty {
            renderingService.highlightLandmarks(result.spatialQueryIds, style: .spatialQuery)
        } else {
            renderingService.clearLandmarkHighlights()
        }
    }

    private func handleSideEffect(_ action: RelocalizationAction) async {
        switch action {
        case .loadFrames:
            // Frame loading logic would be implemented here
            // This would scan the directory and count available frames
            break

        case .performLocalization:
            guard state.canLocalize else { return }

            dispatch(.startLocalizing)

            // Actual localization would be performed here
            // For now, simulate completion
            // In production, this would call into the localization service

        default:
            break
        }
    }
}
