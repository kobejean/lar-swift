//
//  File.swift
//  
//
//  Created by Jean Flaherty on 6/23/21.
//

import Foundation
import ARKit

extension ARAnchor {
    
    func isStationary() -> Bool {
        if let trackable = self as? ARTrackable {
            return !trackable.isTracked
        }
        guard !(self is ARPlaneAnchor) else { return false }
        
        if #available(iOS 13.4, *) {
            return !(self is ARMeshAnchor)
        } else {
            return true
        }
    }
}
