//
//  ProgressService.swift
//  LARExplorer
//
//  Created by Jean Flaherty on 2025-06-30.
//

import SwiftUI
import Combine

@MainActor
class ProgressService: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var currentProgress: ProgressState = .idle

    // MARK: - Progress State
    enum ProgressState: Equatable {
        case idle
        case loadingMap(progress: Double)
        case loadingPointCloud(progress: Double)

        var isLoading: Bool {
            switch self {
            case .idle: return false
            case .loadingMap, .loadingPointCloud: return true
            }
        }

        var title: String {
            switch self {
            case .idle: return ""
            case .loadingMap: return "Loading Map"
            case .loadingPointCloud(let progress):
                return "Loading Point Cloud (\(Int(progress * 100))%)"
            }
        }

        var progress: Double {
            switch self {
            case .idle: return 0.0
            case .loadingMap(let progress): return progress
            case .loadingPointCloud(let progress): return progress
            }
        }
    }

    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private weak var currentMapService: MapService?
    private weak var currentSceneViewModel: SceneViewModel?

    // MARK: - Public Methods
    func configure(mapService: MapService, sceneViewModel: SceneViewModel?) {
        // Only reconfigure if dependencies have changed
        guard currentMapService !== mapService || currentSceneViewModel !== sceneViewModel else {
            return
        }

        // Clear existing subscriptions
        cancellables.removeAll()

        // Update current references
        currentMapService = mapService
        currentSceneViewModel = sceneViewModel

        // Observe map loading
        mapService.$isLoading
            .combineLatest(mapService.$loadingProgress)
            .sink { [weak self] (isLoading, progress) in
                guard let self = self else { return }
                if isLoading {
                    self.currentProgress = .loadingMap(progress: progress)
                } else if case .loadingMap = self.currentProgress {
                    // Only clear if we were showing map progress
                    self.currentProgress = .idle
                }
            }
            .store(in: &cancellables)

        // Observe point cloud loading
        if let sceneViewModel = sceneViewModel {
            sceneViewModel.$isLoadingPointCloud
                .combineLatest(sceneViewModel.$pointCloudLoadingProgress)
                .sink { [weak self] (isLoading, progress) in
                    guard let self = self else { return }
                    if isLoading {
                        self.currentProgress = .loadingPointCloud(progress: progress)
                    } else if case .loadingPointCloud = self.currentProgress {
                        // Only clear if we were showing point cloud progress
                        self.currentProgress = .idle
                    }
                }
                .store(in: &cancellables)
        }
    }
}