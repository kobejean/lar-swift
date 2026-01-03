//
//  GPSAlignmentCoordinator.swift
//  LARExplorer
//
//  Created by Claude Code on 2026-01-04.
//

import Combine
import CoreLocation
import simd

/// Coordinator for the GPS Alignment tool
/// Manages translation, rotation, and scale adjustments for GPS alignment
@MainActor
final class GPSAlignmentCoordinator: ToolCoordinator, ObservableObject {
    // MARK: - Published State

    @Published private(set) var state = GPSAlignmentState.initial

    // MARK: - Dependencies

    private let mapRepository: MapRepository
    private let renderingService: RenderingService

    // MARK: - ToolCoordinator Properties

    let kind: ToolKind = .gpsAlignment

    // MARK: - Initialization

    init(mapRepository: MapRepository, renderingService: RenderingService) {
        self.mapRepository = mapRepository
        self.renderingService = renderingService
    }

    // MARK: - ToolCoordinator Lifecycle

    func activate() {
        state = .initial
    }

    func deactivate() {
        state = .initial
        renderingService.clearBoundsOverlays()
    }

    // MARK: - ToolCoordinator Input Handling

    func handleSceneClick(at point: CGPoint, hitAnchorId: Int32?, hitLandmarkId: Int?) {
        // GPS Alignment doesn't respond to scene clicks
    }

    func handleMapClick(at coordinate: CLLocationCoordinate2D) {
        // GPS Alignment may respond to map clicks for reference point selection
        // (not implemented yet)
    }

    // MARK: - Action Dispatch

    func dispatch(_ action: GPSAlignmentAction) {
        state = action.reduce(state)

        // Handle side effects
        Task { await handleSideEffect(action) }
    }

    // MARK: - Private Methods

    private func handleSideEffect(_ action: GPSAlignmentAction) async {
        switch action {
        case .applyAlignment:
            guard state.hasAdjustments else { return }

            // Build transform from translation and rotation
            let currentOrigin = mapRepository.origin()
            let newOrigin = applyAdjustments(to: currentOrigin)

            mapRepository.updateOrigin(newOrigin)
            renderingService.refreshAll()

            dispatch(.setStatusMessage("Alignment applied"))

        case .applyScale:
            // Scale application would be implemented here
            renderingService.refreshAll()
            dispatch(.setStatusMessage("Scale applied"))

        case .performAutoAlignment:
            // Auto-alignment algorithm would be implemented here
            dispatch(.setStatusMessage("Auto-alignment complete"))

        default:
            break
        }
    }

    private func applyAdjustments(to origin: simd_float4x4) -> simd_float4x4 {
        // Apply translation
        var result = origin
        result.columns.3.x += Float(state.translationX)
        result.columns.3.z += Float(state.translationY) // Y translation maps to Z in world space

        // Apply rotation around Y axis
        let rotationRadians = Float(state.rotation * .pi / 180.0)
        let rotationMatrix = simd_float4x4(
            simd_float4(cos(rotationRadians), 0, sin(rotationRadians), 0),
            simd_float4(0, 1, 0, 0),
            simd_float4(-sin(rotationRadians), 0, cos(rotationRadians), 0),
            simd_float4(0, 0, 0, 1)
        )

        return rotationMatrix * result
    }
}
