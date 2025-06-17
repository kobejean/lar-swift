//
//  LARSCNNodeCollection.swift
//
//
//  Created by Jean Flaherty on 2025/05/26.
//
import simd
import Foundation
import SceneKit

public class LARSCNNodeCollection {
    public var anchorNodes: [LARSCNAnchorNode] = []
	public var nodeById: [Int32:LARSCNAnchorNode] = [:]
    
    public init() {}
    
    /// Find nearest node within a distance
    public func nearest(vec: simd_float3, within: Float) -> LARSCNAnchorNode? {
        guard !anchorNodes.isEmpty else { return nil } // Handle empty collection
        
        var nearestDistance = within
        var nearest: LARSCNAnchorNode? = nil
        
        for node in anchorNodes {
            let distance = simd_distance(node.simdWorldPosition, vec) // Fixed: use simdPosition and vec
            if distance < nearestDistance {
                nearestDistance = distance
                nearest = node
            }
        }
        return nearest
    }
    
    // MARK: - Convenience Methods

    /// Add a node to the collection
    public func add(_ node: LARSCNAnchorNode) {
        anchorNodes.append(node)
        nodeById[node.anchorId] = node
    }
    
    /// Remove a node from the collection
    public func remove(_ node: LARSCNAnchorNode) {
        anchorNodes.removeAll { $0 === node }
    }
    
    /// Remove node by anchorId
    public func remove(withId anchorId: Int32) {
        anchorNodes.removeAll { $0.anchorId == anchorId }
        nodeById.removeValue(forKey: anchorId)
    }
}
