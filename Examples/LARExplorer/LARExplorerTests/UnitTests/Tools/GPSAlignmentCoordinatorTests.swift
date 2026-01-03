//
//  GPSAlignmentCoordinatorTests.swift
//  LARExplorerTests
//
//  Created by Claude Code on 2026-01-04.
//

import Testing
import simd
@testable import LARExplorer

/// Unit tests for GPSAlignmentCoordinator
@MainActor
struct GPSAlignmentCoordinatorTests {

    // MARK: - Setup

    private func makeSUT() -> (
        coordinator: GPSAlignmentCoordinator,
        mapRepository: MockMapRepository,
        renderingService: MockRenderingService
    ) {
        let mapRepository = MockMapRepository()
        let renderingService = MockRenderingService()
        let coordinator = GPSAlignmentCoordinator(
            mapRepository: mapRepository,
            renderingService: renderingService
        )
        return (coordinator, mapRepository, renderingService)
    }

    // MARK: - Initialization Tests

    @Test func initialState_hasNoAdjustments() {
        let (coordinator, _, _) = makeSUT()

        #expect(coordinator.state == GPSAlignmentState.initial)
        #expect(!coordinator.state.hasAdjustments)
    }

    // MARK: - Activation Tests

    @Test func activate_resetsState() {
        let (coordinator, _, _) = makeSUT()
        coordinator.dispatch(.setTranslationX(10.0))

        coordinator.activate()

        #expect(coordinator.state == GPSAlignmentState.initial)
    }

    @Test func deactivate_clearsOverlays() {
        let (coordinator, _, renderingService) = makeSUT()

        coordinator.deactivate()

        #expect(renderingService.clearBoundsOverlaysCalled)
    }

    // MARK: - Translation Tests

    @Test func dispatch_setTranslationX_updatesState() {
        let (coordinator, _, _) = makeSUT()

        coordinator.dispatch(.setTranslationX(5.5))

        #expect(coordinator.state.translationX == 5.5)
    }

    @Test func dispatch_setTranslationY_updatesState() {
        let (coordinator, _, _) = makeSUT()

        coordinator.dispatch(.setTranslationY(-3.2))

        #expect(coordinator.state.translationY == -3.2)
    }

    // MARK: - Rotation Tests

    @Test func dispatch_setRotation_updatesState() {
        let (coordinator, _, _) = makeSUT()

        coordinator.dispatch(.setRotation(45.0))

        #expect(coordinator.state.rotation == 45.0)
    }

    // MARK: - Scale Tests

    @Test func dispatch_setScaleFactor_updatesState() {
        let (coordinator, _, _) = makeSUT()

        coordinator.dispatch(.setScaleFactor(1.5))

        #expect(coordinator.state.scaleFactor == 1.5)
    }

    // MARK: - Apply Alignment Tests

    @Test func dispatch_applyAlignment_updatesOrigin() async {
        let (coordinator, mapRepository, _) = makeSUT()
        coordinator.dispatch(.setTranslationX(5.0))
        coordinator.dispatch(.setTranslationY(3.0))
        coordinator.dispatch(.setRotation(45.0))

        coordinator.dispatch(.applyAlignment)

        try? await Task.sleep(nanoseconds: 10_000_000)

        #expect(!mapRepository.updateOriginCalls.isEmpty)
    }

    @Test func dispatch_applyAlignment_refreshesRendering() async {
        let (coordinator, _, renderingService) = makeSUT()
        coordinator.dispatch(.setTranslationX(5.0))

        coordinator.dispatch(.applyAlignment)

        try? await Task.sleep(nanoseconds: 10_000_000)

        #expect(renderingService.refreshAllCalled)
    }

    // MARK: - Reset Tests

    @Test func dispatch_reset_clearsAllAdjustments() {
        let (coordinator, _, _) = makeSUT()
        coordinator.dispatch(.setTranslationX(10.0))
        coordinator.dispatch(.setRotation(45.0))

        coordinator.dispatch(.reset)

        #expect(coordinator.state == GPSAlignmentState.initial)
    }

    // MARK: - Protocol Conformance Tests

    @Test func conformsToToolCoordinator() {
        let (coordinator, _, _) = makeSUT()

        let toolCoordinator: any ToolCoordinator = coordinator

        #expect(toolCoordinator.kind == .gpsAlignment)
    }
}
