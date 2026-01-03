//
//  LARMapRepositoryTests.swift
//  LARExplorerTests
//
//  Created by Claude Code on 2026-01-04.
//

import Testing
import Foundation
import simd
import Combine
@testable import LARExplorer

/// Integration tests for LARMapRepository
/// These tests verify the repository correctly adapts LARMap operations
@MainActor
struct LARMapRepositoryTests {

    // MARK: - Initial State Tests

    @Test func initialState_isNotLoaded() {
        let repository = LARMapRepository()

        #expect(!repository.isLoaded)
    }

    @Test func initialState_hasNoAnchors() {
        let repository = LARMapRepository()

        #expect(repository.allAnchors().isEmpty)
    }

    @Test func initialState_hasNoEdges() {
        let repository = LARMapRepository()

        #expect(repository.allEdges().isEmpty)
    }

    @Test func initialState_hasNoLandmarks() {
        let repository = LARMapRepository()

        #expect(repository.allLandmarks().isEmpty)
        #expect(repository.landmarkCount == 0)
    }

    @Test func initialState_returnsIdentityOrigin() {
        let repository = LARMapRepository()

        let origin = repository.origin()
        let identity = matrix_identity_float4x4

        // Check that origin is identity matrix
        #expect(origin.columns.0.x == identity.columns.0.x)
        #expect(origin.columns.1.y == identity.columns.1.y)
        #expect(origin.columns.2.z == identity.columns.2.z)
        #expect(origin.columns.3.w == identity.columns.3.w)
    }

    // MARK: - Anchor Lookup Tests

    @Test func anchor_withInvalidId_returnsNil() {
        let repository = LARMapRepository()

        let anchor = repository.anchor(id: 999)

        #expect(anchor == nil)
    }

    // MARK: - Landmark Lookup Tests

    @Test func landmark_withInvalidId_returnsNil() {
        let repository = LARMapRepository()

        let landmark = repository.landmark(id: 999)

        #expect(landmark == nil)
    }

    // MARK: - Edge Existence Tests

    @Test func edgeExists_withNoMap_returnsFalse() {
        let repository = LARMapRepository()

        let exists = repository.edgeExists(from: 1, to: 2)

        #expect(!exists)
    }

    // MARK: - Location Conversion Tests

    @Test func location_withNoMap_returnsZeroLocation() {
        let repository = LARMapRepository()

        let location = repository.location(from: SIMD3<Double>(1, 2, 3))

        #expect(location.coordinate.latitude == 0)
        #expect(location.coordinate.longitude == 0)
    }

    // MARK: - Publisher Tests

    @Test func isLoadedPublisher_emitsInitialValue() async {
        let repository = LARMapRepository()
        var receivedValues: [Bool] = []

        let cancellable = repository.isLoadedPublisher
            .sink { value in
                receivedValues.append(value)
            }

        // Wait a bit for the publisher to emit
        try? await Task.sleep(nanoseconds: 10_000_000)

        #expect(!receivedValues.isEmpty)
        #expect(receivedValues.first == false)

        cancellable.cancel()
    }

    // MARK: - Error Handling Tests

    @Test func save_withNoMapService_throws() async throws {
        let repository = LARMapRepository()

        await #expect(throws: RepositoryError.self) {
            try repository.save()
        }
    }

    // MARK: - Protocol Conformance Tests

    @Test func conformsToMapRepository() {
        let repository = LARMapRepository()

        // Verify the repository conforms to the protocol by using it as the protocol type
        let mapRepository: MapRepository = repository

        #expect(!mapRepository.isLoaded)
        #expect(mapRepository.allAnchors().isEmpty)
        #expect(mapRepository.allEdges().isEmpty)
    }
}

// MARK: - AnchorData Tests

struct AnchorDataTests {

    @Test func anchorData_isEquatable() {
        let anchor1 = AnchorData(id: 1, position: SIMD3(1, 2, 3))
        let anchor2 = AnchorData(id: 1, position: SIMD3(1, 2, 3))
        let anchor3 = AnchorData(id: 2, position: SIMD3(1, 2, 3))

        #expect(anchor1 == anchor2)
        #expect(anchor1 != anchor3)
    }

    @Test func anchorData_hasCorrectId() {
        let anchor = AnchorData(id: 42, position: .zero)

        #expect(anchor.id == 42)
    }
}

// MARK: - EdgeData Tests

struct EdgeDataTests {

    @Test func edgeData_idIsSortedConsistent() {
        let edge1 = EdgeData(fromId: 1, toId: 2)
        let edge2 = EdgeData(fromId: 2, toId: 1)

        // Both should have the same ID since it's sorted
        #expect(edge1.id == edge2.id)
        #expect(edge1.id == "1-2")
    }

    @Test func edgeData_isHashable() {
        let edge1 = EdgeData(fromId: 1, toId: 2)
        let edge2 = EdgeData(fromId: 1, toId: 2)

        var set = Set<EdgeData>()
        set.insert(edge1)
        set.insert(edge2)

        #expect(set.count == 1)
    }
}

// MARK: - LandmarkData Tests

struct LandmarkDataTests {

    @Test func landmarkData_isEquatable() {
        let landmark1 = LandmarkData(id: 1, position: SIMD3(1, 2, 3), isMatched: true, isUsable: true)
        let landmark2 = LandmarkData(id: 1, position: SIMD3(1, 2, 3), isMatched: true, isUsable: true)
        let landmark3 = LandmarkData(id: 2, position: SIMD3(1, 2, 3), isMatched: true, isUsable: true)

        #expect(landmark1 == landmark2)
        #expect(landmark1 != landmark3)
    }

    @Test func landmarkData_hasCorrectProperties() {
        let landmark = LandmarkData(id: 42, position: SIMD3(1, 2, 3), isMatched: true, isUsable: false)

        #expect(landmark.id == 42)
        #expect(landmark.position == SIMD3(1, 2, 3))
        #expect(landmark.isMatched)
        #expect(!landmark.isUsable)
    }
}
