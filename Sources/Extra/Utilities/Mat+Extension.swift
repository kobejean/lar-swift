//
//  Mat+Extension.swift
//  
//
//  Created by Jean Flaherty on 6/14/21.
//

import Foundation
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
        let data = array.withUnsafeBufferPointer { buffer in
            Data(buffer: buffer)
        }
        self.init(
            rows: Int32(rows),
            cols: Int32(cols),
            type: CvType.CV_32F,
            data: data
        )
    }
    
    func flatArray<T>() -> [T] {
        let pointer = UnsafeMutablePointer<T>(OpaquePointer(self.dataPointer()))
        return Array(UnsafeMutableBufferPointer(start: pointer, count: self.total()))
    }
    
}
