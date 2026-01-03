//
//  RelocalizationCoordinatorTests.swift
//  LARExplorerTests
//
//  Created by Claude Code on 2026-01-04.
//

import Testing
import Foundation
import simd
@testable import LARExplorer

/// Unit tests for RelocalizationCoordinator
@MainActor
struct RelocalizationCoordinatorTests {

    // MARK: - Setup

    private func makeSUT() -> (
        coordinator: RelocalizationCoordinator,
        mapRepository: MockMapRepository,
        renderingService: MockRenderingService
    ) {
        let mapRepository = MockMapRepository()
        let renderingService = MockRenderingService()
        let coordinator = RelocalizationCoordinator(
            mapRepository: mapRepository,
            renderingService: renderingService
        )
        return (coordinator, mapRepository, renderingService)
    }

    // MARK: - Initialization Tests

    @Test func initialState_hasNoDirectory() {
        let (coordinator, _, _) = makeSUT()

        #expect(coordinator.state == RelocalizationState.initial)
        #expect(coordinator.state.selectedDirectoryURL == nil)
    }

    // MARK: - Activation Tests

    @Test func activate_resetsState() {
        let (coordinator, _, _) = makeSUT()
        coordinator.dispatch(.setDirectory(URL(fileURLWithPath: "/test")))

        coordinator.activate()

        #expect(coordinator.state == RelocalizationState.initial)
    }

    @Test func deactivate_clearsHighlights() {
        let (coordinator, _, renderingService) = makeSUT()

        coordinator.deactivate()

        #expect(renderingService.clearLandmarkHighlightsCalled)
    }

    // MARK: - Directory Tests

    @Test func dispatch_setDirectory_updatesState() {
        let (coordinator, _, _) = makeSUT()
        let url = URL(fileURLWithPath: "/frames")

        coordinator.dispatch(.setDirectory(url))

        #expect(coordinator.state.selectedDirectoryURL == url)
    }

    @Test func dispatch_setDirectory_clearsFrameSelection() {
        let (coordinator, _, _) = makeSUT()
        coordinator.dispatch(.setTotalFrames(10))
        coordinator.dispatch(.selectFrame(index: 5))

        coordinator.dispatch(.setDirectory(URL(fileURLWithPath: "/new")))

        #expect(coordinator.state.selectedFrameIndex == nil)
        #expect(coordinator.state.totalFrames == 0)
    }

    // MARK: - Frame Selection Tests

    @Test func dispatch_setTotalFrames_updatesState() {
        let (coordinator, _, _) = makeSUT()

        coordinator.dispatch(.setTotalFrames(100))

        #expect(coordinator.state.totalFrames == 100)
        #expect(coordinator.state.hasFramesLoaded)
    }

    @Test func dispatch_selectFrame_updatesState() {
        let (coordinator, _, _) = makeSUT()
        coordinator.dispatch(.setTotalFrames(10))

        coordinator.dispatch(.selectFrame(index: 5))

        #expect(coordinator.state.selectedFrameIndex == 5)
        #expect(coordinator.state.canLocalize)
    }

    @Test func dispatch_selectFrame_outOfBounds_doesNothing() {
        let (coordinator, _, _) = makeSUT()
        coordinator.dispatch(.setTotalFrames(10))

        coordinator.dispatch(.selectFrame(index: 15))

        #expect(coordinator.state.selectedFrameIndex == nil)
    }

    // MARK: - Localization Tests

    @Test func dispatch_startLocalizing_setsFlag() {
        let (coordinator, _, _) = makeSUT()
        coordinator.dispatch(.setTotalFrames(1))
        coordinator.dispatch(.selectFrame(index: 0))

        coordinator.dispatch(.startLocalizing)

        #expect(coordinator.state.isLocalizing)
        #expect(!coordinator.state.canLocalize) // Can't localize while localizing
    }

    @Test func dispatch_finishLocalizing_setsResult() {
        let (coordinator, _, _) = makeSUT()
        coordinator.dispatch(.startLocalizing)

        let result = LocalizationTestResult(
            success: true,
            frameIndex: 0,
            estimatedPose: matrix_identity_float4x4,
            spatialQueryIds: [1, 2, 3],
            matchedIds: [1, 2],
            inlierIds: [1]
        )
        coordinator.dispatch(.finishLocalizing(result))

        #expect(!coordinator.state.isLocalizing)
        #expect(coordinator.state.lastResult == result)
    }

    @Test func dispatch_finishLocalizing_highlightsLandmarks() {
        let (coordinator, _, renderingService) = makeSUT()
        coordinator.dispatch(.startLocalizing)

        let result = LocalizationTestResult(
            success: true,
            frameIndex: 0,
            estimatedPose: matrix_identity_float4x4,
            spatialQueryIds: [1, 2, 3],
            matchedIds: [1, 2],
            inlierIds: [1]
        )
        coordinator.dispatch(.finishLocalizing(result))

        // Should have called highlightLandmarks for each group
        #expect(!renderingService.highlightLandmarksCalls.isEmpty)
    }

    // MARK: - Error Tests

    @Test func dispatch_setError_setsMessageAndStopsLocalizing() {
        let (coordinator, _, _) = makeSUT()
        coordinator.dispatch(.startLocalizing)

        coordinator.dispatch(.setError("Test error"))

        #expect(coordinator.state.errorMessage == "Test error")
        #expect(!coordinator.state.isLocalizing)
    }

    // MARK: - Reset Tests

    @Test func dispatch_reset_clearsAllState() {
        let (coordinator, _, _) = makeSUT()
        coordinator.dispatch(.setDirectory(URL(fileURLWithPath: "/test")))
        coordinator.dispatch(.setTotalFrames(100))
        coordinator.dispatch(.selectFrame(index: 50))

        coordinator.dispatch(.reset)

        #expect(coordinator.state == RelocalizationState.initial)
    }

    // MARK: - Protocol Conformance Tests

    @Test func conformsToToolCoordinator() {
        let (coordinator, _, _) = makeSUT()

        let toolCoordinator: any ToolCoordinator = coordinator

        #expect(toolCoordinator.kind == .relocalization)
    }
}
