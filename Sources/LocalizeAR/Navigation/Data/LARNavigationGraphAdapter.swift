//
//  LARNavigationGraphAdapter.swift
//  LocalizeAR
//
//  Created by Jean Atsumi Flaherty on 2025-10-05.
//

import Foundation
import LocalizeAR_ObjC

/// Adapts LARMap's anchor and edge data for navigation purposes
/// This is a lightweight data container that doesn't handle rendering
public class LARNavigationGraphAdapter {
    // MARK: - Properties
    private weak var map: LARMap?
    private(set) var anchors: [Int32: LARAnchor] = [:]
    private(set) var edges: [(from: Int32, to: Int32)] = []

    // MARK: - Initialization
    public init(map: LARMap) {
        self.map = map
    }

    // MARK: - Anchor Management

    /// Add an anchor to the graph
    /// - Parameter anchor: The anchor to add
    public func addAnchor(_ anchor: LARAnchor) {
        anchors[anchor.id] = anchor
    }

    /// Remove an anchor from the graph
    /// - Parameter anchorId: ID of the anchor to remove
    public func removeAnchor(id anchorId: Int32) {
        anchors.removeValue(forKey: anchorId)
    }

    /// Get an anchor by ID
    /// - Parameter anchorId: ID of the anchor
    /// - Returns: The anchor, or nil if not found
    public func anchor(for anchorId: Int32) -> LARAnchor? {
        return anchors[anchorId]
    }

    /// Remove all anchors
    public func removeAllAnchors() {
        anchors.removeAll()
    }

    // MARK: - Edge Management

    /// Add an edge between two anchors
    /// - Parameters:
    ///   - from: Source anchor ID
    ///   - to: Destination anchor ID
    public func addEdge(from: Int32, to: Int32) {
        // Avoid duplicates
        if !edges.contains(where: { ($0.from == from && $0.to == to) || ($0.from == to && $0.to == from) }) {
            edges.append((from, to))
        }
    }

    /// Remove edges associated with an anchor
    /// - Parameter anchorId: ID of the anchor
    public func removeEdges(for anchorId: Int32) {
        edges.removeAll { edge in
            edge.from == anchorId || edge.to == anchorId
        }
    }

    /// Remove all edges
    public func removeAllEdges() {
        edges.removeAll()
    }

    /// Get path between two anchors using BFS
    /// - Parameters:
    ///   - startId: Starting anchor ID
    ///   - goalId: Goal anchor ID
    /// - Returns: Array of anchor IDs representing the path, or empty if no path exists
    public func findPath(from startId: Int32, to goalId: Int32) -> [Int32] {
        // Build adjacency list
        var adjacencyList: [Int32: Set<Int32>] = [:]
        for edge in edges {
            adjacencyList[edge.from, default: []].insert(edge.to)
            adjacencyList[edge.to, default: []].insert(edge.from)
        }

        // BFS to find shortest path
        var queue: [(node: Int32, path: [Int32])] = [(startId, [startId])]
        var visited: Set<Int32> = [startId]

        while !queue.isEmpty {
            let (current, path) = queue.removeFirst()

            if current == goalId {
                return path
            }

            guard let neighbors = adjacencyList[current] else { continue }

            for neighbor in neighbors where !visited.contains(neighbor) {
                visited.insert(neighbor)
                queue.append((neighbor, path + [neighbor]))
            }
        }

        return [] // No path found
    }
}
