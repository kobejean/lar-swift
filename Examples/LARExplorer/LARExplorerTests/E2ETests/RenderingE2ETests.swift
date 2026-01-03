//
//  RenderingE2ETests.swift
//  LARExplorerTests
//
//  Created by Claude Code on 2026-01-04.
//

import Testing
import simd
@testable import LARExplorer

/// End-to-End tests for rendering command flow
/// Verifies that coordinator actions result in correct rendering commands
@MainActor
struct RenderingE2ETests {

    // MARK: - Setup

    private func makeRenderingService() -> (
        service: LARRenderingService,
        sceneRenderer: MockSceneRendering,
        mapRenderer: MockMapRendering
    ) {
        let sceneRenderer = MockSceneRendering()
        let mapRenderer = MockMapRendering()
        let service = LARRenderingService(
            sceneRenderer: sceneRenderer,
            mapRenderer: mapRenderer
        )
        return (service, sceneRenderer, mapRenderer)
    }

    // MARK: - E2E: Anchor Highlight Flow

    @Test func e2e_anchorHighlightRendering() {
        // Given: A rendering service with mock adapters
        let (service, sceneRenderer, _) = makeRenderingService()

        // When: Highlight anchors
        service.highlightAnchors([1, 2, 3], style: .selected)

        // Then: Scene renderer receives the command
        #expect(sceneRenderer.highlightAnchorsCalls.count == 1)
        #expect(sceneRenderer.highlightAnchorsCalls.first?.ids == [1, 2, 3])
        #expect(sceneRenderer.highlightAnchorsCalls.first?.style == .selected)

        // When: Clear highlights
        service.clearAnchorHighlights()

        // Then: Scene renderer receives clear command
        #expect(sceneRenderer.clearAnchorHighlightsCalled)
    }

    // MARK: - E2E: Preview Node Flow

    @Test func e2e_previewNodeRendering() {
        // Given: A rendering service
        let (service, sceneRenderer, _) = makeRenderingService()
        let positions: [Int32: SIMD3<Float>] = [
            1: SIMD3(1, 0, 0),
            2: SIMD3(2, 0, 0)
        ]

        // When: Show preview nodes
        service.showPreviewNodes(at: positions)

        // Then: Scene renderer shows previews
        #expect(sceneRenderer.showPreviewNodesCalls.count == 1)

        // When: Hide preview nodes
        service.hidePreviewNodes()

        // Then: Scene renderer hides previews
        #expect(sceneRenderer.hidePreviewNodesCalled)
    }

    // MARK: - E2E: Edge Rendering Flow

    @Test func e2e_edgeRendering() {
        // Given: A rendering service
        let (service, _, mapRenderer) = makeRenderingService()

        // When: Add an edge
        service.addEdge(from: 1, to: 2)

        // Then: Map renderer receives add command
        #expect(mapRenderer.addEdgeCalls.count == 1)
        #expect(mapRenderer.addEdgeCalls.first?.fromId == 1)
        #expect(mapRenderer.addEdgeCalls.first?.toId == 2)

        // When: Highlight the edge
        service.highlightEdge(from: 1, to: 2, style: .selected)

        // Then: Map renderer receives highlight command
        #expect(mapRenderer.highlightEdgeCalls.count == 1)

        // When: Remove the edge
        service.removeEdge(from: 1, to: 2)

        // Then: Map renderer receives remove command
        #expect(mapRenderer.removeEdgeCalls.count == 1)
    }

    // MARK: - E2E: Landmark Highlight Flow

    @Test func e2e_landmarkHighlightRendering() {
        // Given: A rendering service
        let (service, sceneRenderer, _) = makeRenderingService()

        // When: Highlight landmarks with different styles
        service.highlightLandmarks([10, 20], style: .spatialQuery)
        #expect(sceneRenderer.highlightLandmarksCalls.last?.style == .spatialQuery)

        service.highlightLandmarks([10], style: .matched)
        #expect(sceneRenderer.highlightLandmarksCalls.last?.style == .matched)

        service.highlightLandmarks([10], style: .inlier)
        #expect(sceneRenderer.highlightLandmarksCalls.last?.style == .inlier)

        // When: Clear landmarks
        service.clearLandmarkHighlights()

        // Then: Scene renderer receives clear command
        #expect(sceneRenderer.clearLandmarkHighlightsCalled)
    }

    // MARK: - E2E: Bounds Overlay Flow

    @Test func e2e_boundsOverlayRendering() {
        // Given: A rendering service
        let (service, _, mapRenderer) = makeRenderingService()
        let lower = SIMD2<Double>(35.0, 139.0)
        let upper = SIMD2<Double>(36.0, 140.0)

        // When: Show bounds overlay
        service.showBoundsOverlay(lower: lower, upper: upper)

        // Then: Map renderer receives bounds command
        #expect(mapRenderer.showBoundsOverlayCalls.count == 1)
        #expect(mapRenderer.showBoundsOverlayCalls.first?.lower == lower)
        #expect(mapRenderer.showBoundsOverlayCalls.first?.upper == upper)

        // When: Clear bounds
        service.clearBoundsOverlays()

        // Then: Map renderer receives clear command
        #expect(mapRenderer.clearBoundsOverlaysCalled)
    }

    // MARK: - E2E: Visibility Toggle Flow

    @Test func e2e_visibilityToggleRendering() {
        // Given: A rendering service
        let (service, sceneRenderer, _) = makeRenderingService()

        // When: Toggle point cloud visibility
        service.setPointCloudVisible(true)
        service.setPointCloudVisible(false)

        // Then: Scene renderer receives visibility commands
        #expect(sceneRenderer.setPointCloudVisibleCalls == [true, false])

        // When: Toggle navigation visibility
        service.setNavigationNodesVisible(true)
        service.setNavigationEdgesVisible(true)

        // Then: Scene renderer receives commands
        #expect(sceneRenderer.setNavigationNodesVisibleCalls == [true])
        #expect(sceneRenderer.setNavigationEdgesVisibleCalls == [true])
    }

    // MARK: - E2E: Refresh All Flow

    @Test func e2e_refreshAllRendering() {
        // Given: A rendering service
        let (service, sceneRenderer, mapRenderer) = makeRenderingService()

        // When: Refresh all
        service.refreshAll()

        // Then: Both renderers are refreshed
        #expect(sceneRenderer.refreshCalled)
        #expect(mapRenderer.refreshOverlaysCalled)
    }

    // MARK: - E2E: Full Coordinator → Rendering Flow

    @Test func e2e_fullCoordinatorToRenderingFlow() async {
        // Given: A complete system with coordinator and rendering service
        let (renderingService, sceneRenderer, _) = makeRenderingService()
        let repository = MockMapRepository()
        repository.mockAnchors = [
            AnchorData(id: 1, position: SIMD3<Float>(0, 0, 0)),
            AnchorData(id: 2, position: SIMD3<Float>(1, 0, 0))
        ]

        let coordinator = AnchorEditCoordinator(
            mapRepository: repository,
            renderingService: renderingService
        )

        // When: Complete workflow - activate, select, offset, apply
        coordinator.activate()
        coordinator.handleSceneClick(at: .zero, hitAnchorId: 1, hitLandmarkId: nil)

        // Then: Scene renderer highlights the anchor
        #expect(sceneRenderer.highlightAnchorsCalls.last?.ids == [1])

        coordinator.dispatch(.setOffset(SIMD3<Float>(0, 5, 0)))
        coordinator.dispatch(.setPreviewingOffset(true))

        // Then: Scene renderer shows preview
        #expect(!sceneRenderer.showPreviewNodesCalls.isEmpty)

        coordinator.dispatch(.applyOffset)
        try? await Task.sleep(nanoseconds: 50_000_000)

        // Then: Scene renderer is refreshed
        #expect(sceneRenderer.refreshCalled)
    }
}
