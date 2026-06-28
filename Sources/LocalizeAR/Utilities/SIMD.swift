//
//  SIMD.swift
//  
//
//  Created by Jean Flaherty on 2022/01/21.
//

import simd


extension simd_float4x4 {
    /// Extract position as simd_float3 from transform matrix
    public var position: simd_float3 {
        return simd_float3(columns.3.x, columns.3.y, columns.3.z)
    }
    public func toDouble() -> simd_double4x4 {
        return simd_double4x4(columns: (
            simd_double(columns.0), simd_double(columns.1), simd_double(columns.2), simd_double(columns.3)))
    }
}

extension simd_float3 {
	public var transform: simd_float4x4 {
		return simd_float4x4(
			simd_float4(1, 0, 0, 0),
			simd_float4(0, 1, 0, 0),
			simd_float4(0, 0, 1, 0),
			simd_float4(x, y, z, 1)
		)
	}
}

extension simd_double4x4 {
    /// Extract position as simd_float3 from transform matrix
    public var position: simd_double3 {
        return simd_double3(columns.3.x, columns.3.y, columns.3.z)
    }
    public func toFloat() -> simd_float4x4 {
        return simd_float4x4(columns: (
            simd_float(columns.0), simd_float(columns.1), simd_float(columns.2), simd_float(columns.3)))
    }
}

