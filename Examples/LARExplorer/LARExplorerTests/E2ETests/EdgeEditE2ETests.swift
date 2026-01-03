//
//  EdgeEditE2ETests.swift
//  LARExplorerTests
//
//  Created by Claude Code on 2026-01-04.
//

import Testing
import simd
@testable import LARExplorer

/// End-to-End tests for edge editing workflows
/// Verifies complete user flows for edge creation and removal
@MainActor
struct EdgeEditE2ETests {

    // MARK: - Setup

    private func makeSUT() -> (
        coordinator: EdgeEditCoordinator,
        repository: MockMapRepository,
        rendering: MockRenderingService
    ) {
        let repository = MockMapRepository()
        let rendering = MockRenderingService()
        let coordinator = EdgeEditCoordinator(
            mapRepository: repository,
            renderingService: rendering
        )
        return (coordinator, repository, rendering)
    }

    // MARK: - E2E: Create Edge Between Two Anchors

    @Test func e2e_createEdgeBetweenAnchors() async {
        // Given: A map with anchors but no edges
        let (coordinator, repository, rendering) = makeSUT()
        repository.mockAnchors = [
            AnchorData(id: 1, position: .zero),
            AnchorData(id: 2, position: SIMD3<Float>(1, 0, 0))
        ]
        repository.stubbedEdges = [] // No existing edges

        // When: User activates tool
        coordinator.activate()
        #expect(coordinator.state == EdgeEditState.initial)

        // When: User clicks first anchor
        coordinator.handleSceneClick(at: .zero, hitAnchorId: 1, hitLandmarkId: nil)

        // Then: Source anchor is selected and highlighted
        #expect(coordinator.state.sourceAnchorId == 1)
        #expect(coordinator.state.isAwaitingTarget)
        #expect(rendering.highlightedAnchorIds == [1])

        // When: User clicks second anchor
        coordinator.handleSceneClick(at: .zero, hitAnchorId: 2, hitLandmarkId: nil)

        // Wait for async side effect
        try? await Task.sleep(nanoseconds: 50_000_000)

        // Then: Edge is added to repository
        #expect(repository.addEdgeCalls.count == 1)
        #expect(repository.addEdgeCalls.first?.fromId == 1)
        #expect(repository.addEdgeCalls.first?.toId == 2)

        // Then: State is reset
        #expect(coordinator.state.sourceAnchorId == nil)

        // Then: Scene is refreshed
        #expect(rendering.refreshAllCalled)
    }

    // MARK: - E2E: Remove Existing Edge

    @Test func e2e_removeExistingEdge() async {
        // Given: A map with an existing edge
        let (coordinator, repository, _) = makeSUT()
        repository.mockAnchors = [
            AnchorData(id: 1, position: .zero),
            AnchorData(id: 2, position: SIMD3<Float>(1, 0, 0))
        ]
        repository.stubbedEdges = [EdgeData(fromId: 1, toId: 2)]

        // When: User activates tool and clicks both anchors
        coordinator.activate()
        coordinator.handleSceneClick(at: .zero, hitAnchorId: 1, hitLandmarkId: nil)
        coordinator.handleSceneClick(at: .zero, hitAnchorId: 2, hitLandmarkId: nil)

        // Wait for async side effect
        try? await Task.sleep(nanoseconds: 50_000_000)

        // Then: Edge is removed from repository
        #expect(repository.removeEdgeCalls.count == 1)
        #expect(repository.removeEdgeCalls.first?.fromId == 1)
        #expect(repository.removeEdgeCalls.first?.toId == 2)
    }

    // MARK: - E2E: Cancel Edge Creation

    @Test func e2e_cancelEdgeCreation() {
        // Given: User has selected a source anchor
        let (coordinator, repository, rendering) = makeSUT()
        repository.mockAnchors = [
            AnchorData(id: 1, position: .zero),
            AnchorData(id: 2, position: .zero)
        ]

        coordinator.activate()
        coordinator.handleSceneClick(at: .zero, hitAnchorId: 1, hitLandmarkId: nil)
        #expect(coordinator.state.sourceAnchorId == 1)

        // When: User clicks on empty space
        coordinator.handleSceneClick(at: .zero, hitAnchorId: nil, hitLandmarkId: nil)

        // Then: Edge creation is cancelled
        #expect(coordinator.state.sourceAnchorId == nil)
        #expect(rendering.clearAnchorHighlightsCalled)

        // Then: No edge was created
        #expect(repository.addEdgeCalls.isEmpty)
    }

    // MARK: - E2E: Self-Loop Prevention

    @Test func e2e_preventSelfLoop() async {
        // Given: User has selected a source anchor
        let (coordinator, repository, _) = makeSUT()
        repository.mockAnchors = [AnchorData(id: 1, position: .zero)]

        coordinator.activate()
        coordinator.handleSceneClick(at: .zero, hitAnchorId: 1, hitLandmarkId: nil)

        // When: User clicks the same anchor again
        coordinator.handleSceneClick(at: .zero, hitAnchorId: 1, hitLandmarkId: nil)

        // Wait a moment
        try? await Task.sleep(nanoseconds: 50_000_000)

        // Then: No edge is created (self-loops not allowed)
        #expect(repository.addEdgeCalls.isEmpty)

        // Then: Source is still selected (waiting for valid target)
        #expect(coordinator.state.sourceAnchorId == 1)
    }

    // MARK: - E2E: Multiple Edge Creation

    @Test func e2e_createMultipleEdges() async {
        // Given: A map with three anchors
        let (coordinator, repository, _) = makeSUT()
        repository.mockAnchors = [
            AnchorData(id: 1, position: .zero),
            AnchorData(id: 2, position: SIMD3<Float>(1, 0, 0)),
            AnchorData(id: 3, position: SIMD3<Float>(2, 0, 0))
        ]
        repository.stubbedEdges = []

        coordinator.activate()

        // When: Create edge 1-2
        coordinator.handleSceneClick(at: .zero, hitAnchorId: 1, hitLandmarkId: nil)
        coordinator.handleSceneClick(at: .zero, hitAnchorId: 2, hitLandmarkId: nil)
        try? await Task.sleep(nanoseconds: 50_000_000)

        // When: Create edge 2-3
        coordinator.handleSceneClick(at: .zero, hitAnchorId: 2, hitLandmarkId: nil)
        coordinator.handleSceneClick(at: .zero, hitAnchorId: 3, hitLandmarkId: nil)
        try? await Task.sleep(nanoseconds: 50_000_000)

        // Then: Both edges are created
        #expect(repository.addEdgeCalls.count == 2)
    }
}
