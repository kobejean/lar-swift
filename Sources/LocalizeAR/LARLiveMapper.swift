//
//  LARLiveMapper.swift
//  
//
//  Created by Jean Flaherty on 2022/01/28.
//

import Foundation
import LocalizeAR_ObjC
import CoreLocation

public actor LARLiveMapper {
    public let mapper: LARMapper
    public let processor: LARMapProcessor
    public var tracker: LARTracker!
    public var data: LARMapper.Data { mapper.data }
    
    public func updateTracker() {
        tracker = LARTracker(map: data.map)
    }
    
    public init(directory: URL) {
        mapper = LARMapper(directory: directory)
        processor = LARMapProcessor(mapperData: mapper.data)
    }
}
