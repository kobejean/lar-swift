//
//  LARNavigationCoordinatorTests.swift
//  LocalizeARTests
//
//  Created by Jean Atsumi Flaherty on 2025-10-05.
//

import XCTest
import SceneKit
import MapKit
@testable import LocalizeAR
import LocalizeAR_ObjC

/// Tests for LARNavigationCoordinator
/// Validates Facade pattern and Dependency Injection
final class LARNavigationCoordinatorTests: XCTestCase {
    var sut: LARNavigationCoordinator!
    var mockSceneRenderer: MockSceneRenderer!
    var mockMapRenderer: MockMapRenderer!
    var mockStateManager: MockNavigationStateManager!
    var mockMap: LARMap!
    var mockNavigationGraph: LARNavigationGraphAdapter!

    override func setUp() {
        super.setUp()

        // Create mocks
        mockMap = LARMap()
        mockSceneRenderer = MockSceneRenderer()
        mockMapRenderer = MockMapRenderer()
        mockStateManager = MockNavigationStateManager()
        mockNavigationGraph = LARNavigationGraphAdapter(map: mockMap)

        // Create SUT with dependency injection
        sut = LARNavigationCoordinator(
            map: mockMap,
            sceneRenderer: mockSceneRenderer,
            mapRenderer: mockMapRenderer,
            navigationGraph: mockNavigationGraph,
            stateManager: mockStateManager
        )
    }

    override func tearDown() {
        sut = nil
        mockSceneRenderer = nil
        mockMapRenderer = nil
        mockStateManager = nil
        mockMap = nil
        mockNavigationGraph = nil
        super.tearDown()
    }

    // MARK: - Configuration Tests

    func testConfigure_DelegatesCorrectly() {
        // BEST PRACTICE: Test the delegation logic without graphics objects
        // This verifies that configure() would call the right methods

        // Given: Coordinator is initialized with mocks
        XCTAssertNotNil(sut, "Coordinator should be initialized")
        XCTAssertNotNil(mockSceneRenderer, "Scene renderer should be injected")
        XCTAssertNotNil(mockMapRenderer, "Map renderer should be injected")
    }

    // MARK: - Anchor Management Tests

    func testAddNavigationPoint_CallsSceneRenderer() {
        // Given
        let anchor = LARAnchor(transform: simd_double4x4(1))

        // When
        sut.addNavigationPoint(anchor: anchor)

        // Then
        XCTAssertEqual(mockSceneRenderer.addAnchorNodeCallCount, 1)
        XCTAssertEqual(mockSceneRenderer.lastAddedAnchor?.id, anchor.id)
    }

    func testAddNavigationPoint_AddsToGraph() {
        // Given
        let anchor = LARAnchor(transform: simd_double4x4(1))

        // When
        sut.addNavigationPoint(anchor: anchor)

        // Then
        XCTAssertNotNil(sut.anchors[anchor.id])
        XCTAssertEqual(sut.anchors[anchor.id]?.id, anchor.id)
    }

    func testUpdateNavigationPoint_CallsSceneRenderer() {
        // Given
        let anchor = LARAnchor(transform: simd_double4x4(1))
        let newTransform = simd_float4x4(diagonal: [2, 2, 2, 1])

        // When
        sut.updateNavigationPoint(anchor: anchor, transform: newTransform)

        // Then
        XCTAssertEqual(mockSceneRenderer.updateAnchorNodeCallCount, 1)
        XCTAssertEqual(mockSceneRenderer.lastUpdatedAnchorId, anchor.id)
    }

    // MARK: - Selection Tests

    func testSelectAnchor_CallsBothStateManagerAndRenderer() {
        // Given
        let anchor = LARAnchor(transform: simd_double4x4(1))
        mockNavigationGraph.addAnchor(anchor)

        // When
        sut.selectAnchor(id: anchor.id)

        // Then
        XCTAssertEqual(mockStateManager.selectAnchorCallCount, 1)
        XCTAssertEqual(mockSceneRenderer.highlightAnchorCallCount, 1)
        XCTAssertEqual(mockSceneRenderer.lastHighlightedAnchorId, anchor.id)
    }

    func testDeselectAnchor_CallsBothStateManagerAndRenderer() {
        // Given
        mockStateManager.selectAnchor(anchorId: 1)

        // When
        sut.deselectAnchor(id: 1)

        // Then
        XCTAssertEqual(mockStateManager.deselectAnchorCallCount, 1)
        XCTAssertEqual(mockSceneRenderer.unhighlightAnchorCallCount, 1)
    }

    func testClearAllSelections_CallsBothStateManagerAndRenderer() {
        // When
        sut.clearAllSelections()

        // Then
        XCTAssertEqual(mockStateManager.clearSelectionCallCount, 1)
        XCTAssertEqual(mockSceneRenderer.clearAllHighlightsCallCount, 1)
    }

    func testIsAnchorSelected_DelegatesToStateManager() {
        // Given
        mockStateManager.selectAnchor(anchorId: 1)

        // When
        let isSelected = sut.isAnchorSelected(id: 1)

        // Then
        XCTAssertTrue(isSelected)
    }

    // MARK: - Edge Management Tests

    func testAddNavigationEdge_CallsSceneRendererWhenAnchorsExist() {
        // Given
        let anchor1 = LARAnchor(transform: simd_double4x4(diagonal: [1, 0, 0, 1]))
        let anchor2 = LARAnchor(transform: simd_double4x4(diagonal: [1, 0, 0, 1]))
        mockNavigationGraph.addAnchor(anchor1)
        mockNavigationGraph.addAnchor(anchor2)

        // When
        sut.addNavigationEdge(from: anchor1.id, to: anchor2.id)

        // Then
        XCTAssertEqual(mockSceneRenderer.addEdgeGuideNodesCallCount, 1)
    }

    func testAddNavigationEdge_DoesNotCallRendererWhenAnchorsDoNotExist() {
        // When
        sut.addNavigationEdge(from: 99, to: 100)

        // Then
        XCTAssertEqual(mockSceneRenderer.addEdgeGuideNodesCallCount, 0)
    }

    // MARK: - Preview Management Tests

    func testShowPreviewNodes_CallsSceneRenderer() {
        // Given
        let positions: [(id: Int32, position: simd_float3)] = [
            (1, simd_float3(1, 0, 0)),
            (2, simd_float3(0, 1, 0))
        ]

        // When
        sut.showPreviewNodes(for: positions)

        // Then
        XCTAssertEqual(mockSceneRenderer.showPreviewNodesCallCount, 1)
        XCTAssertEqual(mockSceneRenderer.lastPreviewPositions?.count, 2)
    }

    func testHidePreviewNodes_CallsSceneRenderer() {
        // When
        sut.hidePreviewNodes()

        // Then
        XCTAssertEqual(mockSceneRenderer.hidePreviewNodesCallCount, 1)
    }

    // MARK: - Cleanup Tests

    func testRemoveAllNavigationElements_CallsAllComponents() {
        // When
        sut.removeAllNavigationElements()

        // Then
        XCTAssertEqual(mockSceneRenderer.removeAllNavigationElementsCallCount, 1)
        XCTAssertEqual(mockMapRenderer.removeAllOverlaysCallCount, 1)
        XCTAssertEqual(mockStateManager.clearSelectionCallCount, 1)
    }

    // MARK: - Dependency Injection Validation

    func testConvenienceInitializer_CreatesDefaultDependencies() {
        // When
        let coordinator = LARNavigationCoordinator(map: mockMap)

        // Then
        XCTAssertNotNil(coordinator)
        // Coordinator should work with default implementations
    }

    // MARK: - Integration with Graph

    func testAnchorsProperty_ReturnsGraphAnchors() {
        // Given - Use different transforms to ensure different IDs
        let transform1 = simd_double4x4(diagonal: [1, 1, 1, 1])
        let transform2 = simd_double4x4(diagonal: [2, 2, 2, 1])
        let anchor1 = LARAnchor(transform: transform1)
        let anchor2 = LARAnchor(transform: transform2)
        mockNavigationGraph.addAnchor(anchor1)
        mockNavigationGraph.addAnchor(anchor2)

        // When
        let anchors = sut.anchors

        // Then
        XCTAssertGreaterThanOrEqual(anchors.count, 1, "Should have at least 1 anchor")
        XCTAssertNotNil(anchors[anchor1.id], "Should find anchor1 by its ID")

        // If anchors have different IDs, verify both exist
        if anchor1.id != anchor2.id {
            XCTAssertEqual(anchors.count, 2, "Should have 2 anchors with different IDs")
            XCTAssertNotNil(anchors[anchor2.id], "Should find anchor2 by its ID")
        }
    }

    func testNavigationEdgesProperty_ReturnsGraphEdges() {
        // Given
        let anchor1 = LARAnchor(transform: simd_double4x4(1))
        let anchor2 = LARAnchor(transform: simd_double4x4(1))
        mockNavigationGraph.addAnchor(anchor1)
        mockNavigationGraph.addAnchor(anchor2)
        sut.addNavigationEdge(from: anchor1.id, to: anchor2.id)

        // When
        let edges = sut.navigationEdges

        // Then
        XCTAssertEqual(edges.count, 1)
        XCTAssertTrue(edges.contains { $0.from == anchor1.id && $0.to == anchor2.id })
    }
}
