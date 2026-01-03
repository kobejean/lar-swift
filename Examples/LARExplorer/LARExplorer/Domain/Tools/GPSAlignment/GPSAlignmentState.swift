//
//  GPSAlignmentState.swift
//  LARExplorer
//
//  Created by Claude Code on 2026-01-04.
//

import Foundation

// MARK: - State

/// Pure value type representing the state of GPS alignment
struct GPSAlignmentState: Equatable {
    /// Translation offset in X (East/West) in meters
    var translationX: Double = 0.0

    /// Translation offset in Y (North/South) in meters
    var translationY: Double = 0.0

    /// Rotation around vertical axis in degrees
    var rotation: Double = 0.0

    /// Scale factor for map
    var scaleFactor: Double = 1.0

    /// Status message for user feedback
    var statusMessage: String?

    /// Initial state factory
    static let initial = GPSAlignmentState()

    // MARK: - Computed Properties

    /// Whether any alignment adjustments have been made
    var hasAdjustments: Bool {
        translationX != 0.0 || translationY != 0.0 || rotation != 0.0 || scaleFactor != 1.0
    }
}

// MARK: - Actions

/// Actions that can modify GPSAlignmentState
enum GPSAlignmentAction: Equatable {
    // Translation actions
    case setTranslationX(Double)
    case setTranslationY(Double)

    // Rotation action
    case setRotation(Double)

    // Scale action
    case setScaleFactor(Double)

    // Reset action
    case reset

    // Status message
    case setStatusMessage(String?)

    // Side effect triggers (state unchanged, coordinator handles)
    case applyAlignment
    case applyScale
    case performAutoAlignment
}

// MARK: - Reducer

extension GPSAlignmentAction {
    /// Pure function that computes the next state from an action
    func reduce(_ state: GPSAlignmentState) -> GPSAlignmentState {
        var newState = state

        switch self {
        case .setTranslationX(let value):
            newState.translationX = value

        case .setTranslationY(let value):
            newState.translationY = value

        case .setRotation(let value):
            newState.rotation = value

        case .setScaleFactor(let value):
            newState.scaleFactor = value

        case .reset:
            newState = GPSAlignmentState.initial

        case .setStatusMessage(let message):
            newState.statusMessage = message

        case .applyAlignment, .applyScale, .performAutoAlignment:
            // Side effect actions - no state change
            break
        }

        return newState
    }
}
