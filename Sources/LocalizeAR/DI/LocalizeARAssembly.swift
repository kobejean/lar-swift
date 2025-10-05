//
//  LocalizeARAssembly.swift
//  LocalizeAR
//
//  Created by Assistant on 2025-10-05.
//

import Foundation
import Swinject
import LocalizeAR_ObjC

/// Swinject assembly for LocalizeAR library components
/// Applications using LocalizeAR can include this assembly in their DI container
public class LocalizeARAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        // MARK: - Navigation State Management

        container.register(LARNavigationStateManaging.self) { _ in
            LARNavigationStateManager()
        }.inObjectScope(.container) // Singleton - shared state

        // MARK: - Renderers

        container.register(LARSceneRendering.self) { _ in
            LARSceneRenderer()
        } // Transient - new instance per resolution

        container.register(LARMapRendering.self) { _ in
            LARMapRenderer()
        } // Transient - new instance per resolution

        // MARK: - Navigation Components

        // Note: LARNavigationCoordinator requires LARMap to be registered by the app
        container.register(LARNavigationCoordinator.self) { r in
            guard let map = r.resolve(LARMap.self) else {
                fatalError("LARMap must be registered before creating LARNavigationCoordinator")
            }

            let sceneRenderer = r.resolve(LARSceneRendering.self)!
            let mapRenderer = r.resolve(LARMapRendering.self)!
            let navigationGraph = LARNavigationGraphAdapter(map: map)
            let stateManager = r.resolve(LARNavigationStateManaging.self)!

            return LARNavigationCoordinator(
                map: map,
                sceneRenderer: sceneRenderer,
                mapRenderer: mapRenderer,
                navigationGraph: navigationGraph,
                stateManager: stateManager
            )
        } // Transient by default, but apps can override the scope
    }
}
