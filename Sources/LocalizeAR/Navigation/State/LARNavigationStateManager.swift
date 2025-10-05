//
//  LARNavigationStateManager.swift
//  LocalizeAR
//
//  Created by Assistant on 2025-10-05.
//

import Foundation
import CoreLocation

/// Manages navigation state (selections, user location, etc.)
public class LARNavigationStateManager: LARNavigationStateManaging {
    // MARK: - Published State
    public private(set) var selectedAnchorIds: Set<Int32> = []
    public private(set) var userLocation: CLLocation?

    // MARK: - Initialization
    public init() {}

    // MARK: - LARNavigationStateManaging Protocol

    public func selectAnchor(anchorId: Int32) {
        selectedAnchorIds.insert(anchorId)
    }

    public func deselectAnchor(anchorId: Int32) {
        selectedAnchorIds.remove(anchorId)
    }

    public func isAnchorSelected(anchorId: Int32) -> Bool {
        return selectedAnchorIds.contains(anchorId)
    }

    public func clearSelection() {
        selectedAnchorIds.removeAll()
    }

    public func updateUserLocation(_ location: CLLocation) {
        self.userLocation = location
    }
}