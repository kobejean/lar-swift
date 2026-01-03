//
//  AnchorEditCoordinatorTests.swift
//  LARExplorerTests
//
//  Created by Claude Code on 2026-01-04.
//

import Testing
import simd
@testable import LARExplorer

/// Unit tests for AnchorEditCoordinator
/// Tests verify the coordinator correctly dispatches actions and issues rendering commands
@MainActor
struct AnchorEditCoordinatorTests {

    // MARK: - Setup

    private func makeSUT() -> (
        coordinator: AnchorEditCoordinator,
        mapRepository: MockMapRepository,
        renderingService: MockRenderingService
    ) {
        let mapRepository = MockMapRepository()
        let renderingService = MockRenderingService()
        let coordinator = AnchorEditCoordinator(
            mapRepository: mapRepository,
            renderingService: renderingService
        )
        return (coordinator, mapRepository, renderingService)
    }

    // MARK: - Initialization Tests

    @Test func initialState_hasNoSelection() {
        let (coordinator, _, _) = makeSUT()

        #expect(coordinator.state == AnchorEditState.initial)
        #expect(!coordinator.state.hasSelection)
    }

    // MARK: - Activation Tests

    @Test func activate_resetsState() {
        let (coordinator, _, _) = makeSUT()
        coordinator.dispatch(.selectAnchor(id: 1))

        coordinator.activate()

        #expect(coordinator.state == AnchorEditState.initial)
    }

    @Test func deactivate_clearsHighlights() {
        let (coordinator, _, renderingService) = makeSUT()
        coordinator.dispatch(.selectAnchor(id: 1))

        coordinator.deactivate()

        #expect(renderingService.clearAnchorHighlightsCalled)
        #expect(renderingService.hidePreviewNodesCalled)
    }

    // MARK: - Selection Tests

    @Test func dispatch_selectAnchor_updatesState() {
        let (coordinator, _, _) = makeSUT()

        coordinator.dispatch(.selectAnchor(id: 1))

        #expect(coordinator.state.selectedAnchorIds.contains(1))
    }

    @Test func dispatch_selectAnchor_highlightsAnchors() {
        let (coordinator, _, renderingService) = makeSUT()

        coordinator.dispatch(.selectAnchor(id: 1))

        #expect(renderingService.highlightedAnchorIds == [1])
        #expect(renderingService.lastHighlightStyle == .selected)
    }

    @Test func dispatch_toggleSelection_addsAndRemoves() {
        let (coordinator, _, _) = makeSUT()

        coordinator.dispatch(.toggleSelection(id: 1))
        #expect(coordinator.state.selectedAnchorIds.contains(1))

        coordinator.dispatch(.toggleSelection(id: 1))
        #expect(!coordinator.state.selectedAnchorIds.contains(1))
    }

    @Test func dispatch_clearSelection_clearsHighlights() {
        let (coordinator, _, renderingService) = makeSUT()
        coordinator.dispatch(.selectAnchor(id: 1))

        coordinator.dispatch(.clearSelection)

        #expect(renderingService.clearAnchorHighlightsCalled)
    }

    // MARK: - Offset Tests

    @Test func dispatch_setOffset_updatesState() {
        let (coordinator, _, _) = makeSUT()

        coordinator.dispatch(.setOffset(SIMD3<Float>(1, 2, 3)))

        #expect(coordinator.state.positionOffset == SIMD3<Float>(1, 2, 3))
    }

    @Test func dispatch_setPreviewingOffset_showsPreviewNodes() {
        let (coordinator, mapRepository, renderingService) = makeSUT()
        // Setup: Add an anchor to the repository
        mapRepository.mockAnchors = [
            AnchorData(id: 1, position: SIMD3<Float>(0, 0, 0))
        ]
        coordinator.dispatch(.selectAnchor(id: 1))
        coordinator.dispatch(.setOffset(SIMD3<Float>(1, 0, 0)))

        coordinator.dispatch(.setPreviewingOffset(true))

        #expect(renderingService.previewNodePositions != nil)
        #expect(renderingService.previewNodePositions?[1] == SIMD3<Float>(1, 0, 0))
    }

    @Test func dispatch_setPreviewingOffset_false_hidesPreviewNodes() {
        let (coordinator, mapRepository, renderingService) = makeSUT()
        mapRepository.mockAnchors = [
            AnchorData(id: 1, position: SIMD3<Float>(0, 0, 0))
        ]
        coordinator.dispatch(.selectAnchor(id: 1))
        coordinator.dispatch(.setOffset(SIMD3<Float>(1, 0, 0)))
        coordinator.dispatch(.setPreviewingOffset(true))

        coordinator.dispatch(.setPreviewingOffset(false))

        #expect(renderingService.hidePreviewNodesCalled)
    }

    // MARK: - Side Effect Tests

    @Test func dispatch_applyOffset_updatesRepository() async {
        let (coordinator, mapRepository, _) = makeSUT()
        mapRepository.mockAnchors = [
            AnchorData(id: 1, position: SIMD3<Float>(0, 0, 0)),
            AnchorData(id: 2, position: SIMD3<Float>(1, 1, 1))
        ]
        coordinator.dispatch(.selectAnchor(id: 1))
        coordinator.dispatch(.selectAnchor(id: 2))
        coordinator.dispatch(.setOffset(SIMD3<Float>(5, 0, 0)))

        coordinator.dispatch(.applyOffset)

        // Wait for async side effect
        try? await Task.sleep(nanoseconds: 10_000_000)

        #expect(mapRepository.updatePositionCalls.count == 2)
        #expect(mapRepository.updatePositionCalls.contains { $0.id == 1 && $0.offset == SIMD3<Float>(5, 0, 0) })
        #expect(mapRepository.updatePositionCalls.contains { $0.id == 2 && $0.offset == SIMD3<Float>(5, 0, 0) })
    }

    @Test func dispatch_applyOffset_clearsSelectionAfter() async {
        let (coordinator, mapRepository, _) = makeSUT()
        mapRepository.mockAnchors = [AnchorData(id: 1, position: .zero)]
        coordinator.dispatch(.selectAnchor(id: 1))
        coordinator.dispatch(.setOffset(SIMD3<Float>(1, 0, 0)))

        coordinator.dispatch(.applyOffset)

        try? await Task.sleep(nanoseconds: 10_000_000)

        #expect(!coordinator.state.hasSelection)
        #expect(coordinator.state.positionOffset == .zero)
    }

    @Test func dispatch_applyOffset_refreshesRendering() async {
        let (coordinator, mapRepository, renderingService) = makeSUT()
        mapRepository.mockAnchors = [AnchorData(id: 1, position: .zero)]
        coordinator.dispatch(.selectAnchor(id: 1))
        coordinator.dispatch(.setOffset(SIMD3<Float>(1, 0, 0)))

        coordinator.dispatch(.applyOffset)

        try? await Task.sleep(nanoseconds: 10_000_000)

        #expect(renderingService.refreshAllCalled)
    }

    @Test func dispatch_deleteSelected_removesFromRepository() async {
        let (coordinator, mapRepository, _) = makeSUT()
        mapRepository.mockAnchors = [
            AnchorData(id: 1, position: .zero),
            AnchorData(id: 2, position: .zero)
        ]
        coordinator.dispatch(.selectAnchor(id: 1))
        coordinator.dispatch(.selectAnchor(id: 2))

        coordinator.dispatch(.deleteSelected)

        try? await Task.sleep(nanoseconds: 10_000_000)

        #expect(mapRepository.deletedAnchorIds.contains(1))
        #expect(mapRepository.deletedAnchorIds.contains(2))
    }

    @Test func dispatch_deleteSelected_clearsSelection() async {
        let (coordinator, mapRepository, _) = makeSUT()
        mapRepository.mockAnchors = [AnchorData(id: 1, position: .zero)]
        coordinator.dispatch(.selectAnchor(id: 1))

        coordinator.dispatch(.deleteSelected)

        try? await Task.sleep(nanoseconds: 10_000_000)

        #expect(!coordinator.state.hasSelection)
    }

    // MARK: - Scene Click Tests

    @Test func handleSceneClick_withAnchorHit_togglesSelection() {
        let (coordinator, _, _) = makeSUT()

        coordinator.handleSceneClick(at: .zero, hitAnchorId: 42, hitLandmarkId: nil)

        #expect(coordinator.state.selectedAnchorIds.contains(42))
    }

    @Test func handleSceneClick_withoutAnchorHit_doesNothing() {
        let (coordinator, _, _) = makeSUT()
        coordinator.dispatch(.selectAnchor(id: 1))

        coordinator.handleSceneClick(at: .zero, hitAnchorId: nil, hitLandmarkId: nil)

        // Selection should remain unchanged
        #expect(coordinator.state.selectedAnchorIds.contains(1))
    }

    // MARK: - Protocol Conformance Tests

    @Test func conformsToToolCoordinator() {
        let (coordinator, _, _) = makeSUT()

        // Verify the coordinator can be used as ToolCoordinator
        let toolCoordinator: any ToolCoordinator = coordinator

        #expect(toolCoordinator.kind == .anchorEdit)
    }
}
