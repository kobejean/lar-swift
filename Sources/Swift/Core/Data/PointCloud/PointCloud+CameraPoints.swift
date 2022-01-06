//
//  PointCloud+CameraPoints.swift.swift
//
//
//  Created by Jean Flaherty on 6/26/21.
//

import Foundation

extension PointCloud {
    
    func add(_ cameraPoint: CameraPoint) {
        self.cameraPoints.append(cameraPoint)
    }
    
}
