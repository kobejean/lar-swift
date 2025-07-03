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
    
}
