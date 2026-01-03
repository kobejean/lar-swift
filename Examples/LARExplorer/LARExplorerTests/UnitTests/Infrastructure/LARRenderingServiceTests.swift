//
//  LARRenderingServiceTests.swift
//  LARExplorerTests
//
//  Created by Claude Code on 2026-01-04.
//

import Testing
import simd
@testable import LARExplorer

/// Unit tests for LARRenderingService
/// Verifies that commands are correctly delegated to scene and map renderers
@MainActor
struct LARRenderingServiceTests {

    // MARK: - Setup

    private func makeSUT() -> (
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

    // MARK: - Anchor Highlight Tests

    @Test func highlightAnchors_delegatesToSceneRenderer() {
        let (service, sceneRenderer, _) = makeSUT()

        service.highlightAnchors([1, 2, 3], style: .selected)

        #expect(sceneRenderer.highlightAnchorsCalls.count == 1)
        #expect(sceneRenderer.highlightAnchorsCalls.first?.ids == [1, 2, 3])
        #expect(sceneRenderer.highlightAnchorsCalls.first?.style == .selected)
    }

    @Test func clearAnchorHighlights_delegatesToSceneRenderer() {
        let (service, sceneRenderer, _) = makeSUT()

        service.clearAnchorHighlights()

        #expect(sceneRenderer.clearAnchorHighlightsCalled)
    }

    // MARK: - Preview Node Tests

    @Test func showPreviewNodes_delegatesToSceneRenderer() {
        let (service, sceneRenderer, _) = makeSUT()
        let positions: [Int32: SIMD3<Float>] = [1: SIMD3(1, 0, 0), 2: SIMD3(0, 1, 0)]

        service.showPreviewNodes(at: positions)

        #expect(sceneRenderer.showPreviewNodesCalls.count == 1)
        #expect(sceneRenderer.showPreviewNodesCalls.first?.positions[1] == SIMD3(1, 0, 0))
    }

    @Test func hidePreviewNodes_delegatesToSceneRenderer() {
        let (service, sceneRenderer, _) = makeSUT()

        service.hidePreviewNodes()

        #expect(sceneRenderer.hidePreviewNodesCalled)
    }

    // MARK: - Edge Highlight Tests

    @Test func highlightEdge_delegatesToMapRenderer() {
        let (service, _, mapRenderer) = makeSUT()

        service.highlightEdge(from: 1, to: 2, style: .selected)

        #expect(mapRenderer.highlightEdgeCalls.count == 1)
        #expect(mapRenderer.highlightEdgeCalls.first?.fromId == 1)
        #expect(mapRenderer.highlightEdgeCalls.first?.toId == 2)
        #expect(mapRenderer.highlightEdgeCalls.first?.style == .selected)
    }

    @Test func clearEdgeHighlights_delegatesToMapRenderer() {
        let (service, _, mapRenderer) = makeSUT()

        service.clearEdgeHighlights()

        #expect(mapRenderer.clearEdgeHighlightsCalled)
    }

    // MARK: - Edge Operation Tests

    @Test func addEdge_delegatesToMapRenderer() {
        let (service, _, mapRenderer) = makeSUT()

        service.addEdge(from: 1, to: 2)

        #expect(mapRenderer.addEdgeCalls.count == 1)
        #expect(mapRenderer.addEdgeCalls.first?.fromId == 1)
        #expect(mapRenderer.addEdgeCalls.first?.toId == 2)
    }

    @Test func removeEdge_delegatesToMapRenderer() {
        let (service, _, mapRenderer) = makeSUT()

        service.removeEdge(from: 1, to: 2)

        #expect(mapRenderer.removeEdgeCalls.count == 1)
        #expect(mapRenderer.removeEdgeCalls.first?.fromId == 1)
        #expect(mapRenderer.removeEdgeCalls.first?.toId == 2)
    }

    // MARK: - Landmark Highlight Tests

    @Test func highlightLandmarks_delegatesToSceneRenderer() {
        let (service, sceneRenderer, _) = makeSUT()

        service.highlightLandmarks([10, 20, 30], style: .inlier)

        #expect(sceneRenderer.highlightLandmarksCalls.count == 1)
        #expect(sceneRenderer.highlightLandmarksCalls.first?.ids == [10, 20, 30])
        #expect(sceneRenderer.highlightLandmarksCalls.first?.style == .inlier)
    }

    @Test func clearLandmarkHighlights_delegatesToSceneRenderer() {
        let (service, sceneRenderer, _) = makeSUT()

        service.clearLandmarkHighlights()

        #expect(sceneRenderer.clearLandmarkHighlightsCalled)
    }

    // MARK: - Bounds Overlay Tests

    @Test func showBoundsOverlay_delegatesToMapRenderer() {
        let (service, _, mapRenderer) = makeSUT()
        let lower = SIMD2<Double>(0, 0)
        let upper = SIMD2<Double>(10, 10)

        service.showBoundsOverlay(lower: lower, upper: upper)

        #expect(mapRenderer.showBoundsOverlayCalls.count == 1)
        #expect(mapRenderer.showBoundsOverlayCalls.first?.lower == lower)
        #expect(mapRenderer.showBoundsOverlayCalls.first?.upper == upper)
    }

    @Test func clearBoundsOverlays_delegatesToMapRenderer() {
        let (service, _, mapRenderer) = makeSUT()

        service.clearBoundsOverlays()

        #expect(mapRenderer.clearBoundsOverlaysCalled)
    }

    @Test func refreshMapOverlays_delegatesToMapRenderer() {
        let (service, _, mapRenderer) = makeSUT()

        service.refreshMapOverlays()

        #expect(mapRenderer.refreshOverlaysCalled)
    }

    // MARK: - Refresh All Tests

    @Test func refreshAll_delegatesToBothRenderers() {
        let (service, sceneRenderer, mapRenderer) = makeSUT()

        service.refreshAll()

        #expect(sceneRenderer.refreshCalled)
        #expect(mapRenderer.refreshOverlaysCalled)
    }

    // MARK: - Visibility Tests

    @Test func setPointCloudVisible_delegatesToSceneRenderer() {
        let (service, sceneRenderer, _) = makeSUT()

        service.setPointCloudVisible(true)

        #expect(sceneRenderer.setPointCloudVisibleCalls == [true])
    }

    @Test func setNavigationNodesVisible_delegatesToSceneRenderer() {
        let (service, sceneRenderer, _) = makeSUT()

        service.setNavigationNodesVisible(false)

        #expect(sceneRenderer.setNavigationNodesVisibleCalls == [false])
    }

    @Test func setNavigationEdgesVisible_delegatesToSceneRenderer() {
        let (service, sceneRenderer, _) = makeSUT()

        service.setNavigationEdgesVisible(true)

        #expect(sceneRenderer.setNavigationEdgesVisibleCalls == [true])
    }

    // MARK: - Protocol Conformance

    @Test func conformsToRenderingService() {
        let (service, _, _) = makeSUT()

        let renderingService: RenderingService = service

        #expect(renderingService is LARRenderingService)
    }
}
