//
//  EdgeEditCoordinatorTests.swift
//  LARExplorerTests
//
//  Created by Claude Code on 2026-01-04.
//

import Testing
import simd
@testable import LARExplorer

/// Unit tests for EdgeEditCoordinator
/// Tests verify the two-click edge creation flow and rendering commands
@MainActor
struct EdgeEditCoordinatorTests {

    // MARK: - Setup

    private func makeSUT() -> (
        coordinator: EdgeEditCoordinator,
        mapRepository: MockMapRepository,
        renderingService: MockRenderingService
    ) {
        let mapRepository = MockMapRepository()
        let renderingService = MockRenderingService()
        let coordinator = EdgeEditCoordinator(
            mapRepository: mapRepository,
            renderingService: renderingService
        )
        return (coordinator, mapRepository, renderingService)
    }

    // MARK: - Initialization Tests

    @Test func initialState_hasNoSourceAnchor() {
        let (coordinator, _, _) = makeSUT()

        #expect(coordinator.state == EdgeEditState.initial)
        #expect(!coordinator.state.isAwaitingTarget)
    }

    // MARK: - Activation Tests

    @Test func activate_resetsState() {
        let (coordinator, _, _) = makeSUT()
        coordinator.dispatch(.clickAnchor(id: 1))

        coordinator.activate()

        #expect(coordinator.state == EdgeEditState.initial)
    }

    @Test func deactivate_clearsHighlights() {
        let (coordinator, _, renderingService) = makeSUT()
        coordinator.dispatch(.clickAnchor(id: 1))

        coordinator.deactivate()

        #expect(renderingService.clearAnchorHighlightsCalled)
        #expect(renderingService.clearEdgeHighlightsCalled)
    }

    // MARK: - First Click Tests

    @Test func dispatch_firstClick_setsSourceAnchor() {
        let (coordinator, _, _) = makeSUT()

        coordinator.dispatch(.clickAnchor(id: 42))

        #expect(coordinator.state.sourceAnchorId == 42)
        #expect(coordinator.state.isAwaitingTarget)
    }

    @Test func dispatch_firstClick_highlightsSourceAnchor() {
        let (coordinator, _, renderingService) = makeSUT()

        coordinator.dispatch(.clickAnchor(id: 42))

        #expect(renderingService.highlightedAnchorIds == [42])
        #expect(renderingService.lastHighlightStyle == .selected)
    }

    // MARK: - Second Click Tests (Edge Creation)

    @Test func dispatch_secondClick_onDifferentAnchor_addsEdge() async {
        let (coordinator, mapRepository, _) = makeSUT()
        mapRepository.stubbedEdges = [] // No existing edge

        coordinator.dispatch(.clickAnchor(id: 1))
        coordinator.dispatch(.clickAnchor(id: 2))

        // Wait for side effect
        try? await Task.sleep(nanoseconds: 10_000_000)

        #expect(mapRepository.addEdgeCalls.count == 1)
        #expect(mapRepository.addEdgeCalls.first?.fromId == 1)
        #expect(mapRepository.addEdgeCalls.first?.toId == 2)
    }

    @Test func dispatch_secondClick_onExistingEdge_removesEdge() async {
        let (coordinator, mapRepository, _) = makeSUT()
        mapRepository.stubbedEdges = [EdgeData(fromId: 1, toId: 2)]

        coordinator.dispatch(.clickAnchor(id: 1))
        coordinator.dispatch(.clickAnchor(id: 2))

        // Wait for side effect
        try? await Task.sleep(nanoseconds: 10_000_000)

        #expect(mapRepository.removeEdgeCalls.count == 1)
        #expect(mapRepository.removeEdgeCalls.first?.fromId == 1)
        #expect(mapRepository.removeEdgeCalls.first?.toId == 2)
    }

    @Test func dispatch_secondClick_clearsSourceAnchor() {
        let (coordinator, _, _) = makeSUT()

        coordinator.dispatch(.clickAnchor(id: 1))
        coordinator.dispatch(.clickAnchor(id: 2))

        #expect(coordinator.state.sourceAnchorId == nil)
        #expect(!coordinator.state.isAwaitingTarget)
    }

    @Test func dispatch_secondClick_onSameAnchor_doesNothing() async {
        let (coordinator, mapRepository, _) = makeSUT()

        coordinator.dispatch(.clickAnchor(id: 1))
        coordinator.dispatch(.clickAnchor(id: 1))

        // Wait a bit
        try? await Task.sleep(nanoseconds: 10_000_000)

        // Source should still be set (no edge created, no reset)
        #expect(coordinator.state.sourceAnchorId == 1)
        #expect(mapRepository.addEdgeCalls.isEmpty)
        #expect(mapRepository.removeEdgeCalls.isEmpty)
    }

    @Test func dispatch_secondClick_refreshesRendering() async {
        let (coordinator, _, renderingService) = makeSUT()

        coordinator.dispatch(.clickAnchor(id: 1))
        coordinator.dispatch(.clickAnchor(id: 2))

        try? await Task.sleep(nanoseconds: 10_000_000)

        #expect(renderingService.refreshAllCalled)
    }

    // MARK: - Cancel Tests

    @Test func dispatch_cancelEdgeCreation_clearsSource() {
        let (coordinator, _, _) = makeSUT()
        coordinator.dispatch(.clickAnchor(id: 1))

        coordinator.dispatch(.cancelEdgeCreation)

        #expect(coordinator.state.sourceAnchorId == nil)
    }

    @Test func dispatch_cancelEdgeCreation_clearsHighlights() {
        let (coordinator, _, renderingService) = makeSUT()
        coordinator.dispatch(.clickAnchor(id: 1))

        coordinator.dispatch(.cancelEdgeCreation)

        #expect(renderingService.clearAnchorHighlightsCalled)
    }

    // MARK: - Scene Click Tests

    @Test func handleSceneClick_withAnchorHit_dispatchesClickAnchor() {
        let (coordinator, _, _) = makeSUT()

        coordinator.handleSceneClick(at: .zero, hitAnchorId: 99, hitLandmarkId: nil)

        #expect(coordinator.state.sourceAnchorId == 99)
    }

    @Test func handleSceneClick_withoutAnchorHit_cancelsEdgeCreation() {
        let (coordinator, _, _) = makeSUT()
        coordinator.dispatch(.clickAnchor(id: 1))

        coordinator.handleSceneClick(at: .zero, hitAnchorId: nil, hitLandmarkId: nil)

        #expect(coordinator.state.sourceAnchorId == nil)
    }

    // MARK: - Protocol Conformance Tests

    @Test func conformsToToolCoordinator() {
        let (coordinator, _, _) = makeSUT()

        let toolCoordinator: any ToolCoordinator = coordinator

        #expect(toolCoordinator.kind == .edgeEdit)
    }
}
