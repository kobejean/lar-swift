//
//  LARNavigationStateManagerTests.swift
//  LocalizeARTests
//
//  Created by Jean Atsumi Flaherty on 2025-10-05.
//

import XCTest
import CoreLocation
@testable import LocalizeAR

/// Tests for LARNavigationStateManager
/// Validates Single Responsibility Principle: State management only
final class LARNavigationStateManagerTests: XCTestCase {
    var sut: LARNavigationStateManager!

    override func setUp() {
        super.setUp()
        sut = LARNavigationStateManager()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Selection Tests

    func testSelectAnchor_AddsToSelectedSet() {
        // When
        sut.selectAnchor(anchorId: 1)

        // Then
        XCTAssertTrue(sut.selectedAnchorIds.contains(1))
        XCTAssertEqual(sut.selectedAnchorIds.count, 1)
    }

    func testSelectAnchor_MultipleAnchors_AddsAll() {
        // When
        sut.selectAnchor(anchorId: 1)
        sut.selectAnchor(anchorId: 2)
        sut.selectAnchor(anchorId: 3)

        // Then
        XCTAssertEqual(sut.selectedAnchorIds.count, 3)
        XCTAssertTrue(sut.selectedAnchorIds.contains(1))
        XCTAssertTrue(sut.selectedAnchorIds.contains(2))
        XCTAssertTrue(sut.selectedAnchorIds.contains(3))
    }

    func testDeselectAnchor_RemovesFromSelectedSet() {
        // Given
        sut.selectAnchor(anchorId: 1)
        sut.selectAnchor(anchorId: 2)

        // When
        sut.deselectAnchor(anchorId: 1)

        // Then
        XCTAssertFalse(sut.selectedAnchorIds.contains(1))
        XCTAssertTrue(sut.selectedAnchorIds.contains(2))
        XCTAssertEqual(sut.selectedAnchorIds.count, 1)
    }

    func testIsAnchorSelected_ReturnsCorrectState() {
        // Given
        sut.selectAnchor(anchorId: 1)

        // Then
        XCTAssertTrue(sut.isAnchorSelected(anchorId: 1))
        XCTAssertFalse(sut.isAnchorSelected(anchorId: 2))
    }

    func testClearSelection_RemovesAllSelections() {
        // Given
        sut.selectAnchor(anchorId: 1)
        sut.selectAnchor(anchorId: 2)
        sut.selectAnchor(anchorId: 3)

        // When
        sut.clearSelection()

        // Then
        XCTAssertTrue(sut.selectedAnchorIds.isEmpty)
    }

    // MARK: - User Location Tests

    func testUpdateUserLocation_StoresLocation() {
        // Given
        let location = CLLocation(latitude: 37.7749, longitude: -122.4194)

        // When
        sut.updateUserLocation(location)

        // Then
        XCTAssertEqual(sut.userLocation!.coordinate.latitude, 37.7749, accuracy: 0.0001)
        XCTAssertEqual(sut.userLocation!.coordinate.longitude, -122.4194, accuracy: 0.0001)
    }

    func testUpdateUserLocation_ReplacesExistingLocation() {
        // Given
        let location1 = CLLocation(latitude: 37.7749, longitude: -122.4194)
        let location2 = CLLocation(latitude: 40.7128, longitude: -74.0060)

        // When
        sut.updateUserLocation(location1)
        sut.updateUserLocation(location2)

        // Then
        XCTAssertEqual(sut.userLocation!.coordinate.latitude, 40.7128, accuracy: 0.0001)
        XCTAssertEqual(sut.userLocation!.coordinate.longitude, -74.0060, accuracy: 0.0001)
    }

    func testInitialState_IsEmpty() {
        // Then
        XCTAssertTrue(sut.selectedAnchorIds.isEmpty)
        XCTAssertNil(sut.userLocation)
    }
}
