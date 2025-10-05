//
//  LARNavigationStateManaging.swift
//  LocalizeAR
//
//  Created by Jean Atsumi Flaherty on 2025-10-05.
//

import Foundation
import CoreLocation

/// Protocol defining navigation state management
public protocol LARNavigationStateManaging: AnyObject {
    /// Currently selected anchor IDs
    var selectedAnchorIds: Set<Int32> { get }

    /// Current user location
    var userLocation: CLLocation? { get }

    /// Select an anchor
    /// - Parameter anchorId: ID of the anchor to select
    func selectAnchor(anchorId: Int32)

    /// Deselect an anchor
    /// - Parameter anchorId: ID of the anchor to deselect
    func deselectAnchor(anchorId: Int32)

    /// Check if an anchor is selected
    /// - Parameter anchorId: ID of the anchor to check
    /// - Returns: True if the anchor is selected
    func isAnchorSelected(anchorId: Int32) -> Bool

    /// Clear all selections
    func clearSelection()

    /// Update user location
    /// - Parameter location: New user location
    func updateUserLocation(_ location: CLLocation)
}