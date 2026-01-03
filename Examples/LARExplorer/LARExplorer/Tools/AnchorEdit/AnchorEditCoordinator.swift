//
//  AnchorEditCoordinator.swift
//  LARExplorer
//
//  Created by Claude Code on 2026-01-04.
//

import Combine
import CoreLocation
import simd

/// Coordinator for the Anchor Edit tool
/// Manages selection, offset preview, and anchor modifications
@MainActor
final class AnchorEditCoordinator: ToolCoordinator, ObservableObject {
    // MARK: - Published State

    @Published private(set) var state = AnchorEditState.initial

    // MARK: - Dependencies

    private let mapRepository: MapRepository
    private let renderingService: RenderingService

    // MARK: - ToolCoordinator Properties

    let kind: ToolKind = .anchorEdit

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
        renderingService.hidePreviewNodes()
    }

    // MARK: - ToolCoordinator Input Handling

    func handleSceneClick(at point: CGPoint, hitAnchorId: Int32?, hitLandmarkId: Int?) {
        guard let anchorId = hitAnchorId else { return }
        dispatch(.toggleSelection(id: anchorId))
    }

    func handleMapClick(at coordinate: CLLocationCoordinate2D) {
        // Anchor edit doesn't respond to map clicks
    }

    // MARK: - Action Dispatch

    func dispatch(_ action: AnchorEditAction) {
        state = action.reduce(state)
        updateRendering()

        // Handle side effects asynchronously
        Task { await handleSideEffect(action) }
    }

    // MARK: - Private Methods

    private func updateRendering() {
        // Update anchor highlights
        if state.hasSelection {
            renderingService.highlightAnchors(state.selectedAnchorIds, style: .selected)
        } else {
            renderingService.clearAnchorHighlights()
        }

        // Update preview nodes
        if state.isPreviewingOffset && state.hasOffset {
            let positions = calculatePreviewPositions()
            renderingService.showPreviewNodes(at: positions)
        } else {
            renderingService.hidePreviewNodes()
        }
    }

    private func calculatePreviewPositions() -> [Int32: SIMD3<Float>] {
        var result: [Int32: SIMD3<Float>] = [:]
        for id in state.selectedAnchorIds {
            if let anchor = mapRepository.anchor(id: id) {
                result[id] = anchor.position + state.positionOffset
            }
        }
        return result
    }

    private func handleSideEffect(_ action: AnchorEditAction) async {
        switch action {
        case .applyOffset:
            guard state.canApplyOffset else { return }

            // Apply offset to all selected anchors
            for id in state.selectedAnchorIds {
                mapRepository.updateAnchorPosition(id: id, offset: state.positionOffset)
            }

            // Refresh rendering
            renderingService.refreshAll()

            // Clear selection and offset
            dispatch(.clearSelection)
            dispatch(.setOffset(.zero))

        case .deleteSelected:
            guard state.hasSelection else { return }

            // Delete all selected anchors
            for id in state.selectedAnchorIds {
                mapRepository.deleteAnchor(id: id)
            }

            // Refresh rendering
            renderingService.refreshAll()

            // Clear selection
            dispatch(.clearSelection)

        default:
            // Other actions don't have side effects
            break
        }
    }
}
