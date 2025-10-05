//
//  MockNavigationStateManager.swift
//  LocalizeARTests
//
//  Created by Jean Atsumi Flaherty on 2025-10-05.
//

import XCTest
import CoreLocation
@testable import LocalizeAR

/// Mock implementation of LARNavigationStateManaging for testing
class MockNavigationStateManager: LARNavigationStateManaging {
    // State
    var selectedAnchorIds: Set<Int32> = []
    var userLocation: CLLocation?

    // Track method calls
    var selectAnchorCallCount = 0
    var deselectAnchorCallCount = 0
    var clearSelectionCallCount = 0
    var updateUserLocationCallCount = 0

    func selectAnchor(anchorId: Int32) {
        selectAnchorCallCount += 1
        selectedAnchorIds.insert(anchorId)
    }

    func deselectAnchor(anchorId: Int32) {
        deselectAnchorCallCount += 1
        selectedAnchorIds.remove(anchorId)
    }

    func isAnchorSelected(anchorId: Int32) -> Bool {
        return selectedAnchorIds.contains(anchorId)
    }

    func clearSelection() {
        clearSelectionCallCount += 1
        selectedAnchorIds.removeAll()
    }

    func updateUserLocation(_ location: CLLocation) {
        updateUserLocationCallCount += 1
        userLocation = location
    }
}
