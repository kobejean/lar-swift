//
//  AnchorEditState.swift
//  LARExplorer
//
//  Created by Claude Code on 2026-01-04.
//

import simd

// MARK: - State

/// Pure value type representing the state of anchor editing
struct AnchorEditState: Equatable {
    /// Currently selected anchor IDs
    var selectedAnchorIds: Set<Int32> = []

    /// Position offset to apply to selected anchors
    var positionOffset: SIMD3<Float> = .zero

    /// Whether the offset preview is being shown
    var isPreviewingOffset: Bool = false

    /// Initial state factory
    static let initial = AnchorEditState()

    // MARK: - Computed Properties

    /// Whether any anchors are selected
    var hasSelection: Bool { !selectedAnchorIds.isEmpty }

    /// Whether a non-zero offset is set
    var hasOffset: Bool { positionOffset != .zero }

    /// Whether the offset can be applied (requires selection and offset)
    var canApplyOffset: Bool { hasSelection && hasOffset }
}

// MARK: - Actions

/// Actions that can modify AnchorEditState
enum AnchorEditAction: Equatable {
    // Selection actions
    case toggleSelection(id: Int32)
    case selectAnchor(id: Int32)
    case deselectAnchor(id: Int32)
    case clearSelection

    // Offset actions
    case setOffset(SIMD3<Float>)
    case setPreviewingOffset(Bool)

    // Side effect triggers (state unchanged, coordinator handles)
    case applyOffset
    case deleteSelected
}

// MARK: - Reducer

extension AnchorEditAction {
    /// Pure function that computes the next state from an action
    /// - Parameter state: The current state
    /// - Returns: The new state after applying the action
    func reduce(_ state: AnchorEditState) -> AnchorEditState {
        var newState = state

        switch self {
        case .toggleSelection(let id):
            if newState.selectedAnchorIds.contains(id) {
                newState.selectedAnchorIds.remove(id)
            } else {
                newState.selectedAnchorIds.insert(id)
            }

        case .selectAnchor(let id):
            newState.selectedAnchorIds.insert(id)

        case .deselectAnchor(let id):
            newState.selectedAnchorIds.remove(id)

        case .clearSelection:
            newState.selectedAnchorIds.removeAll()
            newState.isPreviewingOffset = false

        case .setOffset(let offset):
            newState.positionOffset = offset

        case .setPreviewingOffset(let previewing):
            newState.isPreviewingOffset = previewing

        case .applyOffset, .deleteSelected:
            // Side effect actions - state unchanged, coordinator handles
            break
        }

        return newState
    }
}
