//
//  LARExplorerViewModel.swift
//  LARExplorer
//
//  Created by Jean Flaherty on 2025-06-30.
//

import SwiftUI
import MapKit
import SceneKit
import LocalizeAR

@MainActor
class LARExplorerViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isMapLoaded = false
    @Published var mapData: LARMap?
    @Published var mapCenter: CLLocationCoordinate2D?
    @Published var errorMessage: String?
    @Published var isNavigationReady = false
    
    // MARK: - Internal Properties
    private var mapper: LARMapper?
    
    // MARK: - Computed Properties
    var mapperData: LARMapper.Data? {
        return mapper?.data
    }
    
    // MARK: - Initialization
    init() {
        // Initialize with default state
    }
    
    // MARK: - Public Methods
    func loadMap(from directory: URL) {
        Task {
            do {
                let newMapper = LARMapper(directory: directory)
                try await loadMapData(mapper: newMapper)
                
                // Update state on main actor
                await MainActor.run {
                    self.mapper = newMapper
                    self.mapData = newMapper.data.map
                    
                    // Calculate map center for UI updates
					let location = newMapper.data.map.location(from: simd_double3())
					self.mapCenter = location.coordinate
                    
                    self.isMapLoaded = true
                    self.errorMessage = nil
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to load map: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func resetError() {
        errorMessage = nil
    }
    
    // MARK: - Internal Methods
    private func loadMapData(mapper: LARMapper) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    print("Starting to read metadata...")
                    mapper.readMetadata()
                    print("Successfully read metadata!")
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
