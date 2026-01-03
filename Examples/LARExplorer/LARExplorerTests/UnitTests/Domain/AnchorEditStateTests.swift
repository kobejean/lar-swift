//
//  AnchorEditStateTests.swift
//  LARExplorerTests
//
//  Created by Claude Code on 2026-01-04.
//

import Testing
import simd
@testable import LARExplorer

struct AnchorEditStateTests {

    // MARK: - Initial State Tests

    @Test func initialState_hasEmptySelection() {
        let state = AnchorEditState.initial

        #expect(state.selectedAnchorIds.isEmpty)
        #expect(!state.hasSelection)
    }

    @Test func initialState_hasZeroOffset() {
        let state = AnchorEditState.initial

        #expect(state.positionOffset == .zero)
        #expect(!state.hasOffset)
    }

    @Test func initialState_isNotPreviewingOffset() {
        let state = AnchorEditState.initial

        #expect(!state.isPreviewingOffset)
    }

    @Test func initialState_cannotApplyOffset() {
        let state = AnchorEditState.initial

        #expect(!state.canApplyOffset)
    }

    // MARK: - Toggle Selection Tests

    @Test func toggleSelection_addsAnchorWhenNotSelected() {
        let state = AnchorEditState.initial

        let newState = AnchorEditAction.toggleSelection(id: 1).reduce(state)

        #expect(newState.selectedAnchorIds.contains(1))
        #expect(newState.hasSelection)
    }

    @Test func toggleSelection_removesAnchorWhenAlreadySelected() {
        var state = AnchorEditState.initial
        state.selectedAnchorIds = [1, 2, 3]

        let newState = AnchorEditAction.toggleSelection(id: 2).reduce(state)

        #expect(!newState.selectedAnchorIds.contains(2))
        #expect(newState.selectedAnchorIds == [1, 3])
    }

    @Test func toggleSelection_preservesOtherAnchors() {
        var state = AnchorEditState.initial
        state.selectedAnchorIds = [1, 2]

        let newState = AnchorEditAction.toggleSelection(id: 3).reduce(state)

        #expect(newState.selectedAnchorIds == [1, 2, 3])
    }

    // MARK: - Select/Deselect Tests

    @Test func selectAnchor_addsToSelection() {
        let state = AnchorEditState.initial

        let newState = AnchorEditAction.selectAnchor(id: 42).reduce(state)

        #expect(newState.selectedAnchorIds.contains(42))
    }

    @Test func selectAnchor_isIdempotent() {
        var state = AnchorEditState.initial
        state.selectedAnchorIds = [42]

        let newState = AnchorEditAction.selectAnchor(id: 42).reduce(state)

        #expect(newState.selectedAnchorIds == [42])
    }

    @Test func deselectAnchor_removesFromSelection() {
        var state = AnchorEditState.initial
        state.selectedAnchorIds = [1, 2, 3]

        let newState = AnchorEditAction.deselectAnchor(id: 2).reduce(state)

        #expect(!newState.selectedAnchorIds.contains(2))
        #expect(newState.selectedAnchorIds == [1, 3])
    }

    @Test func deselectAnchor_isIdempotentWhenNotSelected() {
        var state = AnchorEditState.initial
        state.selectedAnchorIds = [1, 3]

        let newState = AnchorEditAction.deselectAnchor(id: 2).reduce(state)

        #expect(newState.selectedAnchorIds == [1, 3])
    }

    // MARK: - Clear Selection Tests

    @Test func clearSelection_emptiesSelectedAnchors() {
        var state = AnchorEditState.initial
        state.selectedAnchorIds = [1, 2, 3]

        let newState = AnchorEditAction.clearSelection.reduce(state)

        #expect(newState.selectedAnchorIds.isEmpty)
        #expect(!newState.hasSelection)
    }

    @Test func clearSelection_disablesPreviewingOffset() {
        var state = AnchorEditState.initial
        state.selectedAnchorIds = [1]
        state.isPreviewingOffset = true

        let newState = AnchorEditAction.clearSelection.reduce(state)

        #expect(!newState.isPreviewingOffset)
    }

    @Test func clearSelection_preservesOffset() {
        var state = AnchorEditState.initial
        state.selectedAnchorIds = [1]
        state.positionOffset = SIMD3(1, 2, 3)

        let newState = AnchorEditAction.clearSelection.reduce(state)

        #expect(newState.positionOffset == SIMD3(1, 2, 3))
    }

    // MARK: - Set Offset Tests

    @Test func setOffset_updatesPositionOffset() {
        let state = AnchorEditState.initial
        let offset = SIMD3<Float>(1.5, 2.5, 3.5)

        let newState = AnchorEditAction.setOffset(offset).reduce(state)

        #expect(newState.positionOffset == offset)
        #expect(newState.hasOffset)
    }

    @Test func setOffset_toZero_clearsHasOffset() {
        var state = AnchorEditState.initial
        state.positionOffset = SIMD3(1, 0, 0)

        let newState = AnchorEditAction.setOffset(.zero).reduce(state)

        #expect(newState.positionOffset == .zero)
        #expect(!newState.hasOffset)
    }

    // MARK: - Set Previewing Offset Tests

    @Test func setPreviewingOffset_true_enablesPreview() {
        let state = AnchorEditState.initial

        let newState = AnchorEditAction.setPreviewingOffset(true).reduce(state)

        #expect(newState.isPreviewingOffset)
    }

    @Test func setPreviewingOffset_false_disablesPreview() {
        var state = AnchorEditState.initial
        state.isPreviewingOffset = true

        let newState = AnchorEditAction.setPreviewingOffset(false).reduce(state)

        #expect(!newState.isPreviewingOffset)
    }

    // MARK: - Side Effect Actions (No State Change)

    @Test func applyOffset_doesNotChangeState() {
        var state = AnchorEditState.initial
        state.selectedAnchorIds = [1, 2]
        state.positionOffset = SIMD3(1, 0, 0)

        let newState = AnchorEditAction.applyOffset.reduce(state)

        #expect(newState == state)
    }

    @Test func deleteSelected_doesNotChangeState() {
        var state = AnchorEditState.initial
        state.selectedAnchorIds = [1, 2, 3]

        let newState = AnchorEditAction.deleteSelected.reduce(state)

        #expect(newState == state)
    }

    // MARK: - Computed Property Tests

    @Test func canApplyOffset_requiresBothSelectionAndOffset() {
        var state = AnchorEditState.initial
        #expect(!state.canApplyOffset) // Neither

        state.selectedAnchorIds = [1]
        #expect(!state.canApplyOffset) // Selection only

        state.selectedAnchorIds = []
        state.positionOffset = SIMD3(1, 0, 0)
        #expect(!state.canApplyOffset) // Offset only

        state.selectedAnchorIds = [1]
        state.positionOffset = SIMD3(1, 0, 0)
        #expect(state.canApplyOffset) // Both
    }
}
