//
//  SIMD.swift
//  
//
//  Created by Jean Flaherty on 2022/01/21.
//

import opencv2
import simd

extension simd_float4x4 {
    func toDouble() -> simd_double4x4 {
        return simd_double4x4(columns: (
            simd_double(columns.0), simd_double(columns.1), simd_double(columns.2), simd_double(columns.3)))
    }
}

extension simd_double4x4 {
    func toFloat() -> simd_float4x4 {
        return simd_float4x4(columns: (
            simd_float(columns.0), simd_float(columns.1), simd_float(columns.2), simd_float(columns.3)))
    }
}

// MARK: To Mat

extension simd_float3x3 {
    func toMat() -> Mat {
        let data = [
            self[0,0], self[1,0], self[2,0],
            self[0,1], self[1,1], self[2,1],
            self[0,2], self[1,2], self[2,2],
        ].withUnsafeBufferPointer { buffer in Data(buffer: buffer) }
        return Mat(rows: 3, cols: 3, type: CvType.CV_32F, data: data)
    }
}

extension simd_double4x4 {
    func toMat() -> Mat {
        let data = [
            self[0,0], self[1,0], self[2,0], self[3,0],
            self[0,1], self[1,1], self[2,1], self[3,1],
            self[0,2], self[1,2], self[2,2], self[3,2],
            self[0,3], self[1,3], self[2,3], self[3,3],
        ].withUnsafeBufferPointer { buffer in Data(buffer: buffer) }
        return Mat(rows: 4, cols: 4, type: CvType.CV_64F, data: data)
    }
}
