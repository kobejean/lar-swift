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
