//
//  Selectable.swift
//  LARExplorer
//
//  Created by Assistant on 2025-09-19.
//

import Foundation
import SceneKit

/// Protocol for objects that can be selected in the scene
protocol Selectable {
    var selectableId: String { get }
    var categoryBitMask: Int { get }
}

/// Represents what type of object was selected
enum SelectableType {
    case anchor(id: Int32)
    case landmark(index: Int)
    case none
}

/// Result of a selection attempt
struct SelectionResult {
    let type: SelectableType
    let node: SCNNode
    let worldCoordinates: SCNVector3
}