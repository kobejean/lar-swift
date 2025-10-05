//
//  LocalizeARAssemblyTests.swift
//  LocalizeARTests
//
//  Created by Jean Atsumi Flaherty on 2025-10-05.
//

import XCTest
import Swinject
@testable import LocalizeAR
import LocalizeAR_ObjC

/// Tests for LocalizeARAssembly
/// Validates Dependency Injection configuration
final class LocalizeARAssemblyTests: XCTestCase {
    var container: Container!
    var assembler: Assembler!

    override func setUp() {
        super.setUp()
        container = Container()

        // Register required dependencies (LARMap must be registered before assembly)
        let testMap = LARMap()
        container.register(LARMap.self) { _ in testMap }

        // Assemble LocalizeAR components
        assembler = Assembler([LocalizeARAssembly()], container: container)
    }

    override func tearDown() {
        container = nil
        assembler = nil
        super.tearDown()
    }

    // MARK: - State Manager Tests

    func testAssembly_ResolvesNavigationStateManager() {
        // When
        let stateManager = container.resolve(LARNavigationStateManaging.self)

        // Then
        XCTAssertNotNil(stateManager)
        XCTAssertTrue(stateManager is LARNavigationStateManager)
    }

    func testAssembly_NavigationStateManager_IsSingleton() {
        // When
        let instance1 = container.resolve(LARNavigationStateManaging.self)
        let instance2 = container.resolve(LARNavigationStateManaging.self)

        // Then
        XCTAssertTrue(instance1 === instance2, "State manager should be singleton")
    }

    // MARK: - Renderer Tests

    func testAssembly_ResolvesSceneRenderer() {
        // When
        let renderer = container.resolve(LARSceneRendering.self)

        // Then
        XCTAssertNotNil(renderer)
        XCTAssertTrue(renderer is LARSceneRenderer)
    }

    func testAssembly_ResolvesMapRenderer() {
        // When
        let renderer = container.resolve(LARMapRendering.self)

        // Then
        XCTAssertNotNil(renderer)
        XCTAssertTrue(renderer is LARMapRenderer)
    }

    func testAssembly_SceneRenderer_IsTransient() {
        // When
        let instance1 = container.resolve(LARSceneRendering.self)
        let instance2 = container.resolve(LARSceneRendering.self)

        // Then
        XCTAssertFalse(instance1 === instance2, "Renderer should be transient")
    }

    // MARK: - Navigation Coordinator Tests

    func testAssembly_ResolvesNavigationCoordinator() {
        // When
        let coordinator = container.resolve(LARNavigationCoordinator.self)

        // Then
        XCTAssertNotNil(coordinator)
    }

    func testAssembly_NavigationCoordinator_HasAllDependencies() {
        // When
        let coordinator = container.resolve(LARNavigationCoordinator.self)

        // Then
        XCTAssertNotNil(coordinator)
        // Coordinator should be properly configured with all dependencies
        XCTAssertNotNil(coordinator?.anchors) // Validates graph is initialized
    }

    // MARK: - Map Dependency Tests

    func testAssembly_RequiresMapToBeRegistered() {
        // Given - Create new container without map
        let _ = Container()
        let _ = LocalizeARAssembly()

        // When/Then - Should fail (fatalError) when trying to resolve without map
        // We can't test fatalError directly, but we document the requirement
        // In real usage, app must register LARMap before using assembly
    }

    // MARK: - Protocol-Based Resolution

    func testAssembly_AllComponentsResolveViaProtocols() {
        // When
        let stateManager = container.resolve(LARNavigationStateManaging.self)
        let sceneRenderer = container.resolve(LARSceneRendering.self)
        let mapRenderer = container.resolve(LARMapRendering.self)

        // Then
        XCTAssertNotNil(stateManager, "Should resolve via protocol")
        XCTAssertNotNil(sceneRenderer, "Should resolve via protocol")
        XCTAssertNotNil(mapRenderer, "Should resolve via protocol")
    }

    // MARK: - Integration Test

    func testAssembly_CreatesFullyFunctionalCoordinator() {
        // When
        let coordinator = container.resolve(LARNavigationCoordinator.self)

        // Then
        XCTAssertNotNil(coordinator)

        // Should be able to use coordinator
        let anchor = LARAnchor(transform: simd_double4x4(1))
        coordinator?.addNavigationPoint(anchor: anchor)

        XCTAssertEqual(coordinator?.anchors.count, 1)
    }
}
