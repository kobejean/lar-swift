//
//  RelocalizationStateTests.swift
//  LARExplorerTests
//
//  Created by Claude Code on 2026-01-04.
//

import Testing
import Foundation
import simd
@testable import LARExplorer

struct RelocalizationStateTests {

    // MARK: - Initial State Tests

    @Test func initialState_hasNoDirectory() {
        let state = RelocalizationState.initial

        #expect(state.selectedDirectoryURL == nil)
        #expect(state.totalFrames == 0)
        #expect(!state.hasFramesLoaded)
    }

    @Test func initialState_hasNoFrameSelected() {
        let state = RelocalizationState.initial

        #expect(state.selectedFrameIndex == nil)
        #expect(!state.canLocalize)
    }

    @Test func initialState_isNotLocalizing() {
        let state = RelocalizationState.initial

        #expect(!state.isLocalizing)
    }

    // MARK: - Directory Tests

    @Test func setDirectory_updatesURL() {
        let state = RelocalizationState.initial
        let url = URL(fileURLWithPath: "/test/frames")

        let newState = RelocalizationAction.setDirectory(url).reduce(state)

        #expect(newState.selectedDirectoryURL == url)
    }

    @Test func setDirectory_clearsFrameSelection() {
        var state = RelocalizationState.initial
        state.selectedFrameIndex = 5
        state.totalFrames = 10
        state.lastResult = LocalizationTestResult(
            success: true, frameIndex: 5, estimatedPose: nil,
            spatialQueryIds: [], matchedIds: [], inlierIds: []
        )

        let url = URL(fileURLWithPath: "/new/frames")
        let newState = RelocalizationAction.setDirectory(url).reduce(state)

        #expect(newState.selectedFrameIndex == nil)
        #expect(newState.totalFrames == 0)
        #expect(newState.lastResult == nil)
    }

    // MARK: - Frame Tests

    @Test func setTotalFrames_updatesCount() {
        let state = RelocalizationState.initial

        let newState = RelocalizationAction.setTotalFrames(100).reduce(state)

        #expect(newState.totalFrames == 100)
        #expect(newState.hasFramesLoaded)
    }

    @Test func selectFrame_updatesIndex() {
        var state = RelocalizationState.initial
        state.totalFrames = 10

        let newState = RelocalizationAction.selectFrame(index: 5).reduce(state)

        #expect(newState.selectedFrameIndex == 5)
        #expect(newState.canLocalize)
    }

    @Test func selectFrame_outOfBounds_doesNothing() {
        var state = RelocalizationState.initial
        state.totalFrames = 10

        let newState = RelocalizationAction.selectFrame(index: 15).reduce(state)

        #expect(newState.selectedFrameIndex == nil)
    }

    @Test func selectFrame_negative_doesNothing() {
        var state = RelocalizationState.initial
        state.totalFrames = 10

        let newState = RelocalizationAction.selectFrame(index: -1).reduce(state)

        #expect(newState.selectedFrameIndex == nil)
    }

    @Test func clearFrameSelection_clearsIndexAndResult() {
        var state = RelocalizationState.initial
        state.selectedFrameIndex = 5
        state.lastResult = LocalizationTestResult(
            success: true, frameIndex: 5, estimatedPose: nil,
            spatialQueryIds: [], matchedIds: [], inlierIds: []
        )

        let newState = RelocalizationAction.clearFrameSelection.reduce(state)

        #expect(newState.selectedFrameIndex == nil)
        #expect(newState.lastResult == nil)
    }

    // MARK: - Localization Tests

    @Test func startLocalizing_setsFlag() {
        var state = RelocalizationState.initial
        state.selectedFrameIndex = 0
        state.totalFrames = 1

        let newState = RelocalizationAction.startLocalizing.reduce(state)

        #expect(newState.isLocalizing)
        #expect(!newState.canLocalize) // Can't localize while localizing
    }

    @Test func startLocalizing_clearsError() {
        var state = RelocalizationState.initial
        state.errorMessage = "Previous error"

        let newState = RelocalizationAction.startLocalizing.reduce(state)

        #expect(newState.errorMessage == nil)
    }

    @Test func finishLocalizing_setsResult() {
        var state = RelocalizationState.initial
        state.isLocalizing = true

        let result = LocalizationTestResult(
            success: true,
            frameIndex: 3,
            estimatedPose: matrix_identity_float4x4,
            spatialQueryIds: [1, 2, 3],
            matchedIds: [1, 2],
            inlierIds: [1]
        )

        let newState = RelocalizationAction.finishLocalizing(result).reduce(state)

        #expect(!newState.isLocalizing)
        #expect(newState.lastResult == result)
    }

    @Test func setError_setsMessageAndStopsLocalizing() {
        var state = RelocalizationState.initial
        state.isLocalizing = true

        let newState = RelocalizationAction.setError("Something went wrong").reduce(state)

        #expect(newState.errorMessage == "Something went wrong")
        #expect(!newState.isLocalizing)
    }

    // MARK: - Reset Tests

    @Test func reset_clearsAllState() {
        var state = RelocalizationState.initial
        state.selectedDirectoryURL = URL(fileURLWithPath: "/test")
        state.totalFrames = 50
        state.selectedFrameIndex = 10
        state.isLocalizing = true
        state.errorMessage = "Error"

        let newState = RelocalizationAction.reset.reduce(state)

        #expect(newState == RelocalizationState.initial)
    }

    // MARK: - Side Effect Tests

    @Test func loadFrames_doesNotChangeState() {
        let state = RelocalizationState.initial

        let newState = RelocalizationAction.loadFrames.reduce(state)

        #expect(newState == state)
    }

    @Test func performLocalization_doesNotChangeState() {
        var state = RelocalizationState.initial
        state.selectedFrameIndex = 0
        state.totalFrames = 1

        let newState = RelocalizationAction.performLocalization.reduce(state)

        #expect(newState == state)
    }
}
