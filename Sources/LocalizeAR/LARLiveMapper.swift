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
    let mapper: LARMapper
    let processor: LARMapProcessor
    public var data: LARMapper.Data { mapper.data }
    
    public func process()  {
        processor.process()
    }
    
    public func writeMetadata()  {
        mapper.writeMetadata()
    }
    
    #if os(iOS)
    
    public func add(frame: ARFrame)  {
        mapper.add(frame: frame)
    }
    
    public func add(position: simd_float3, timestamp: Date) {
        mapper.add(position: position, timestamp: timestamp)
    }
    
    public func add(locations: [CLLocation]) {
        for location in locations {
            mapper.add(location: location)
        }
    }
    
    #endif
    
    public init(directory: URL) {
        mapper = LARMapper(directory: directory)
        processor = LARMapProcessor(mapperData: mapper.data)
    }
}
