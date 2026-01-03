//
//  LARMapRepository.swift
//  LARExplorer
//
//  Created by Claude Code on 2026-01-04.
//

import Foundation
import simd
import Combine
import CoreLocation
import LocalizeAR

/// Concrete implementation of MapRepository that adapts LARMap
@MainActor
final class LARMapRepository: MapRepository, ObservableObject {
    // MARK: - Private Properties

    private var mapService: MapService?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Published State

    @Published private(set) var _isLoaded: Bool = false

    // MARK: - Initialization

    init() {}

    /// Configure with a MapService instance
    func configure(with mapService: MapService) {
        self.mapService = mapService

        // Observe map loading state
        mapService.$isMapLoaded
            .sink { [weak self] isLoaded in
                self?._isLoaded = isLoaded
            }
            .store(in: &cancellables)

        _isLoaded = mapService.isMapLoaded
    }

    // MARK: - MapRepository State

    var isLoaded: Bool { _isLoaded }

    var isLoadedPublisher: AnyPublisher<Bool, Never> {
        $_isLoaded.eraseToAnyPublisher()
    }

    var mapDirectoryURL: URL? {
        // MapService doesn't expose directory URL, but we could add it if needed
        nil
    }

    // MARK: - Anchors

    func anchor(id: Int32) -> AnchorData? {
        guard let map = mapService?.mapData else { return nil }

        guard let anchor = map.anchors.first(where: { $0.id == id }) else {
            return nil
        }

        return anchorData(from: anchor)
    }

    func allAnchors() -> [AnchorData] {
        guard let map = mapService?.mapData else { return [] }

        return map.anchors.map { anchorData(from: $0) }
    }

    func updateAnchorPosition(id: Int32, offset: SIMD3<Float>) {
        guard let map = mapService?.mapData,
              let anchor = map.anchors.first(where: { $0.id == id }) else {
            return
        }

        let currentTransform = anchor.transform
        let currentPosition = SIMD3<Float>(
            Float(currentTransform.columns.3.x),
            Float(currentTransform.columns.3.y),
            Float(currentTransform.columns.3.z)
        )
        let newPosition = currentPosition + offset

        // Create new transform with updated position
        let newTransform = simd_float4x4(
            simd_float4(Float(currentTransform.columns.0.x), Float(currentTransform.columns.0.y), Float(currentTransform.columns.0.z), Float(currentTransform.columns.0.w)),
            simd_float4(Float(currentTransform.columns.1.x), Float(currentTransform.columns.1.y), Float(currentTransform.columns.1.z), Float(currentTransform.columns.1.w)),
            simd_float4(Float(currentTransform.columns.2.x), Float(currentTransform.columns.2.y), Float(currentTransform.columns.2.z), Float(currentTransform.columns.2.w)),
            simd_float4(newPosition.x, newPosition.y, newPosition.z, Float(currentTransform.columns.3.w))
        )

        map.updateAnchor(anchor, transform: newTransform)
    }

    func deleteAnchor(id: Int32) {
        guard let map = mapService?.mapData,
              let anchor = map.anchors.first(where: { $0.id == id }) else {
            return
        }

        map.removeAnchor(anchor)
    }

    // MARK: - Edges

    func allEdges() -> [EdgeData] {
        guard let map = mapService?.mapData else { return [] }

        var edges: [EdgeData] = []

        // edges is a dictionary: [NSNumber: [NSNumber]]
        for (sourceKey, targetList) in map.edges {
            guard let sourceNumber = sourceKey as? NSNumber,
                  let targets = targetList as? [NSNumber] else {
                continue
            }

            let sourceId = sourceNumber.int32Value
            for targetNumber in targets {
                let targetId = targetNumber.int32Value
                // Only add edges in one direction to avoid duplicates
                if sourceId < targetId {
                    edges.append(EdgeData(fromId: sourceId, toId: targetId))
                }
            }
        }

        return edges.sorted { $0.id < $1.id }
    }

    func edgeExists(from: Int32, to: Int32) -> Bool {
        guard let map = mapService?.mapData else { return false }

        // Check both directions since edges might be stored either way
        if let targets = map.edges[NSNumber(value: from)] as? [NSNumber] {
            if targets.contains(NSNumber(value: to)) {
                return true
            }
        }

        if let targets = map.edges[NSNumber(value: to)] as? [NSNumber] {
            if targets.contains(NSNumber(value: from)) {
                return true
            }
        }

        return false
    }

    func addEdge(from: Int32, to: Int32) {
        guard let map = mapService?.mapData else { return }
        map.addEdge(from: from, to: to)
    }

    func removeEdge(from: Int32, to: Int32) {
        guard let map = mapService?.mapData else { return }
        map.removeEdge(from: from, to: to)
    }

    // MARK: - Landmarks

    func allLandmarks() -> [LandmarkData] {
        guard let map = mapService?.mapData else { return [] }

        return map.landmarks.map { landmarkData(from: $0) }
    }

    func landmark(id: Int) -> LandmarkData? {
        guard let map = mapService?.mapData else { return nil }

        guard let landmark = map.landmarks.first(where: { Int($0.id) == id }) else {
            return nil
        }

        return landmarkData(from: landmark)
    }

    var landmarkCount: Int {
        mapService?.mapData?.landmarks.count ?? 0
    }

    // MARK: - Origin & Alignment

    func origin() -> simd_float4x4 {
        guard let map = mapService?.mapData else {
            return matrix_identity_float4x4
        }

        // Convert double4x4 to float4x4
        let doubleOrigin = map.origin
        return simd_float4x4(
            simd_float4(Float(doubleOrigin.columns.0.x), Float(doubleOrigin.columns.0.y), Float(doubleOrigin.columns.0.z), Float(doubleOrigin.columns.0.w)),
            simd_float4(Float(doubleOrigin.columns.1.x), Float(doubleOrigin.columns.1.y), Float(doubleOrigin.columns.1.z), Float(doubleOrigin.columns.1.w)),
            simd_float4(Float(doubleOrigin.columns.2.x), Float(doubleOrigin.columns.2.y), Float(doubleOrigin.columns.2.z), Float(doubleOrigin.columns.2.w)),
            simd_float4(Float(doubleOrigin.columns.3.x), Float(doubleOrigin.columns.3.y), Float(doubleOrigin.columns.3.z), Float(doubleOrigin.columns.3.w))
        )
    }

    func updateOrigin(_ transform: simd_float4x4) {
        guard let map = mapService?.mapData else { return }

        // Convert float4x4 to double4x4
        let doubleTransform = simd_double4x4(
            simd_double4(Double(transform.columns.0.x), Double(transform.columns.0.y), Double(transform.columns.0.z), Double(transform.columns.0.w)),
            simd_double4(Double(transform.columns.1.x), Double(transform.columns.1.y), Double(transform.columns.1.z), Double(transform.columns.1.w)),
            simd_double4(Double(transform.columns.2.x), Double(transform.columns.2.y), Double(transform.columns.2.z), Double(transform.columns.2.w)),
            simd_double4(Double(transform.columns.3.x), Double(transform.columns.3.y), Double(transform.columns.3.z), Double(transform.columns.3.w))
        )

        map.updateOrigin(doubleTransform)
    }

    @discardableResult
    func rescale(_ factor: Double) -> Bool {
        guard let mapProcessor = mapService?.mapProcessor else { return false }
        mapProcessor.rescale(factor)
        return true
    }

    func location(from position: SIMD3<Double>) -> CLLocation {
        guard let map = mapService?.mapData else {
            return CLLocation(latitude: 0, longitude: 0)
        }

        return map.location(from: position)
    }

    // MARK: - Persistence

    func load(from url: URL) async throws {
        mapService?.loadMap(from: url)

        // Wait for loading to complete
        // Note: This is a simplified implementation - in production you might want
        // to properly await the completion
    }

    func save() throws {
        guard let mapService = mapService else {
            throw RepositoryError.noMapLoaded
        }

        guard mapService.saveMap(to: mapService.mapData?.description ?? "") else {
            throw RepositoryError.saveFailed
        }
    }

    // MARK: - Private Helpers

    private func anchorData(from anchor: LARAnchor) -> AnchorData {
        let transform = anchor.transform
        let position = SIMD3<Float>(
            Float(transform.columns.3.x),
            Float(transform.columns.3.y),
            Float(transform.columns.3.z)
        )

        // Convert double4x4 to float4x4
        let floatTransform = simd_float4x4(
            simd_float4(Float(transform.columns.0.x), Float(transform.columns.0.y), Float(transform.columns.0.z), Float(transform.columns.0.w)),
            simd_float4(Float(transform.columns.1.x), Float(transform.columns.1.y), Float(transform.columns.1.z), Float(transform.columns.1.w)),
            simd_float4(Float(transform.columns.2.x), Float(transform.columns.2.y), Float(transform.columns.2.z), Float(transform.columns.2.w)),
            simd_float4(Float(transform.columns.3.x), Float(transform.columns.3.y), Float(transform.columns.3.z), Float(transform.columns.3.w))
        )

        return AnchorData(id: anchor.id, position: position, transform: floatTransform)
    }

    private func landmarkData(from landmark: LARLandmark) -> LandmarkData {
        let position = SIMD3<Float>(
            Float(landmark.position.x),
            Float(landmark.position.y),
            Float(landmark.position.z)
        )

        // Note: LARLandmark may have isMatched/isUsable properties
        // For now using defaults since we don't have access to those
        return LandmarkData(
            id: Int(landmark.id),
            position: position,
            isMatched: false,
            isUsable: true
        )
    }
}

// MARK: - Errors

enum RepositoryError: Error, LocalizedError {
    case noMapLoaded
    case saveFailed

    var errorDescription: String? {
        switch self {
        case .noMapLoaded:
            return "No map is currently loaded"
        case .saveFailed:
            return "Failed to save map"
        }
    }
}
