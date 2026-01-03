//
//  MockMapRepository.swift
//  LARExplorer
//
//  Created by Claude Code on 2026-01-04.
//

import Foundation
import simd
import Combine
import CoreLocation

/// Mock implementation of MapRepository for unit testing
/// Records all method calls and allows stubbing return values
@MainActor
final class MockMapRepository: MapRepository {
    // MARK: - State Stubs

    var stubbedIsLoaded: Bool = false
    var stubbedMapDirectoryURL: URL?
    var stubbedLandmarkCount: Int = 0

    // MARK: - Data Stubs

    var stubbedAnchors: [Int32: AnchorData] = [:]
    var stubbedEdges: Set<EdgeData> = []
    var stubbedLandmarks: [Int: LandmarkData] = [:]
    var stubbedOrigin: simd_float4x4 = matrix_identity_float4x4

    // MARK: - Call Recording

    struct AnchorPositionUpdate: Equatable {
        let id: Int32
        let offset: SIMD3<Float>
    }

    struct EdgeOperation: Equatable {
        let fromId: Int32
        let toId: Int32
    }

    var anchorCalls: [Int32] = []
    var allAnchorsCalls: Int = 0
    var updateAnchorPositionCalls: [AnchorPositionUpdate] = []
    var deleteAnchorCalls: [Int32] = []
    var allEdgesCalls: Int = 0
    var edgeExistsCalls: [EdgeOperation] = []
    var addEdgeCalls: [EdgeOperation] = []
    var removeEdgeCalls: [EdgeOperation] = []
    var allLandmarksCalls: Int = 0
    var landmarkCalls: [Int] = []
    var originCalls: Int = 0
    var updateOriginCalls: [simd_float4x4] = []
    var locationCalls: [SIMD3<Double>] = []
    var loadCalls: [URL] = []
    var saveCalls: Int = 0

    // MARK: - Publishers

    private let isLoadedSubject = CurrentValueSubject<Bool, Never>(false)

    // MARK: - MapRepository Conformance

    var isLoaded: Bool { stubbedIsLoaded }

    var isLoadedPublisher: AnyPublisher<Bool, Never> {
        isLoadedSubject.eraseToAnyPublisher()
    }

    var mapDirectoryURL: URL? { stubbedMapDirectoryURL }

    var landmarkCount: Int { stubbedLandmarkCount }

    func anchor(id: Int32) -> AnchorData? {
        anchorCalls.append(id)
        return stubbedAnchors[id]
    }

    func allAnchors() -> [AnchorData] {
        allAnchorsCalls += 1
        return Array(stubbedAnchors.values).sorted { $0.id < $1.id }
    }

    func updateAnchorPosition(id: Int32, offset: SIMD3<Float>) {
        updateAnchorPositionCalls.append(AnchorPositionUpdate(id: id, offset: offset))

        // Also update the stubbed data for integration-style tests
        if var anchor = stubbedAnchors[id] {
            anchor.position += offset
            stubbedAnchors[id] = anchor
        }
    }

    func deleteAnchor(id: Int32) {
        deleteAnchorCalls.append(id)
        stubbedAnchors.removeValue(forKey: id)
    }

    func allEdges() -> [EdgeData] {
        allEdgesCalls += 1
        return Array(stubbedEdges).sorted { $0.id < $1.id }
    }

    func edgeExists(from: Int32, to: Int32) -> Bool {
        edgeExistsCalls.append(EdgeOperation(fromId: from, toId: to))
        return stubbedEdges.contains(EdgeData(fromId: from, toId: to)) ||
               stubbedEdges.contains(EdgeData(fromId: to, toId: from))
    }

    func addEdge(from: Int32, to: Int32) {
        addEdgeCalls.append(EdgeOperation(fromId: from, toId: to))
        stubbedEdges.insert(EdgeData(fromId: from, toId: to))
    }

    func removeEdge(from: Int32, to: Int32) {
        removeEdgeCalls.append(EdgeOperation(fromId: from, toId: to))
        stubbedEdges.remove(EdgeData(fromId: from, toId: to))
        stubbedEdges.remove(EdgeData(fromId: to, toId: from))
    }

    func allLandmarks() -> [LandmarkData] {
        allLandmarksCalls += 1
        return Array(stubbedLandmarks.values).sorted { $0.id < $1.id }
    }

    func landmark(id: Int) -> LandmarkData? {
        landmarkCalls.append(id)
        return stubbedLandmarks[id]
    }

    func origin() -> simd_float4x4 {
        originCalls += 1
        return stubbedOrigin
    }

    func updateOrigin(_ transform: simd_float4x4) {
        updateOriginCalls.append(transform)
        stubbedOrigin = transform
    }

    func location(from position: SIMD3<Double>) -> CLLocation {
        locationCalls.append(position)
        // Return a dummy location - tests can verify the call was made
        return CLLocation(latitude: 0, longitude: 0)
    }

    func load(from url: URL) async throws {
        loadCalls.append(url)
        stubbedIsLoaded = true
        isLoadedSubject.send(true)
    }

    func save() throws {
        saveCalls += 1
    }

    // MARK: - Test Helpers

    /// Reset all recorded calls (useful between tests)
    func reset() {
        anchorCalls.removeAll()
        allAnchorsCalls = 0
        updateAnchorPositionCalls.removeAll()
        deleteAnchorCalls.removeAll()
        allEdgesCalls = 0
        edgeExistsCalls.removeAll()
        addEdgeCalls.removeAll()
        removeEdgeCalls.removeAll()
        allLandmarksCalls = 0
        landmarkCalls.removeAll()
        originCalls = 0
        updateOriginCalls.removeAll()
        locationCalls.removeAll()
        loadCalls.removeAll()
        saveCalls = 0
    }

    /// Reset all stubbed data
    func resetData() {
        stubbedIsLoaded = false
        stubbedMapDirectoryURL = nil
        stubbedLandmarkCount = 0
        stubbedAnchors.removeAll()
        stubbedEdges.removeAll()
        stubbedLandmarks.removeAll()
        stubbedOrigin = matrix_identity_float4x4
        isLoadedSubject.send(false)
    }

    /// Convenience method to set up test anchors
    func setupAnchors(_ anchors: [AnchorData]) {
        stubbedAnchors = Dictionary(uniqueKeysWithValues: anchors.map { ($0.id, $0) })
    }

    /// Convenience property for setting anchors directly
    var mockAnchors: [AnchorData] {
        get { Array(stubbedAnchors.values) }
        set { setupAnchors(newValue) }
    }

    /// Convenience alias for updateAnchorPositionCalls
    var updatePositionCalls: [AnchorPositionUpdate] {
        updateAnchorPositionCalls
    }

    /// Convenience to get deleted anchor IDs
    var deletedAnchorIds: Set<Int32> {
        Set(deleteAnchorCalls)
    }

    /// Convenience method to set up test edges
    func setupEdges(_ edges: [EdgeData]) {
        stubbedEdges = Set(edges)
    }

    /// Convenience method to set up test landmarks
    func setupLandmarks(_ landmarks: [LandmarkData]) {
        stubbedLandmarks = Dictionary(uniqueKeysWithValues: landmarks.map { ($0.id, $0) })
        stubbedLandmarkCount = landmarks.count
    }
}
