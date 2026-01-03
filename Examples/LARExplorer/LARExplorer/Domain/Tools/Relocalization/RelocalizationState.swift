//
//  RelocalizationState.swift
//  LARExplorer
//
//  Created by Claude Code on 2026-01-04.
//

import Foundation
import simd

// MARK: - Localization Result

/// The result of a localization test
struct LocalizationTestResult: Equatable {
    /// Whether localization succeeded
    let success: Bool

    /// Frame index that was tested
    let frameIndex: Int

    /// Estimated pose (if successful)
    let estimatedPose: simd_float4x4?

    /// IDs of landmarks in the spatial query
    let spatialQueryIds: Set<Int>

    /// IDs of landmarks that matched
    let matchedIds: Set<Int>

    /// IDs of inlier landmarks after RANSAC
    let inlierIds: Set<Int>
}

// MARK: - State

/// Pure value type representing the state of relocalization testing
struct RelocalizationState: Equatable {
    /// Selected directory URL for test frames
    var selectedDirectoryURL: URL?

    /// Currently selected frame index
    var selectedFrameIndex: Int?

    /// Total number of frames available
    var totalFrames: Int = 0

    /// Whether localization is in progress
    var isLocalizing: Bool = false

    /// The result of the last localization test
    var lastResult: LocalizationTestResult?

    /// Error message if something went wrong
    var errorMessage: String?

    /// Initial state factory
    static let initial = RelocalizationState()

    // MARK: - Computed Properties

    /// Whether a directory is loaded with frames
    var hasFramesLoaded: Bool { totalFrames > 0 }

    /// Whether a frame is selected and ready to test
    var canLocalize: Bool { selectedFrameIndex != nil && !isLocalizing }
}

// MARK: - Actions

/// Actions that can modify RelocalizationState
enum RelocalizationAction: Equatable {
    // Directory/Frame management
    case setDirectory(URL?)
    case setTotalFrames(Int)
    case selectFrame(index: Int)
    case clearFrameSelection

    // Localization state
    case startLocalizing
    case finishLocalizing(LocalizationTestResult)
    case setError(String?)

    // Reset
    case reset

    // Side effect triggers
    case loadFrames
    case performLocalization
}

// MARK: - Reducer

extension RelocalizationAction {
    /// Pure function that computes the next state from an action
    func reduce(_ state: RelocalizationState) -> RelocalizationState {
        var newState = state

        switch self {
        case .setDirectory(let url):
            newState.selectedDirectoryURL = url
            newState.selectedFrameIndex = nil
            newState.totalFrames = 0
            newState.lastResult = nil
            newState.errorMessage = nil

        case .setTotalFrames(let count):
            newState.totalFrames = count

        case .selectFrame(let index):
            guard index >= 0 && index < state.totalFrames else { return state }
            newState.selectedFrameIndex = index

        case .clearFrameSelection:
            newState.selectedFrameIndex = nil
            newState.lastResult = nil

        case .startLocalizing:
            newState.isLocalizing = true
            newState.errorMessage = nil

        case .finishLocalizing(let result):
            newState.isLocalizing = false
            newState.lastResult = result

        case .setError(let message):
            newState.errorMessage = message
            newState.isLocalizing = false

        case .reset:
            newState = RelocalizationState.initial

        case .loadFrames, .performLocalization:
            // Side effect actions - no state change
            break
        }

        return newState
    }
}
