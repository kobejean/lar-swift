//
//  LandmarksCoordinatorTests.swift
//  LARExplorerTests
//
//  Created by Claude Code on 2026-01-04.
//

import Testing
import simd
@testable import LARExplorer

/// Unit tests for LandmarksCoordinator
@MainActor
struct LandmarksCoordinatorTests {

    // MARK: - Setup

    private func makeSUT() -> (
        coordinator: LandmarksCoordinator,
        mapRepository: MockMapRepository,
        renderingService: MockRenderingService
    ) {
        let mapRepository = MockMapRepository()
        let renderingService = MockRenderingService()
        let coordinator = LandmarksCoordinator(
            mapRepository: mapRepository,
            renderingService: renderingService
        )
        return (coordinator, mapRepository, renderingService)
    }

    // MARK: - Initialization Tests

    @Test func initialState_hasNoSelection() {
        let (coordinator, _, _) = makeSUT()

        #expect(coordinator.state == LandmarksState.initial)
        #expect(!coordinator.state.hasSelection)
    }

    // MARK: - Activation Tests

    @Test func activate_resetsState() {
        let (coordinator, _, _) = makeSUT()
        coordinator.dispatch(.selectLandmark(id: 42))

        coordinator.activate()

        #expect(coordinator.state == LandmarksState.initial)
    }

    @Test func deactivate_clearsHighlights() {
        let (coordinator, _, renderingService) = makeSUT()
        coordinator.dispatch(.selectLandmark(id: 42))

        coordinator.deactivate()

        #expect(renderingService.clearLandmarkHighlightsCalled)
    }

    // MARK: - Selection Tests

    @Test func dispatch_selectLandmark_updatesState() {
        let (coordinator, _, _) = makeSUT()

        coordinator.dispatch(.selectLandmark(id: 42))

        #expect(coordinator.state.selectedLandmarkId == 42)
    }

    @Test func dispatch_selectLandmark_highlightsLandmark() {
        let (coordinator, _, renderingService) = makeSUT()

        coordinator.dispatch(.selectLandmark(id: 42))

        #expect(renderingService.highlightLandmarksCalls.last?.ids == [42])
        #expect(renderingService.highlightLandmarksCalls.last?.style == .selected)
    }

    @Test func dispatch_clearSelection_updatesState() {
        let (coordinator, _, _) = makeSUT()
        coordinator.dispatch(.selectLandmark(id: 42))

        coordinator.dispatch(.clearSelection)

        #expect(coordinator.state.selectedLandmarkId == nil)
    }

    @Test func dispatch_clearSelection_clearsHighlights() {
        let (coordinator, _, renderingService) = makeSUT()
        coordinator.dispatch(.selectLandmark(id: 42))

        coordinator.dispatch(.clearSelection)

        #expect(renderingService.clearLandmarkHighlightsCalled)
    }

    // MARK: - Scene Click Tests

    @Test func handleSceneClick_withLandmarkHit_selectsLandmark() {
        let (coordinator, _, _) = makeSUT()

        coordinator.handleSceneClick(at: .zero, hitAnchorId: nil, hitLandmarkId: 99)

        #expect(coordinator.state.selectedLandmarkId == 99)
    }

    @Test func handleSceneClick_withoutLandmarkHit_clearsSelection() {
        let (coordinator, _, _) = makeSUT()
        coordinator.dispatch(.selectLandmark(id: 42))

        coordinator.handleSceneClick(at: .zero, hitAnchorId: nil, hitLandmarkId: nil)

        #expect(coordinator.state.selectedLandmarkId == nil)
    }

    // MARK: - Protocol Conformance Tests

    @Test func conformsToToolCoordinator() {
        let (coordinator, _, _) = makeSUT()

        let toolCoordinator: any ToolCoordinator = coordinator

        #expect(toolCoordinator.kind == .landmarks)
    }
}
