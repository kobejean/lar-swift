//
//  GeoARNavigationAnchor.swift
//  
//
//  Created by Jean Flaherty on 7/9/21.
//

import Foundation
import ARKit

public class GeoARNavigationGraphAnchor: GeoARAnchor {
    
    public let graph: GeoARNavigationGraph
    
    public init(graph: GeoARNavigationGraph = GeoARNavigationGraph()) {
        self.graph = graph
        super.init(transform: matrix_identity_float4x4)
    }
    
    enum CodingKeys: String, CodingKey {
        case graph = "graph"
    }
    
    public override func encode(with coder: NSCoder) {
        coder.encode(graph, forKey: CodingKeys.graph.rawValue)
        super.encode(with: coder)
    }
    
    public required init?(coder: NSCoder) {
        guard let graph = coder.decodeObject(
                of: [GeoARNavigationGraph.self],
                forKey: CodingKeys.graph.rawValue) as? GeoARNavigationGraph
        else { return nil }
        self.graph = graph
        super.init(coder: coder)
    }
    
    public class override var supportsSecureCoding: Bool { return true }
}
