//
//  GeoARNavigationGraphTests.swift
//  
//
//  Created by Jean Flaherty on 7/9/21.
//

import XCTest
import ARKit
import simd
@testable import GeoAR

final class GeoARNavigationGraphTests: XCTestCase {
    
    
    // MARK: Add
    
    func testAdd() throws {
        // Given
        let anchor1 = GeoARNavigationAnchor(transform: matrix_identity_float4x4)
        let anchor2 = GeoARNavigationAnchor(transform: matrix_identity_float4x4)
        let graph = GeoARNavigationGraph()
        // When
        graph.add(from: anchor1, to: anchor2)
        // Then
        // Edge should be added
        let adjacentToAnchor1 = try XCTUnwrap(graph.adjacencyList[anchor1.identifier])
        let adjacentToAnchor2 = try XCTUnwrap(graph.adjacencyList[anchor2.identifier])
        XCTAssert(adjacentToAnchor1.contains(anchor2.identifier))
        XCTAssert(adjacentToAnchor2.contains(anchor1.identifier))
        // Vertecies should be added
        let graphAnchor1 = try XCTUnwrap(graph.vertices[anchor1.identifier])
        let graphAnchor2 = try XCTUnwrap(graph.vertices[anchor2.identifier])
        XCTAssertEqual(graphAnchor1, anchor1)
        XCTAssertEqual(graphAnchor2, anchor2)
    }
    
    func testAddWithEdgeAlreadyAdded() throws {
        // Given
        let anchor1 = GeoARNavigationAnchor(transform: matrix_identity_float4x4)
        let anchor2 = GeoARNavigationAnchor(transform: matrix_identity_float4x4)
        let graph = GeoARNavigationGraph()
        graph.add(from: anchor1, to: anchor2)
        graph.add(from: anchor2, to: anchor1)
        // When
        graph.add(from: anchor1, to: anchor2)
        // Then
        let adjacentToAnchor1 = try XCTUnwrap(graph.adjacencyList[anchor1.identifier])
        let adjacentToAnchor2 = try XCTUnwrap(graph.adjacencyList[anchor2.identifier])
        XCTAssert(adjacentToAnchor1.contains(anchor2.identifier))
        XCTAssert(adjacentToAnchor2.contains(anchor1.identifier))
        // Should not add edge if it already exists
        XCTAssertEqual(adjacentToAnchor1.count, 1)
        XCTAssertEqual(adjacentToAnchor2.count, 1)
        // Vertecies should exist
        let graphAnchor1 = try XCTUnwrap(graph.vertices[anchor1.identifier])
        let graphAnchor2 = try XCTUnwrap(graph.vertices[anchor2.identifier])
        XCTAssertEqual(graphAnchor1, anchor1)
        XCTAssertEqual(graphAnchor2, anchor2)
    }
    
    
    // MARK: Remove
    
    func testRemove() throws {
        // Given
        let anchor1 = GeoARNavigationAnchor(transform: matrix_identity_float4x4)
        let anchor2 = GeoARNavigationAnchor(transform: matrix_identity_float4x4)
        let graph = GeoARNavigationGraph()
        graph.add(from: anchor1, to: anchor2)
        // When
        graph.remove(from: anchor1, to: anchor2)
        // Then
        XCTAssertNil(graph.adjacencyList[anchor1.identifier])
        XCTAssertNil(graph.adjacencyList[anchor2.identifier])
        // Vertecies should not exist
        XCTAssertNil(graph.vertices[anchor1.identifier])
        XCTAssertNil(graph.vertices[anchor2.identifier])
    }
    
    func testRemoveWithEdgeAlreadyRemoved() throws {
        // Given
        let anchor1 = GeoARNavigationAnchor(transform: matrix_identity_float4x4)
        let anchor2 = GeoARNavigationAnchor(transform: matrix_identity_float4x4)
        let graph = GeoARNavigationGraph()
        graph.add(from: anchor1, to: anchor2)
        graph.remove(from: anchor1, to: anchor2)
        graph.remove(from: anchor2, to: anchor1)
        // When
        graph.remove(from: anchor1, to: anchor2)
        // Then
        XCTAssertNil(graph.adjacencyList[anchor1.identifier])
        XCTAssertNil(graph.adjacencyList[anchor2.identifier])
        // Vertecies should not exist
        XCTAssertNil(graph.vertices[anchor1.identifier])
        XCTAssertNil(graph.vertices[anchor2.identifier])
    }
    
    func testRemoveWithTwoEdgesAdded() throws {
        // Given
        let anchor1 = GeoARNavigationAnchor(transform: matrix_identity_float4x4)
        let anchor2 = GeoARNavigationAnchor(transform: matrix_identity_float4x4)
        let anchor3 = GeoARNavigationAnchor(transform: matrix_identity_float4x4)
        let graph = GeoARNavigationGraph()
        graph.add(from: anchor1, to: anchor2)
        graph.add(from: anchor2, to: anchor3)
        // When
        graph.remove(from: anchor1, to: anchor2)
        // Then
        XCTAssertNil(graph.adjacencyList[anchor1.identifier])
        let adjacentToAnchor2 = try XCTUnwrap(graph.adjacencyList[anchor2.identifier])
        let adjacentToAnchor3 = try XCTUnwrap(graph.adjacencyList[anchor3.identifier])
        // Edge between anchor1 and anchor2 should not exist
        XCTAssertFalse(adjacentToAnchor2.contains(anchor1.identifier))
        // Vertex anchor1 removed from graph
        XCTAssertNil(graph.vertices[anchor1.identifier])
        // Edge between anchor2 and anchor3 should exist
        XCTAssert(adjacentToAnchor2.contains(anchor3.identifier))
        XCTAssert(adjacentToAnchor3.contains(anchor2.identifier))
        // Vertecies anchor2 and anchor3 are in the graph
        let graphAnchor2 = try XCTUnwrap(graph.vertices[anchor2.identifier])
        let graphAnchor3 = try XCTUnwrap(graph.vertices[anchor3.identifier])
        XCTAssertEqual(graphAnchor2, anchor2)
        XCTAssertEqual(graphAnchor3, anchor3)
    }
    
    
    // MARK: Update
    
    func testUpdate() throws {
        // Given
        let anchor1 = GeoARNavigationAnchor(transform: matrix_identity_float4x4)
        let anchor2 = GeoARNavigationAnchor(transform: matrix_identity_float4x4)
        let anchor1Copy = GeoARNavigationAnchor(anchor: anchor1)
        anchor1.accessibilityLabel = "anchor1"
        anchor2.accessibilityLabel = "anchor2"
        anchor1Copy.accessibilityLabel = "anchor1Copy"
        let graph = GeoARNavigationGraph()
        graph.add(from: anchor1, to: anchor2)
        // When
        graph.update(anchor1Copy)
        // Then
        XCTAssertNotEqual(graph.vertices[anchor1.identifier], anchor1)
        XCTAssertNotEqual(graph.vertices[anchor1.identifier]?.accessibilityLabel, "anchor1")
        XCTAssertEqual(graph.vertices[anchor1.identifier], anchor1Copy)
        XCTAssertEqual(graph.vertices[anchor1.identifier]?.accessibilityLabel, "anchor1Copy")
    }
    
    func testUpdateWithNonExistentVertex() throws {
        // Given
        let anchor1 = GeoARNavigationAnchor(transform: matrix_identity_float4x4)
        let anchor2 = GeoARNavigationAnchor(transform: matrix_identity_float4x4)
        let anchor3 = GeoARNavigationAnchor(transform: matrix_identity_float4x4)
        let graph = GeoARNavigationGraph()
        graph.add(from: anchor1, to: anchor2)
        // When
        graph.update(anchor3)
        // Then
        let adjacentToAnchor1 = try XCTUnwrap(graph.adjacencyList[anchor1.identifier])
        let adjacentToAnchor2 = try XCTUnwrap(graph.adjacencyList[anchor2.identifier])
        // Vertex anchor3 should not be added
        XCTAssertNil(graph.vertices[anchor3.identifier])
        // Edge to anchor3 should not be added
        XCTAssertFalse(adjacentToAnchor1.contains(anchor3.identifier))
        XCTAssertFalse(adjacentToAnchor2.contains(anchor3.identifier))
    }
    
    
    // MARK: Path
    
    func testPath1() throws {
        // Given
        var transform1 = matrix_identity_float4x4
        var transform2 = matrix_identity_float4x4
        var transform3 = matrix_identity_float4x4
        var transform4 = matrix_identity_float4x4
        transform1[3] = simd_float4(0, 0, 0, 1)
        transform2[3] = simd_float4(0, 0, 1, 1)
        transform3[3] = simd_float4(1, 0, 0, 1)
        transform4[3] = simd_float4(-1, 0, 0, 1)
        let anchor1 = GeoARNavigationAnchor(transform: transform1)
        let anchor2 = GeoARNavigationAnchor(transform: transform2)
        let anchor3 = GeoARNavigationAnchor(transform: transform3)
        let anchor4 = GeoARNavigationAnchor(transform: transform4)
        // Graph (Top View)
        // 4 - 1 - 3
        //     | /
        //     2
        let graph = GeoARNavigationGraph()
        graph.add(from: anchor1, to: anchor2)
        graph.add(from: anchor1, to: anchor3)
        graph.add(from: anchor1, to: anchor4)
        graph.add(from: anchor2, to: anchor3)
        graph.start = anchor2.identifier
        graph.end = anchor4.identifier
        // When
        let path = graph.path()
        // Then
        XCTAssertEqual(path.count, 3)
        try XCTSkipUnless(path.count == 3)
        XCTAssertEqual(path[0], anchor2)
        XCTAssertEqual(path[1], anchor1)
        XCTAssertEqual(path[2], anchor4)
    }
    
    func testPath2() throws {
        // Given
        var transform1 = matrix_identity_float4x4
        var transform2 = matrix_identity_float4x4
        var transform3 = matrix_identity_float4x4
        var transform4 = matrix_identity_float4x4
        var transform5 = matrix_identity_float4x4
        transform1[3] = simd_float4(0, 0, 0, 1)
        transform2[3] = simd_float4(1, 0, 1, 1)
        transform3[3] = simd_float4(-1, 0, 1, 1)
        transform4[3] = simd_float4(-1, 0, -1, 1)
        transform5[3] = simd_float4(0, 0, -1, 1)
        let anchor1 = GeoARNavigationAnchor(transform: transform1)
        let anchor2 = GeoARNavigationAnchor(transform: transform2)
        let anchor3 = GeoARNavigationAnchor(transform: transform3)
        let anchor4 = GeoARNavigationAnchor(transform: transform4)
        let anchor5 = GeoARNavigationAnchor(transform: transform5)
        // Graph (Top View)
        // 4 - 5
        // |   |
        // |   1
        // | /   \
        // 3 - - - 2
        let graph = GeoARNavigationGraph()
        graph.add(from: anchor1, to: anchor2)
        graph.add(from: anchor1, to: anchor3)
        graph.add(from: anchor1, to: anchor5)
        graph.add(from: anchor2, to: anchor3)
        graph.add(from: anchor3, to: anchor4)
        graph.add(from: anchor4, to: anchor5)
        graph.start = anchor2.identifier
        graph.end = anchor4.identifier
        // When
        let path = graph.path()
        // Then
        XCTAssertEqual(path.count, 4)
        try XCTSkipUnless(path.count == 4)
        XCTAssertEqual(path[0], anchor2)
        XCTAssertEqual(path[1], anchor1)
        XCTAssertEqual(path[2], anchor5)
        XCTAssertEqual(path[3], anchor4)
    }
    
    func testPath3() throws {
        // Given
        var transform1 = matrix_identity_float4x4
        var transform2 = matrix_identity_float4x4
        var transform3 = matrix_identity_float4x4
        var transform4 = matrix_identity_float4x4
        var transform5 = matrix_identity_float4x4
        transform1[3] = simd_float4(0, 0, 0, 1)
        transform2[3] = simd_float4(1, 0, 1, 1)
        transform3[3] = simd_float4(-1, 0, 1, 1)
        transform4[3] = simd_float4(-1, 0, -1, 1)
        transform5[3] = simd_float4(1, 0, -1, 1)
        let anchor1 = GeoARNavigationAnchor(transform: transform1)
        let anchor2 = GeoARNavigationAnchor(transform: transform2)
        let anchor3 = GeoARNavigationAnchor(transform: transform3)
        let anchor4 = GeoARNavigationAnchor(transform: transform4)
        let anchor5 = GeoARNavigationAnchor(transform: transform5)
        // Graph (Top View)
        // 4 - - - 5
        // |     /
        // |   1
        // | /   \
        // 3 - - - 2
        let graph = GeoARNavigationGraph()
        graph.add(from: anchor1, to: anchor2)
        graph.add(from: anchor1, to: anchor3)
        graph.add(from: anchor1, to: anchor5)
        graph.add(from: anchor2, to: anchor3)
        graph.add(from: anchor3, to: anchor4)
        graph.add(from: anchor4, to: anchor5)
        graph.start = anchor2.identifier
        graph.end = anchor4.identifier
        // When
        let path = graph.path()
        // Then
        XCTAssertEqual(path.count, 3)
        try XCTSkipUnless(path.count == 3)
        XCTAssertEqual(path[0], anchor2)
        XCTAssertEqual(path[1], anchor3)
        XCTAssertEqual(path[2], anchor4)
    }
    
    
    // MARK: Trail
    
    func testTrail() throws {
        // Given
        var transform1 = matrix_identity_float4x4
        var transform2 = matrix_identity_float4x4
        var transform3 = matrix_identity_float4x4
        transform1[3] = simd_float4(-1, 0, 1, 1)
        transform2[3] = simd_float4(-1, 0, -1, 1)
        transform3[3] = simd_float4(1, 0, -1, 1)
        let anchor1 = GeoARNavigationAnchor(transform: transform1)
        let anchor2 = GeoARNavigationAnchor(transform: transform2)
        let anchor3 = GeoARNavigationAnchor(transform: transform3)
        // Graph (Top View)
        // 2 - - - 3
        // |
        // |
        // |
        // 1
        let graph = GeoARNavigationGraph()
        graph.add(from: anchor1, to: anchor2)
        graph.add(from: anchor2, to: anchor3)
        graph.start = anchor1.identifier
        graph.end = anchor3.identifier
        // When
        let trail = graph.trail(stepSize: 3)
        // Then
        XCTAssertEqual(trail.count, 2)
        try XCTSkipUnless(trail.count == 2)
        
        // First transform
        XCTAssertEqual(trail[0][0,0], 1, accuracy: 1e-6)
        XCTAssertEqual(trail[0][0,1], 0, accuracy: 1e-6)
        XCTAssertEqual(trail[0][0,2], 0, accuracy: 1e-6)
        XCTAssertEqual(trail[0][0,3], 0, accuracy: 1e-6)
        XCTAssertEqual(trail[0][1,0], 0, accuracy: 1e-6)
        XCTAssertEqual(trail[0][1,1], 1, accuracy: 1e-6)
        XCTAssertEqual(trail[0][1,2], 0, accuracy: 1e-6)
        XCTAssertEqual(trail[0][1,3], 0, accuracy: 1e-6)
        XCTAssertEqual(trail[0][2,0], 0, accuracy: 1e-6)
        XCTAssertEqual(trail[0][2,1], 0, accuracy: 1e-6)
        XCTAssertEqual(trail[0][2,2], 1, accuracy: 1e-6)
        XCTAssertEqual(trail[0][2,3], 0, accuracy: 1e-6)
        XCTAssertEqual(trail[0][3,0], -1, accuracy: 1e-6)
        XCTAssertEqual(trail[0][3,1], 0, accuracy: 1e-6)
        XCTAssertEqual(trail[0][3,2], 1, accuracy: 1e-6)
        XCTAssertEqual(trail[0][3,3], 1, accuracy: 1e-6)
        
        // Second transform
        XCTAssertEqual(trail[1][0,0], 0, accuracy: 1e-6)
        XCTAssertEqual(trail[1][0,1], 0, accuracy: 1e-6)
        XCTAssertEqual(trail[1][0,2], 1, accuracy: 1e-6)
        XCTAssertEqual(trail[1][0,3], 0, accuracy: 1e-6)
        XCTAssertEqual(trail[1][1,0], 0, accuracy: 1e-6)
        XCTAssertEqual(trail[1][1,1], 1, accuracy: 1e-6)
        XCTAssertEqual(trail[1][1,2], 0, accuracy: 1e-6)
        XCTAssertEqual(trail[1][1,3], 0, accuracy: 1e-6)
        XCTAssertEqual(trail[1][2,0], -1, accuracy: 1e-6)
        XCTAssertEqual(trail[1][2,1], 0, accuracy: 1e-6)
        XCTAssertEqual(trail[1][2,2], 0, accuracy: 1e-6)
        XCTAssertEqual(trail[1][2,3], 0, accuracy: 1e-6)
        XCTAssertEqual(trail[1][3,0], 0, accuracy: 1e-6)
        XCTAssertEqual(trail[1][3,1], 0, accuracy: 1e-6)
        XCTAssertEqual(trail[1][3,2], -1, accuracy: 1e-6)
        XCTAssertEqual(trail[1][3,3], 1, accuracy: 1e-6)
    }
    
    
    // MARK: Codable
    
//    func testCodable() throws {
//        XCTExpectFailure("Seems to be working on device but not simulator?")
//        // Given
//        let anchor1 = GeoARNavigationAnchor(transform: matrix_identity_float4x4)
//        let anchor2 = GeoARNavigationAnchor(transform: matrix_identity_float4x4)
//        let graph = GeoARNavigationGraph()
//        graph.add(from: anchor1, to: anchor2)
//        // When
//        let encoded = try NSKeyedArchiver.archivedData(withRootObject: graph, requiringSecureCoding: true)
//        let decodedWrapped = try NSKeyedUnarchiver.unarchivedObject(ofClass: GeoARNavigationGraph.self, from: encoded)
//        let decoded = try XCTUnwrap(decodedWrapped)
//        // Then
//        let adjacentToAnchor1 = try XCTUnwrap(decoded.adjacencyList[anchor1.identifier])
//        let adjacentToAnchor2 = try XCTUnwrap(decoded.adjacencyList[anchor2.identifier])
//        XCTAssert(adjacentToAnchor1.contains(anchor2.identifier))
//        XCTAssert(adjacentToAnchor2.contains(anchor1.identifier))
//        let graphAnchor1 = try XCTUnwrap(decoded.vertices[anchor1.identifier])
//        let graphAnchor2 = try XCTUnwrap(decoded.vertices[anchor2.identifier])
//        XCTAssertEqual(graphAnchor1, anchor1)
//        XCTAssertEqual(graphAnchor2, anchor2)
//    }
}

