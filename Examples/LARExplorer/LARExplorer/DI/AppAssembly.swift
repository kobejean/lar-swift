//
//  AppAssembly.swift
//  LARExplorer
//
//  Created by Assistant on 2025-10-05.
//

import Foundation
import Swinject
import LocalizeAR

/// Main dependency injection assembly for LARExplorer app
class AppAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - Import Library Dependencies

        // Include LocalizeAR library's assembly
        // Note: We'll register LARMap separately since it comes from MapService

        // MARK: - App Services (Singletons)
        // Note: These services are @MainActor isolated, but we use assumeIsolated
        // because the DI container is created on the main thread in SwiftUI

        container.register(MapService.self) { _ in
            MainActor.assumeIsolated {
                MapService()
            }
        }.inObjectScope(.container)

        // MARK: - Domain Layer (New Architecture)

        // LARMapRepository - Singleton that adapts MapService to MapRepository protocol
        container.register(LARMapRepository.self) { r in
            MainActor.assumeIsolated {
                let repository = LARMapRepository()
                repository.configure(with: r.resolve(MapService.self)!)
                return repository
            }
        }.inObjectScope(.container)

        // MapRepository protocol - Points to LARMapRepository singleton
        container.register(MapRepository.self) { r in
            r.resolve(LARMapRepository.self)!
        }

        // LARRenderingServiceAdapter - Singleton for rendering coordination
        // Note: Must be configured with navigationCoordinator after map loads
        container.register(LARRenderingServiceAdapter.self) { _ in
            MainActor.assumeIsolated {
                LARRenderingServiceAdapter()
            }
        }.inObjectScope(.container)

        // RenderingService protocol - Points to LARRenderingServiceAdapter singleton
        container.register(RenderingService.self) { r in
            r.resolve(LARRenderingServiceAdapter.self)!
        }

        // MARK: - Tool Coordinators (New Architecture)

        // AnchorEditCoordinator - Singleton for anchor editing workflow
        container.register(AnchorEditCoordinator.self) { r in
            MainActor.assumeIsolated {
                AnchorEditCoordinator(
                    mapRepository: r.resolve(MapRepository.self)!,
                    renderingService: r.resolve(RenderingService.self)!
                )
            }
        }.inObjectScope(.container)

        // EdgeEditCoordinator - Singleton for edge editing workflow
        container.register(EdgeEditCoordinator.self) { r in
            MainActor.assumeIsolated {
                EdgeEditCoordinator(
                    mapRepository: r.resolve(MapRepository.self)!,
                    renderingService: r.resolve(RenderingService.self)!
                )
            }
        }.inObjectScope(.container)

        // GPSAlignmentCoordinator - Singleton for GPS alignment workflow
        container.register(GPSAlignmentCoordinator.self) { r in
            MainActor.assumeIsolated {
                GPSAlignmentCoordinator(
                    mapRepository: r.resolve(MapRepository.self)!,
                    renderingService: r.resolve(RenderingService.self)!
                )
            }
        }.inObjectScope(.container)

        // RelocalizationCoordinator - Singleton for relocalization workflow
        container.register(RelocalizationCoordinator.self) { r in
            MainActor.assumeIsolated {
                RelocalizationCoordinator(
                    mapRepository: r.resolve(MapRepository.self)!,
                    renderingService: r.resolve(RenderingService.self)!
                )
            }
        }.inObjectScope(.container)

        // LandmarksCoordinator - Singleton for landmark inspection workflow
        container.register(LandmarksCoordinator.self) { r in
            MainActor.assumeIsolated {
                LandmarksCoordinator(
                    mapRepository: r.resolve(MapRepository.self)!,
                    renderingService: r.resolve(RenderingService.self)!
                )
            }
        }.inObjectScope(.container)

        container.register(EditingService.self) { _ in
            MainActor.assumeIsolated {
                EditingService()
            }
        }.inObjectScope(.container)

        container.register(GPSAlignmentService.self) { _ in
            MainActor.assumeIsolated {
                GPSAlignmentService()
            }
        }.inObjectScope(.container)

        container.register(TestLocalizationService.self) { _ in
            MainActor.assumeIsolated {
                TestLocalizationService()
            }
        }.inObjectScope(.container)

        container.register(LandmarkInspectionService.self) { _ in
            MainActor.assumeIsolated {
                LandmarkInspectionService()
            }
        }.inObjectScope(.container)

        container.register(ProgressService.self) { _ in
            MainActor.assumeIsolated {
                ProgressService()
            }
        }.inObjectScope(.container)

        // MARK: - Scene Interaction Manager

        container.register(SceneInteractionManager.self) { r in
            MainActor.assumeIsolated {
                SceneInteractionManager(
                    editingService: r.resolve(EditingService.self)!,
                    landmarkInspectionService: r.resolve(LandmarkInspectionService.self)!,
                    mapService: r.resolve(MapService.self)!
                )
            }
        }.inObjectScope(.container)

        // MARK: - Navigation Components (from LocalizeAR)

        // Register navigation state manager
        container.register(LARNavigationStateManaging.self) { _ in
            LARNavigationStateManager()
        }.inObjectScope(.container)

        // Register renderers
        container.register(LARSceneRendering.self) { _ in
            LARSceneRenderer()
        }

        container.register(LARMapRendering.self) { _ in
            LARMapRenderer()
        }

        // Register LARNavigationCoordinator
        // Note: This will be created when map is loaded
        container.register(LARNavigationCoordinator.self) { r in
            // LARMap must be registered dynamically when map loads
            guard let map = r.resolve(LARMap.self) else {
                fatalError("LARMap must be registered before creating LARNavigationCoordinator. Call registerMap() after loading.")
            }

            return LARNavigationCoordinator(
                map: map,
                sceneRenderer: r.resolve(LARSceneRendering.self)!,
                mapRenderer: r.resolve(LARMapRendering.self)!,
                navigationGraph: LARNavigationGraphAdapter(map: map),
                stateManager: r.resolve(LARNavigationStateManaging.self)!
            )
        } // Transient - created fresh when needed
    }

    /// Register the loaded map in the container
    /// This should be called after MapService loads a map
    static func registerMap(_ map: LARMap, in container: Container) {
        container.register(LARMap.self) { _ in map }
            .inObjectScope(.container) // Singleton
    }
}
