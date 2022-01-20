//
//  ARSessionInternalDelegate.swift
//  
//
//  Created by Jean Flaherty on 6/14/21.
//

import Foundation
import ARKit

protocol ARSessionInternalDelegate: ARSessionDelegate {
    var isPausingDelegateCalls: Bool { get set }
    var isCallingDelegateManually: Bool { get set }
}
