//
//  ARSession+Extension.swift
//  
//
//  Created by Jean Flaherty on 6/14/21.
//

import Foundation
import ARKit

extension ARSession {
    
    @inline(__always)
    var delegateForwarder: ARSessionDelegateForwarder? {
        return delegate as? ARSessionDelegateForwarder
    }
    
    @inline(__always)
    var externalDelegate: ARSessionDelegate? {
        return delegateForwarder?.externalDelegate
    }
    
    func update(anchors oldAnchors: [ARAnchor], with newAnchors: [ARAnchor]) {
        guard let internalDelegate = delegateForwarder?.internalDelegate as? ARSessionInternalDelegate else { return }
        internalDelegate.isPausingDelegateCalls = true
        
        for (oldAnchor, newAnchor) in zip(oldAnchors, newAnchors) {
            remove(anchor: oldAnchor)
            add(anchor: newAnchor)
        }
        
        internalDelegate.isPausingDelegateCalls = false
        
        delegateQueue?.async { [weak self] in
            guard let self = self else { return }
            internalDelegate.isCallingDelegateManually = true
            self.delegate?.session?(self, didUpdate: newAnchors)
            internalDelegate.isCallingDelegateManually = false
        }
    }
    
    func alignWorld(relativeTransform: simd_float4x4) {
        // Filter out anchors that are automatically tracked so as not to interfere.
        let anchors = currentFrame?.anchors.filter({ $0.isStationary() }) ?? []
        self.setWorldOrigin(relativeTransform: relativeTransform)
        // Re-add anchors with same transform so that anchors are in a new position under new origin
        update(anchors: anchors, with: anchors)
    }
    
}
