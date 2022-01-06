//
//  DelegateForwarder.swift
//  
//
//  Created by Jean Flaherty on 5/30/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import ARKit

class DelegateForwarder<T: NSObjectProtocol>: NSObject {
    weak var internalDelegate: T?
    weak var externalDelegate: T?
    
    //    MARK: - Initialization
    
    init(internalDelegate: T? = nil, externalDelegate: T? = nil) {
        self.internalDelegate = internalDelegate
        self.externalDelegate = externalDelegate
    }
    
    
    //    MARK: - Forwarding
    
    override func responds(to sel: Selector!) -> Bool {
        return
            self.internalDelegate?.responds(to: sel) ?? false ||
            self.externalDelegate?.responds(to: sel) ?? false
    }
    
    override func forwardingTarget(for sel: Selector!) -> Any? {
        if self.internalDelegate?.responds(to: sel) == true {
            return self.internalDelegate
        }
        
        return self.externalDelegate
    }
    
}

class ARSCNViewDelegateForwarder: DelegateForwarder<ARSCNViewDelegate>, ARSCNViewDelegate {}
class ARSessionDelegateForwarder: DelegateForwarder<ARSessionDelegate>, ARSessionDelegate {}
