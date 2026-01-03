//
//  GPSAlignmentStateTests.swift
//  LARExplorerTests
//
//  Created by Claude Code on 2026-01-04.
//

import Testing
@testable import LARExplorer

struct GPSAlignmentStateTests {

    // MARK: - Initial State Tests

    @Test func initialState_hasNoAdjustments() {
        let state = GPSAlignmentState.initial

        #expect(state.translationX == 0.0)
        #expect(state.translationY == 0.0)
        #expect(state.rotation == 0.0)
        #expect(state.scaleFactor == 1.0)
        #expect(!state.hasAdjustments)
    }

    @Test func initialState_hasNoStatusMessage() {
        let state = GPSAlignmentState.initial

        #expect(state.statusMessage == nil)
    }

    // MARK: - Translation Tests

    @Test func setTranslationX_updatesValue() {
        let state = GPSAlignmentState.initial

        let newState = GPSAlignmentAction.setTranslationX(5.5).reduce(state)

        #expect(newState.translationX == 5.5)
        #expect(newState.hasAdjustments)
    }

    @Test func setTranslationY_updatesValue() {
        let state = GPSAlignmentState.initial

        let newState = GPSAlignmentAction.setTranslationY(-3.2).reduce(state)

        #expect(newState.translationY == -3.2)
        #expect(newState.hasAdjustments)
    }

    // MARK: - Rotation Tests

    @Test func setRotation_updatesValue() {
        let state = GPSAlignmentState.initial

        let newState = GPSAlignmentAction.setRotation(45.0).reduce(state)

        #expect(newState.rotation == 45.0)
        #expect(newState.hasAdjustments)
    }

    // MARK: - Scale Tests

    @Test func setScaleFactor_updatesValue() {
        let state = GPSAlignmentState.initial

        let newState = GPSAlignmentAction.setScaleFactor(1.5).reduce(state)

        #expect(newState.scaleFactor == 1.5)
        #expect(newState.hasAdjustments)
    }

    // MARK: - Reset Tests

    @Test func reset_clearsAllAdjustments() {
        var state = GPSAlignmentState.initial
        state.translationX = 10.0
        state.translationY = 20.0
        state.rotation = 45.0
        state.scaleFactor = 2.0
        state.statusMessage = "Testing"

        let newState = GPSAlignmentAction.reset.reduce(state)

        #expect(newState == GPSAlignmentState.initial)
        #expect(!newState.hasAdjustments)
    }

    // MARK: - Status Message Tests

    @Test func setStatusMessage_updatesValue() {
        let state = GPSAlignmentState.initial

        let newState = GPSAlignmentAction.setStatusMessage("Aligning...").reduce(state)

        #expect(newState.statusMessage == "Aligning...")
    }

    @Test func setStatusMessage_nil_clearsMessage() {
        var state = GPSAlignmentState.initial
        state.statusMessage = "Previous message"

        let newState = GPSAlignmentAction.setStatusMessage(nil).reduce(state)

        #expect(newState.statusMessage == nil)
    }

    // MARK: - Side Effect Tests

    @Test func applyAlignment_doesNotChangeState() {
        var state = GPSAlignmentState.initial
        state.translationX = 5.0

        let newState = GPSAlignmentAction.applyAlignment.reduce(state)

        #expect(newState == state)
    }

    @Test func applyScale_doesNotChangeState() {
        var state = GPSAlignmentState.initial
        state.scaleFactor = 2.0

        let newState = GPSAlignmentAction.applyScale.reduce(state)

        #expect(newState == state)
    }

    @Test func performAutoAlignment_doesNotChangeState() {
        let state = GPSAlignmentState.initial

        let newState = GPSAlignmentAction.performAutoAlignment.reduce(state)

        #expect(newState == state)
    }
}
