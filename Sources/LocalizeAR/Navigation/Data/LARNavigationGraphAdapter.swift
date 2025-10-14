//
//  LARNavigationGraphAdapter.swift
//  LocalizeAR
//
//  Created by Jean Atsumi Flaherty on 2025-10-05.
//

import Foundation
import LocalizeAR_ObjC

/// Adapts LARMap's anchor and edge data for navigation purposes
/// This is a proper adapter that queries the map directly - no duplicate state
public class LARNavigationGraphAdapter {
    // MARK: - Properties
    private weak var map: LARMap?

    // MARK: - Initialization
    public init(map: LARMap) {
        self.map = map
    }

    // MARK: - Anchor Management

    /// Get all anchors as a dictionary (computed from map)
    public var anchors: [Int32: LARAnchor] {
        guard let map = map else { return [:] }
        var result: [Int32: LARAnchor] = [:]
        for anchor in map.anchors {
            result[anchor.id] = anchor
        }
        return result
    }

    /// Get an anchor by ID
    /// - Parameter anchorId: ID of the anchor
    /// - Returns: The anchor, or nil if not found
    public func anchor(for anchorId: Int32) -> LARAnchor? {
        guard let map = map else { return nil }
        return map.anchors.first(where: { $0.id == anchorId })
    }

    // MARK: - Edge Management

    /// Get all edges as tuples (computed from map)
    public var edges: [(from: Int32, to: Int32)] {
        guard let map = map else { return [] }

        var result: [(from: Int32, to: Int32)] = []
        for (fromId, toIds) in map.edges {
            let from = Int32(truncating: fromId)
            for toId in toIds {
                let to = Int32(truncating: toId)
                // Only add each edge once (avoid duplicates for bidirectional edges)
                if to > from {
                    result.append((from: from, to: to))
                }
            }
        }
        return result
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
