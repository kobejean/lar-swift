//
//  Conversion.swift
//  LARScan
//
//  Created by Jean Flaherty on 2022/01/30.
//

import Foundation
import SceneKit
import simd

func transformFrom(position: simd_double3) -> SCNMatrix4 {
    var transform = SCNMatrix4Identity
    transform.m41 = Float(position.x)
    transform.m42 = Float(position.y)
    transform.m43 = Float(position.z)
    return transform
}

func dateFrom(uptime: TimeInterval) -> Date {
    return Date(timeIntervalSinceNow: uptime - ProcessInfo.processInfo.systemUptime)
}
