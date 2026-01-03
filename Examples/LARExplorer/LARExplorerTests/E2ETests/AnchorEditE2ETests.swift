//
//  AnchorEditE2ETests.swift
//  LARExplorerTests
//
//  Created by Claude Code on 2026-01-04.
//

import Testing
import simd
@testable import LARExplorer

/// End-to-End tests for anchor editing workflows
/// Verifies complete user flows from input to rendering
@MainActor
struct AnchorEditE2ETests {

    // MARK: - Setup

    private func makeSUT() -> (
        coordinator: AnchorEditCoordinator,
        repository: MockMapRepository,
        rendering: MockRenderingService
    ) {
        let repository = MockMapRepository()
        let rendering = MockRenderingService()
        let coordinator = AnchorEditCoordinator(
            mapRepository: repository,
            renderingService: rendering
        )
        return (coordinator, repository, rendering)
    }

    // MARK: - E2E: Select Anchors → Apply Offset → Verify Repository Updated

    @Test func e2e_selectAnchorsAndApplyOffset() async {
        // Given: A map with multiple anchors
        let (coordinator, repository, rendering) = makeSUT()
        repository.mockAnchors = [
            AnchorData(id: 1, position: SIMD3<Float>(0, 0, 0)),
            AnchorData(id: 2, position: SIMD3<Float>(1, 0, 0)),
            AnchorData(id: 3, position: SIMD3<Float>(2, 0, 0))
        ]

        // When: User activates tool
        coordinator.activate()

        // When: User selects anchors 1 and 2 via scene clicks
        coordinator.handleSceneClick(at: .zero, hitAnchorId: 1, hitLandmarkId: nil)
        coordinator.handleSceneClick(at: .zero, hitAnchorId: 2, hitLandmarkId: nil)

        // Then: Both anchors are selected and highlighted
        #expect(coordinator.state.selectedAnchorIds == [1, 2])
        #expect(rendering.highlightedAnchorIds == [1, 2])

        // When: User sets an offset
        coordinator.dispatch(.setOffset(SIMD3<Float>(0, 5, 0)))

        // Then: State reflects the offset
        #expect(coordinator.state.positionOffset == SIMD3<Float>(0, 5, 0))

        // When: User previews the offset
        coordinator.dispatch(.setPreviewingOffset(true))

        // Then: Preview nodes are shown at new positions
        #expect(rendering.previewNodePositions != nil)
        #expect(rendering.previewNodePositions?[1] == SIMD3<Float>(0, 5, 0))
        #expect(rendering.previewNodePositions?[2] == SIMD3<Float>(1, 5, 0))

        // When: User applies the offset
        coordinator.dispatch(.applyOffset)

        // Wait for async side effect
        try? await Task.sleep(nanoseconds: 50_000_000)

        // Then: Repository is updated with new positions
        #expect(repository.updatePositionCalls.count == 2)

        // Then: Selection is cleared
        #expect(coordinator.state.selectedAnchorIds.isEmpty)
        #expect(coordinator.state.positionOffset == .zero)

        // Then: Scene is refreshed
        #expect(rendering.refreshAllCalled)
    }

    // MARK: - E2E: Select and Delete Anchors

    @Test func e2e_selectAndDeleteAnchors() async {
        // Given: A map with anchors
        let (coordinator, repository, _) = makeSUT()
        repository.mockAnchors = [
            AnchorData(id: 1, position: .zero),
            AnchorData(id: 2, position: .zero)
        ]

        // When: User activates and selects an anchor
        coordinator.activate()
        coordinator.handleSceneClick(at: .zero, hitAnchorId: 1, hitLandmarkId: nil)

        // When: User deletes the selected anchor
        coordinator.dispatch(.deleteSelected)

        // Wait for async side effect
        try? await Task.sleep(nanoseconds: 50_000_000)

        // Then: Anchor is deleted from repository
        #expect(repository.deletedAnchorIds.contains(1))

        // Then: Selection is cleared
        #expect(coordinator.state.selectedAnchorIds.isEmpty)
    }

    // MARK: - E2E: Toggle Selection

    @Test func e2e_toggleAnchorSelection() {
        // Given: A map with anchors
        let (coordinator, repository, rendering) = makeSUT()
        repository.mockAnchors = [
            AnchorData(id: 1, position: .zero),
            AnchorData(id: 2, position: .zero)
        ]

        coordinator.activate()

        // When: User clicks anchor 1
        coordinator.handleSceneClick(at: .zero, hitAnchorId: 1, hitLandmarkId: nil)
        #expect(coordinator.state.selectedAnchorIds == [1])

        // When: User clicks anchor 1 again (toggle off)
        coordinator.handleSceneClick(at: .zero, hitAnchorId: 1, hitLandmarkId: nil)
        #expect(coordinator.state.selectedAnchorIds.isEmpty)

        // When: User clicks anchor 2
        coordinator.handleSceneClick(at: .zero, hitAnchorId: 2, hitLandmarkId: nil)
        #expect(coordinator.state.selectedAnchorIds == [2])

        // Then: Rendering reflects the current selection
        #expect(rendering.highlightedAnchorIds == [2])
    }

    // MARK: - E2E: Deactivation Clears State

    @Test func e2e_deactivationClearsState() {
        // Given: An active tool with selection
        let (coordinator, repository, rendering) = makeSUT()
        repository.mockAnchors = [AnchorData(id: 1, position: .zero)]

        coordinator.activate()
        coordinator.handleSceneClick(at: .zero, hitAnchorId: 1, hitLandmarkId: nil)
        coordinator.dispatch(.setOffset(SIMD3<Float>(1, 0, 0)))
        coordinator.dispatch(.setPreviewingOffset(true))

        // When: Tool is deactivated
        coordinator.deactivate()

        // Then: All state is cleared
        #expect(coordinator.state == AnchorEditState.initial)

        // Then: All highlights are cleared
        #expect(rendering.clearAnchorHighlightsCalled)
        #expect(rendering.hidePreviewNodesCalled)
    }
}
