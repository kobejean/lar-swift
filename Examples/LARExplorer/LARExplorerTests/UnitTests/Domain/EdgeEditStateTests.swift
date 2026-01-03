//
//  EdgeEditStateTests.swift
//  LARExplorerTests
//
//  Created by Claude Code on 2026-01-04.
//

import Testing
@testable import LARExplorer

struct EdgeEditStateTests {

    // MARK: - Initial State Tests

    @Test func initialState_hasNoSourceAnchor() {
        let state = EdgeEditState.initial

        #expect(state.sourceAnchorId == nil)
        #expect(!state.isAwaitingTarget)
    }

    // MARK: - Click Anchor Tests (Two-Step Edge Creation)

    @Test func clickAnchor_withNoSource_setsSourceAnchor() {
        let state = EdgeEditState.initial

        let (newState, sideEffect) = EdgeEditAction.clickAnchor(id: 1).reduce(state)

        #expect(newState.sourceAnchorId == 1)
        #expect(newState.isAwaitingTarget)
        #expect(sideEffect == nil) // No side effect on first click
    }

    @Test func clickAnchor_withSource_onDifferentAnchor_triggersToggleEdge() {
        var state = EdgeEditState.initial
        state.sourceAnchorId = 1

        let (newState, sideEffect) = EdgeEditAction.clickAnchor(id: 2).reduce(state)

        // State should reset after second click
        #expect(newState.sourceAnchorId == nil)
        #expect(!newState.isAwaitingTarget)

        // Should trigger side effect to toggle the edge
        #expect(sideEffect == .toggleEdge(from: 1, to: 2))
    }

    @Test func clickAnchor_withSource_onSameAnchor_doesNothing() {
        var state = EdgeEditState.initial
        state.sourceAnchorId = 1

        let (newState, sideEffect) = EdgeEditAction.clickAnchor(id: 1).reduce(state)

        // Clicking same anchor keeps source selected (no self-loops)
        #expect(newState.sourceAnchorId == 1)
        #expect(sideEffect == nil)
    }

    // MARK: - Cancel Edge Creation Tests

    @Test func cancelEdgeCreation_clearsSourceAnchor() {
        var state = EdgeEditState.initial
        state.sourceAnchorId = 42

        let (newState, sideEffect) = EdgeEditAction.cancelEdgeCreation.reduce(state)

        #expect(newState.sourceAnchorId == nil)
        #expect(!newState.isAwaitingTarget)
        #expect(sideEffect == nil)
    }

    @Test func cancelEdgeCreation_withNoSource_doesNothing() {
        let state = EdgeEditState.initial

        let (newState, sideEffect) = EdgeEditAction.cancelEdgeCreation.reduce(state)

        #expect(newState.sourceAnchorId == nil)
        #expect(sideEffect == nil)
    }

    // MARK: - Toggle Edge Side Effect Tests

    @Test func toggleEdge_doesNotChangeState() {
        var state = EdgeEditState.initial
        state.sourceAnchorId = 1

        let (newState, sideEffect) = EdgeEditAction.toggleEdge(from: 1, to: 2).reduce(state)

        #expect(newState == state)
        #expect(sideEffect == nil) // Side effect action doesn't trigger further side effects
    }
}
