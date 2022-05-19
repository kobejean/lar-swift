//
//  LARGraph.swift
//  
//
//  Created by Jean Flaherty on 2022/02/06.
//

import Foundation

class LARGraph: LARAnchored {
    var anchors = Set<LARAnchor>()
    var pivot: Int?
    var vertices = [Int : LARAnchor]()
    var adjacencyList = [Int : Set<Int>]()
    private var id_count = 0
}
