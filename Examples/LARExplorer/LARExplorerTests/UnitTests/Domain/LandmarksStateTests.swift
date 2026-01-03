//
//  LandmarksStateTests.swift
//  LARExplorerTests
//
//  Created by Claude Code on 2026-01-04.
//

import Testing
@testable import LARExplorer

struct LandmarksStateTests {

    // MARK: - Initial State Tests

    @Test func initialState_hasNoSelection() {
        let state = LandmarksState.initial

        #expect(state.selectedLandmarkId == nil)
        #expect(!state.hasSelection)
    }

    // MARK: - Select Landmark Tests

    @Test func selectLandmark_setsSelectedId() {
        let state = LandmarksState.initial

        let newState = LandmarksAction.selectLandmark(id: 42).reduce(state)

        #expect(newState.selectedLandmarkId == 42)
        #expect(newState.hasSelection)
    }

    @Test func selectLandmark_replacesExistingSelection() {
        var state = LandmarksState.initial
        state.selectedLandmarkId = 1

        let newState = LandmarksAction.selectLandmark(id: 2).reduce(state)

        #expect(newState.selectedLandmarkId == 2)
    }

    // MARK: - Clear Selection Tests

    @Test func clearSelection_removesSelectedId() {
        var state = LandmarksState.initial
        state.selectedLandmarkId = 42

        let newState = LandmarksAction.clearSelection.reduce(state)

        #expect(newState.selectedLandmarkId == nil)
        #expect(!newState.hasSelection)
    }

    @Test func clearSelection_isIdempotent() {
        let state = LandmarksState.initial

        let newState = LandmarksAction.clearSelection.reduce(state)

        #expect(newState == state)
    }
}
