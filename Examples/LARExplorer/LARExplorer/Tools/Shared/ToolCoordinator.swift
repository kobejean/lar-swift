//
//  ToolCoordinator.swift
//  LARExplorer
//
//  Created by Claude Code on 2026-01-04.
//

import Foundation
import CoreLocation
import SwiftUI

// MARK: - ToolKind

/// Enumeration of available tools in LARExplorer
/// This replaces the old ExplorerTool enum with a more domain-focused name
enum ToolKind: String, CaseIterable, Identifiable {
    case explore = "Explore"
    case anchorEdit = "Edit Anchors"
    case edgeEdit = "Edit Edges"
    case gpsAlignment = "Align GPS"
    case relocalization = "Test Relocalization"
    case landmarks = "Inspect Landmarks"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .explore: return "location"
        case .anchorEdit: return "circle.grid.cross"
        case .edgeEdit: return "line.diagonal"
        case .gpsAlignment: return "location.north.line"
        case .relocalization: return "camera.viewfinder"
        case .landmarks: return "scope"
        }
    }
}

// MARK: - ToolCoordinator Protocol

/// Base protocol for all tool coordinators
/// Each tool implements this protocol to handle its specific interactions
@MainActor
protocol ToolCoordinator: AnyObject, ObservableObject {
    /// The kind of tool this coordinator manages
    var kind: ToolKind { get }

    /// Called when this tool becomes the active tool
    func activate()

    /// Called when switching away from this tool
    func deactivate()

    /// Handle a click/tap in the 3D scene view
    /// - Parameters:
    ///   - point: The screen coordinates of the click
    ///   - hitAnchorId: The ID of the anchor that was hit (if any)
    ///   - hitLandmarkId: The ID of the landmark that was hit (if any)
    func handleSceneClick(at point: CGPoint, hitAnchorId: Int32?, hitLandmarkId: Int?)

    /// Handle a click/tap on the 2D map view
    /// - Parameter coordinate: The geographic coordinate that was clicked
    func handleMapClick(at coordinate: CLLocationCoordinate2D)
}

// MARK: - Default Implementations

extension ToolCoordinator {
    /// Default implementation - most tools don't need map clicks
    func handleMapClick(at coordinate: CLLocationCoordinate2D) {
        // No-op by default
    }

    /// Default implementation - most tools don't use landmark hits
    func handleSceneClick(at point: CGPoint, hitAnchorId: Int32?, hitLandmarkId: Int?) {
        // Subclasses should override if they need click handling
    }
}

// MARK: - AnyToolCoordinator (Type Erasure)

/// Type-erased wrapper for ToolCoordinator to allow heterogeneous collections
@MainActor
final class AnyToolCoordinator: ObservableObject {
    let kind: ToolKind

    private let _activate: @MainActor () -> Void
    private let _deactivate: @MainActor () -> Void
    private let _handleSceneClick: @MainActor (CGPoint, Int32?, Int?) -> Void
    private let _handleMapClick: @MainActor (CLLocationCoordinate2D) -> Void

    init<T: ToolCoordinator>(_ coordinator: T) {
        self.kind = coordinator.kind
        self._activate = { coordinator.activate() }
        self._deactivate = { coordinator.deactivate() }
        self._handleSceneClick = { point, anchorId, landmarkId in
            coordinator.handleSceneClick(at: point, hitAnchorId: anchorId, hitLandmarkId: landmarkId)
        }
        self._handleMapClick = { coordinate in
            coordinator.handleMapClick(at: coordinate)
        }
    }

    func activate() { _activate() }
    func deactivate() { _deactivate() }
    func handleSceneClick(at point: CGPoint, hitAnchorId: Int32?, hitLandmarkId: Int?) {
        _handleSceneClick(point, hitAnchorId, hitLandmarkId)
    }
    func handleMapClick(at coordinate: CLLocationCoordinate2D) {
        _handleMapClick(coordinate)
    }
}
