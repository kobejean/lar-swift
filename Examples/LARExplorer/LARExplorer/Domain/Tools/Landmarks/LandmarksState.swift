//
//  LandmarksState.swift
//  LARExplorer
//
//  Created by Claude Code on 2026-01-04.
//

import Foundation

// MARK: - State

/// Pure value type representing the state of landmark inspection
/// This is a simple read-only selection tool
struct LandmarksState: Equatable {
    /// The selected landmark ID (nil if none selected)
    var selectedLandmarkId: Int?

    /// Initial state factory
    static let initial = LandmarksState()

    // MARK: - Computed Properties

    /// Whether a landmark is currently selected
    var hasSelection: Bool { selectedLandmarkId != nil }
}

// MARK: - Actions

/// Actions that can modify LandmarksState
enum LandmarksAction: Equatable {
    /// Select a landmark by ID
    case selectLandmark(id: Int)

    /// Clear the current selection
    case clearSelection
}

// MARK: - Reducer

extension LandmarksAction {
    /// Pure function that computes the next state from an action
    func reduce(_ state: LandmarksState) -> LandmarksState {
        var newState = state

        switch self {
        case .selectLandmark(let id):
            newState.selectedLandmarkId = id

        case .clearSelection:
            newState.selectedLandmarkId = nil
        }

        return newState
    }
}
