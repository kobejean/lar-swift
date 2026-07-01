//
//  LARMapper.swift
//  
//
//  Created by Jean Flaherty on 2022/02/02.
//

import Foundation
import CoreLocation
import LocalizeAR_ObjC

public extension LARMapper {
    
    func addLocations(_ locations: [CLLocation]) {
        for location in locations {
            addLocation(location)
        }
    }

#if os(iOS)
    /// Add a captured color frame to the map. Unpacks the owned pixel buffer + pose metadata (see
    /// `LARColorFrame`) and forwards to the pixel-buffer mapping API.
    func addFrame(_ colorFrame: LARColorFrame) {
        let frame = colorFrame.frame
        addFrame(pixelBuffer: colorFrame.pixelBuffer,
                 intrinsics: frame.intrinsics,
                 timestamp: TimeInterval(frame.timestamp) / 1000.0,
                 transform: frame.extrinsics)
    }
#endif

}
