//
//  MapRepository.swift
//  LARExplorer
//
//  Created by Claude Code on 2026-01-04.
//

import Foundation
import simd
import Combine
import CoreLocation

// MARK: - Domain Models

/// Value type representing anchor data for the domain layer
struct AnchorData: Equatable, Identifiable {
    let id: Int32
    var position: SIMD3<Float>
    var transform: simd_float4x4

    init(id: Int32, position: SIMD3<Float>, transform: simd_float4x4 = matrix_identity_float4x4) {
        self.id = id
        self.position = position
        self.transform = transform
    }
}

/// Value type representing edge data for the domain layer
struct EdgeData: Equatable, Hashable {
    let fromId: Int32
    let toId: Int32

    /// Unique identifier for the edge (sorted to ensure consistency)
    var id: String {
        let sorted = [fromId, toId].sorted()
        return "\(sorted[0])-\(sorted[1])"
    }
}

/// Value type representing landmark data for the domain layer
struct LandmarkData: Equatable, Identifiable {
    let id: Int
    let position: SIMD3<Float>
    let isMatched: Bool
    let isUsable: Bool
}

// MARK: - MapRepository Protocol

/// Single protocol for all map data operations
/// This abstracts away the LARMap/LARMapper implementation details
@MainActor
protocol MapRepository: AnyObject {
    // MARK: - State

    /// Whether a map is currently loaded
    var isLoaded: Bool { get }

    /// Publisher for map loaded state changes
    var isLoadedPublisher: AnyPublisher<Bool, Never> { get }

    /// The current map directory URL (nil if no map loaded)
    var mapDirectoryURL: URL? { get }

    // MARK: - Anchors

    /// Get a specific anchor by ID
    func anchor(id: Int32) -> AnchorData?

    /// Get all anchors in the map
    func allAnchors() -> [AnchorData]

    /// Update an anchor's position by applying an offset
    func updateAnchorPosition(id: Int32, offset: SIMD3<Float>)

    /// Delete an anchor from the map
    func deleteAnchor(id: Int32)

    // MARK: - Edges

    /// Get all edges in the map
    func allEdges() -> [EdgeData]

    /// Check if an edge exists between two anchors
    func edgeExists(from: Int32, to: Int32) -> Bool

    /// Add an edge between two anchors
    func addEdge(from: Int32, to: Int32)

    /// Remove an edge between two anchors
    func removeEdge(from: Int32, to: Int32)

    // MARK: - Landmarks

    /// Get all landmarks in the map
    func allLandmarks() -> [LandmarkData]

    /// Get a specific landmark by ID
    func landmark(id: Int) -> LandmarkData?

    /// Get the total number of landmarks
    var landmarkCount: Int { get }

    // MARK: - Origin & Alignment

    /// Get the map origin transform
    func origin() -> simd_float4x4

    /// Update the map origin transform
    func updateOrigin(_ transform: simd_float4x4)

    /// Rescale the map by a relative factor (e.g., 1.1 = 10% larger)
    /// Returns true if rescaling succeeded
    @discardableResult
    func rescale(_ factor: Double) -> Bool

    /// Convert a position in map space to GPS coordinates
    func location(from position: SIMD3<Double>) -> CLLocation

    // MARK: - Persistence

    /// Load a map from the given directory
    func load(from url: URL) async throws

    /// Save the current map
    func save() throws
}
