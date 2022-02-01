//
//  Mat.swift
//  
//
//  Created by Jean Flaherty on 2022/01/21.
//

#if os(iOS)

import ARKit
import opencv2

extension Mat {
    
    convenience init?(buffer: CVPixelBuffer, _ planeIndex: Int, _ type: Int32 = CvType.CV_8UC1) {
        let width = CVPixelBufferGetWidthOfPlane(buffer, planeIndex)
        let height = CVPixelBufferGetHeightOfPlane(buffer, planeIndex)
        let bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(buffer, planeIndex)
        guard let address = CVPixelBufferGetBaseAddressOfPlane(buffer, planeIndex) else { return nil }
        let data = Data(bytesNoCopy: address, count: height * bytesPerRow, deallocator: .none)
        self.init(
            rows: Int32(height),
            cols: Int32(width),
            type: type,
            data: data,
            step: bytesPerRow
        )
    }
    
    convenience init(rows: Int32, cols: Int32, data array: [Float]) {
        let data = array.withUnsafeBufferPointer { buffer in Data(buffer: buffer) }
        self.init(rows: rows, cols: cols, type: CvType.CV_32F, data: data)
    }
    
    func toSIMD() -> simd_double4x4 {
        return simd_double4x4(
            .init(self.at(row: 0, col: 0).v, self.at(row: 1, col: 0).v, self.at(row: 2, col: 0).v, self.at(row: 3, col: 0).v),
            .init(self.at(row: 0, col: 1).v, self.at(row: 1, col: 1).v, self.at(row: 2, col: 1).v, self.at(row: 3, col: 1).v),
            .init(self.at(row: 0, col: 2).v, self.at(row: 1, col: 2).v, self.at(row: 2, col: 2).v, self.at(row: 3, col: 2).v),
            .init(self.at(row: 0, col: 3).v, self.at(row: 1, col: 3).v, self.at(row: 2, col: 3).v, self.at(row: 3, col: 3).v)
        )
    }
    
}

#endif
