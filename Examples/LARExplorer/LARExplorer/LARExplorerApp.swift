//
//  LARExplorerApp.swift
//  LARExplorer
//
//  Created by Jean Flaherty on 2025/06/29.
//

import SwiftUI
import Swinject

@main
struct LARExplorerApp: App {
    // Shared DI container for the entire app
    let container: Container = {
        let container = Container()
        let assembler = Assembler([AppAssembly()], container: container)
        return container
    }()

    var body: some Scene {
        WindowGroup {
            ContentView(container: container)
        }
    }
}
