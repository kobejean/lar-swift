//
//  MapService.swift
//  LARExplorer
//
//  Created by Claude on 2025-09-20.
//

import SwiftUI
import LocalizeAR
import CoreLocation

@MainActor
class MapService: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var isMapLoaded = false
    @Published private(set) var mapData: LARMap?
    @Published private(set) var mapCenter: CLLocationCoordinate2D?
    @Published private(set) var mapProcessor: LARMapProcessor?
    @Published var errorMessage: String?
    @Published private(set) var mapLoadCounter = 0  // Increments each time a map is loaded
    @Published private(set) var isLoading = false
    @Published private(set) var loadingProgress: Double = 0.0

    // MARK: - Internal Properties
    private var mapper: LARMapper?
    private var currentLoadTask: Task<Void, Never>?

    // MARK: - Computed Properties
    var mapperData: LARMapper.Data? {
        return mapper?.data
    }

    // MARK: - Public Methods
    func loadMap(from directory: URL) {
        // Cancel any existing load operation
        currentLoadTask?.cancel()

        // Set loading state immediately
        isLoading = true
        loadingProgress = 0.0

        currentLoadTask = Task {
            do {
                // Update progress: Starting map creation
                await MainActor.run { self.loadingProgress = 0.1 }

                let newMapper = LARMapper(directory: directory)

                // Update progress: Loading map data
                await MainActor.run { self.loadingProgress = 0.5 }

                try await loadMapData(mapper: newMapper)

                // Check if task was cancelled before updating state
                guard !Task.isCancelled else {
                    return
                }

                // Update progress: Finalizing
                await MainActor.run { self.loadingProgress = 0.9 }

                // Update state on main actor
                await MainActor.run {
                    self.mapper = newMapper
                    self.mapData = newMapper.data.map
                    self.mapProcessor = LARMapProcessor(mapperData: newMapper.data)

                    // Calculate map center for UI updates
                    let location = newMapper.data.map.location(from: simd_double3())
                    self.mapCenter = location.coordinate

                    self.loadingProgress = 1.0
                    self.isMapLoaded = true
                    self.mapLoadCounter += 1  // Trigger reconfiguration
                    self.errorMessage = nil
                    self.isLoading = false
                }
            } catch {
                guard !Task.isCancelled else {
                    return
                }

                await MainActor.run {
                    self.errorMessage = "Failed to load map: \(error.localizedDescription)"
                    self.isLoading = false
                    self.loadingProgress = 0.0
                }
            }
        }
    }

    func saveMap(to directory: String) -> Bool {
        guard let mapProcessor = mapProcessor else {
            errorMessage = "No map processor available for saving"
            return false
        }

        mapProcessor.saveMap(directory)
        return true
    }

    func resetError() {
        errorMessage = nil
    }

    // MARK: - Internal Methods
    private func loadMapData(mapper: LARMapper) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    mapper.readMetadata()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}