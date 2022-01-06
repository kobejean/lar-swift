//
//  GeoARNavigationGraph.swift
//  
//
//  Created by Jean Flaherty on 7/9/21.
//

import Foundation
import ARKit


public class GeoARNavigationGraph: NSObject, NSCoding, NSSecureCoding {
    
    public typealias Vertex = GeoARNavigationAnchor
    
    var vertices = [UUID : Vertex]()
    var adjacencyList = [UUID : [UUID]]()
    public var start: UUID?
    public var end: UUID?
    
    public override init() {
        super.init()
    }
    
    // MARK: Graph Methods
    
    public func add(from source: Vertex, to destination: Vertex) {
        let edgeExists = adjacencyList[source.identifier]?.contains(destination.identifier) == true
        guard !edgeExists else { return }
        // Add edge
        adjacencyList[source.identifier, default: []].append(destination.identifier)
        adjacencyList[destination.identifier, default: []].append(source.identifier)
        // Add vertecies
        vertices[source.identifier] = source
        vertices[destination.identifier] = destination
    }
    
    public func remove(from source: Vertex, to destination: Vertex) {
        let edgeExists = adjacencyList[source.identifier]?.contains(destination.identifier) == true
        guard edgeExists else { return }
        // Remove edge
        adjacencyList[source.identifier]!.removeAll(where: { $0 == destination.identifier })
        adjacencyList[destination.identifier]!.removeAll(where: { $0 == source.identifier })
        // Remove source vertex if nothing connects to it anymore
        if adjacencyList[source.identifier]!.count == 0 {
            adjacencyList[source.identifier] = nil
            vertices[source.identifier] = nil
        }
        // Remove destination vertex if nothing connects to it anymore
        if adjacencyList[destination.identifier]!.count == 0 {
            adjacencyList[destination.identifier] = nil
            vertices[destination.identifier] = nil
        }
    }
    
    public func update(_ vertex: Vertex) {
        guard vertices[vertex.identifier] != nil else { return }
        vertices[vertex.identifier] = vertex
    }
    
    public func path() -> [Vertex] {
        guard let start = start,
              let end = end,
              let source = vertices[start],
              let destination = vertices[end]
        else { return [] }
        guard start != end else { return [source] }
        
        var parents = [Vertex : Vertex]()
        var visted = [Vertex : Bool]()
        
        typealias QueueItem = (vertex: Vertex, parent: Vertex?, distance: Float, heuristic: Float)
        var queue = PriorityQueue<QueueItem> { $0.heuristic < $1.heuristic }
        
        // Enqueue first item
        let initialItem: QueueItem = (source, nil, 0, source.distance(to: destination))
        queue.enqueue(initialItem)
        
        
        while let (vertex, parent, distance, _) = queue.dequeue() {
            // Skip if already visited
            guard visted[vertex] != true else { continue }
            
            // Assign parent and mark as visited
            parents[vertex] = parent
            visted[vertex] = true
            
            // Check if we reached the destination
            if vertex == destination {
                // We have found the destination and just need to backtrack to get the path
                return _backtracking(parents: parents, last: destination)
            }
            
            // Enqueue adjacent verticies
            for adjacentIdentifier in adjacencyList[vertex.identifier] ?? [] {
                guard let adjacent = vertices[adjacentIdentifier] else { continue }
                // Add edge length to distance
                let distance = distance + vertex.distance(to: adjacent)
                // A* algorithm heuristics
                let heuristic = distance + adjacent.distance(to: destination)
                
                let item: QueueItem = (adjacent, vertex, distance, heuristic)
                queue.enqueue(item)
            }
        }
        
        // No connecting path
        return []
    }
    
    private func _backtracking(parents: [Vertex : Vertex], last: Vertex) -> [Vertex] {
        var ancestors = [last]
        var current = last
        while let parent = parents[current] {
            ancestors.append(parent)
            current = parent
        }
        // NOTE: If we flip sourse and destination, we don't have to reverse as backtracking becomes
        // forward tracking. But I'm keeping it this way for readability.
        return Array(ancestors.reversed())
    }
    
    public func trail(stepSize: Float = 0.5) -> [simd_float4x4] {
        let path = self.path()
        
        guard path.count >= 2 else { return [] }
        
        // Previous vertex
        var previous = path.first!
        // Trail of transforms
        var trail = [simd_float4x4]()
        // Length traveled in current segment
        var segmentTravelLength: Float = 0
        
        for vertex in path.dropFirst() {
            let segmentLength = previous.distance(to: vertex)
            
            let (direction3, direction4) = { () -> (simd_float3, simd_float4) in
                let displacement3 = simd_make_float3(vertex.transform[3] - previous.transform[3])
                let direction3 = simd_normalize(displacement3)
                return (direction3, simd_make_float4(direction3))
            }()
            
            // Orientation x-axis
            let (xAxis3, xAxis4) = { () -> (simd_float3, simd_float4) in
                let xAxis3 = simd_cross(direction3, matrix_identity_float3x3[1])
                return (xAxis3, simd_make_float4(xAxis3))
            }()
            // Orientation y-axis
            let (yAxis3, yAxis4) = { () -> (simd_float3, simd_float4) in
                let yAxis3 = simd_cross(xAxis3, direction3)
                return (yAxis3, simd_make_float4(yAxis3))
            }()
            // Orientation z-axis
            let zAxis4 = { () -> simd_float4 in
                let zAxis3 = simd_cross(xAxis3, yAxis3)
                return simd_make_float4(zAxis3)
            }()
            let orientation = simd_float4x4(xAxis4, yAxis4, zAxis4, matrix_identity_float4x4[3])
                
            
            while segmentTravelLength <= segmentLength {
                var transform = orientation
                transform[3] = previous.transform[3] + direction4 * segmentTravelLength
                
                trail.append(transform)
                segmentTravelLength += stepSize
            }
            
            previous = vertex
            segmentTravelLength -= segmentLength
        }
        
        return trail
    }
    
    
    // MARK: NSCoding
    
    enum CodingKeys: String {
        case adjacencyList = "adjacencyList"
        case start = "start"
        case end = "end"
    }
    
    public class var supportsSecureCoding: Bool {
        return true
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(adjacencyList, forKey: CodingKeys.adjacencyList.rawValue)
        coder.encode(start, forKey: CodingKeys.start.rawValue)
        coder.encode(end, forKey: CodingKeys.end.rawValue)
    }
    
    public required init?(coder: NSCoder) {
        guard let adjacencyList = coder.decodeObject(
                of: [NSDictionary.self, NSArray.self, NSUUID.self],
                forKey: CodingKeys.adjacencyList.rawValue) as? [UUID : [UUID]]
        else { return nil }
        self.adjacencyList = adjacencyList
        self.start = coder.decodeObject(of: NSUUID.self, forKey: CodingKeys.start.rawValue) as UUID?
        self.end = coder.decodeObject(of: NSUUID.self, forKey: CodingKeys.end.rawValue) as UUID?
    }
}
