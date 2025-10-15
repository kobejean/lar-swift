//
//  FrameData.swift
//  LARBenchmark
//
//  Swift equivalent of C++ FrameData struct from lar_localize.cpp
//

import Foundation
import CoreGraphics
import LocalizeAR

struct FrameData {
    let frame: LARFrame
    let image: CGImage
    var localized: Bool = false
    var resultTransform: [[Double]]? = nil  // 4x4 matrix

    init(frame: LARFrame, image: CGImage) {
        self.frame = frame
        self.image = image
    }
}
