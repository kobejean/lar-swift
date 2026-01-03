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

    // MARK: - Private State

    /// Base origin stored when tool activates - transforms are applied relative to this
    private var baseOrigin: simd_float4x4 = matrix_identity_float4x4

    /// Track cumulative scale for absolute scaling (C++ expects relative scale)
    private var currentScale: Double = 1.0

    // MARK: - Callbacks

    /// Called after rescaling completes, allowing UI to refresh visualizations (e.g., point cloud)
    var onRescaleComplete: (() -> Void)?

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
        // Store the current origin as baseline for transforms
        baseOrigin = mapRepository.origin()
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

    // MARK: - Public Methods

    /// Configure with a new base origin (call when map loads)
    func configure(baseOrigin: simd_float4x4) {
        self.baseOrigin = baseOrigin
    }

    // MARK: - Private Methods

    private func handleSideEffect(_ action: GPSAlignmentAction) async {
        switch action {
        case .applyAlignment:
            guard state.hasAdjustments else {
                dispatch(.setStatusMessage("No adjustments to apply"))
                return
            }

            // Build transform from current slider values
            let transform = createTransformFromCurrentValues()

            // Apply as absolute offset from base origin (not cumulative)
            let newOrigin = simd_mul(baseOrigin, transform)

            mapRepository.updateOrigin(newOrigin)
            renderingService.refreshAll()

            dispatch(.setStatusMessage("Alignment applied"))

        case .applyScale:
            let scaleFactor = state.scaleFactor

            guard scaleFactor > 0.0 else {
                dispatch(.setStatusMessage("Invalid scale factor: \(scaleFactor)"))
                return
            }

            // Convert absolute scale (user input) to relative scale (C++ expects)
            let relativeScale = scaleFactor / currentScale

            dispatch(.setStatusMessage("Applying scale: \(String(format: "%.2f", scaleFactor))..."))

            // Apply relative rescaling to C++ (which uses cumulative approach)
            if mapRepository.rescale(relativeScale) {
                // Update our tracked cumulative scale
                currentScale = scaleFactor

                renderingService.refreshAll()
                dispatch(.setStatusMessage("Scale factor \(String(format: "%.2f", scaleFactor)) applied"))

                // Notify that rescaling is complete (triggers point cloud reload)
                onRescaleComplete?()
            } else {
                dispatch(.setStatusMessage("Failed to apply scale - no map processor"))
            }

        case .performAutoAlignment:
            // Auto-alignment algorithm would be implemented here
            dispatch(.setStatusMessage("Auto-alignment complete"))

        case .reset:
            // Reset origin to base position
            mapRepository.updateOrigin(baseOrigin)
            currentScale = 1.0
            renderingService.refreshAll()

        default:
            break
        }
    }

    /// Create transform matrix from current slider values (matches old GPSAlignmentService)
    private func createTransformFromCurrentValues() -> simd_float4x4 {
        // Convert degrees to radians
        let ry = Float(state.rotation * .pi / 180)

        // Create rotation matrix around Y-axis (vertical axis for GPS heading)
        let rotY = simd_float4x4(
            simd_float4(cos(ry), 0, sin(ry), 0),
            simd_float4(0, 1, 0, 0),
            simd_float4(-sin(ry), 0, cos(ry), 0),
            simd_float4(0, 0, 0, 1)
        )

        // Create translation matrix (translation in meters)
        // X = East/West, Y = Up/Down, Z = North/South
        var translation = matrix_identity_float4x4
        translation.columns.3 = simd_float4(Float(state.translationX), 0, Float(state.translationY), 1)

        // Combine translation and rotation (translation applied THEN rotation)
        return simd_mul(translation, rotY)
    }
}
