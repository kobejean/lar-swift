//
//  EdgeEditState.swift
//  LARExplorer
//
//  Created by Claude Code on 2026-01-04.
//

import Foundation

// MARK: - State

/// Pure value type representing the state of edge editing
/// Edge creation is a two-step process: select source anchor, then click target
struct EdgeEditState: Equatable {
    /// The source anchor ID for edge creation (nil = no source selected)
    var sourceAnchorId: Int32?

    /// Initial state factory
    static let initial = EdgeEditState()

    // MARK: - Computed Properties

    /// Whether a source anchor is selected (awaiting target)
    var isAwaitingTarget: Bool { sourceAnchorId != nil }
}

// MARK: - Actions

/// Actions that can modify EdgeEditState
enum EdgeEditAction: Equatable {
    /// Click on an anchor - either sets source or triggers edge operation
    case clickAnchor(id: Int32)

    /// Clear the source selection (cancel edge creation)
    case cancelEdgeCreation

    /// Side effect triggers (state unchanged, coordinator handles)
    case toggleEdge(from: Int32, to: Int32)
}

// MARK: - Reducer

extension EdgeEditAction {
    /// Pure function that computes the next state from an action
    /// - Parameter state: The current state
    /// - Returns: A tuple of (new state, optional side effect action to trigger)
    func reduce(_ state: EdgeEditState) -> (EdgeEditState, EdgeEditAction?) {
        var newState = state
        var sideEffect: EdgeEditAction?

        switch self {
        case .clickAnchor(let id):
            if let sourceId = state.sourceAnchorId {
                // Second click - check if different anchor
                if sourceId != id {
                    // Trigger edge toggle and reset
                    sideEffect = .toggleEdge(from: sourceId, to: id)
                    newState.sourceAnchorId = nil
                }
                // If same anchor, do nothing (no self-loops)
            } else {
                // First click - set source
                newState.sourceAnchorId = id
            }

        case .cancelEdgeCreation:
            newState.sourceAnchorId = nil

        case .toggleEdge:
            // Side effect action - no state change
            break
        }

        return (newState, sideEffect)
    }
}
