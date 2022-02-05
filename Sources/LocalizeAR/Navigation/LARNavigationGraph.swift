//
//  LARNavigationGraph.swift
//  
//
//  Created by Jean Flaherty on 2022/02/02.
//

import Foundation
import SceneKit


public class LARNavigationGraph {
    
    public struct Vertex {
        let id: Int
        let position: simd_float3
    }
    
    let scnNode = SCNNode()
    var pivot: Int?
    var vertices = [Int : Vertex]()
    var adjacencyList = [Int : Set<Int>]()
    private var id_count = 0
    
    public func add(vertex: Vertex) {
        let id = id_count
        if let pivot = pivot {
            adjacencyList[pivot, default: []].insert(id)
            adjacencyList[id, default: []].insert(pivot)
        }
        vertices[id] = vertex
        pivot = id
        id_count += 1
    }
    
    public func remove(vertex: Vertex) {
        if let neighbors = adjacencyList[vertex.id] {
            for neighbor in neighbors {
                adjacencyList[neighbor]!.remove(vertex.id)
            }
        }
        pivot = adjacencyList[vertex.id]?.first
        adjacencyList.removeValue(forKey: vertex.id)
        vertices.removeValue(forKey: vertex.id)
    }
    
    public func query(position: simd_float3) -> Vertex? {
        var nearestDistance = Float.greatestFiniteMagnitude
        var nearest: Vertex?
        for vertex in vertices.values {
            let distance = simd_distance(vertex.position, position)
            if distance <= nearestDistance {
                nearestDistance = distance
                nearest = vertex
            }
        }
        return nearest
    }
    
}
