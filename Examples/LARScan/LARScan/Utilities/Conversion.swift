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

func transformFrom(position: simd_double3, orientation: simd_float3) -> SCNMatrix4 {
    let up = simd_float3(0,1,0)
    let x = simd_normalize(simd_cross(up, orientation))
    let y = simd_normalize(simd_cross(orientation, x))
    let z = simd_normalize(orientation)
    let t = simd_float3(position)

    let transform = SCNMatrix4(
        m11: x.x, m12: x.y, m13: x.z, m14: 0,
        m21: y.x, m22: y.y, m23: y.z, m24: 0,
        m31: z.x, m32: z.y, m33: z.z, m34: 0,
        m41: t.x, m42: t.y, m43: t.z, m44: 1
    )
    return transform
}

func dateFrom(uptime: TimeInterval) -> Date {
    return Date(timeIntervalSinceNow: uptime - ProcessInfo.processInfo.systemUptime)
}
