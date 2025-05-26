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
    
    public func addFrame(_ frame: ARFrame)  {
        mapper.addFrame(frame)
    }
    
    public func addPosition(_ position: simd_float3, timestamp: Date) {
        mapper.addPosition(position, timestamp: timestamp)
    }
    
    public func addLocations(_ locations: [CLLocation]) {
        for location in locations {
            mapper.addLocation(location)
        }
    }
    
    public func createAnchor(transform: simd_float4x4) -> LARAnchor {
        return mapper.createAnchor(transform: transform)
    }
    
    #endif
    
    public init(directory: URL) {
        mapper = LARMapper(directory: directory)
        processor = LARMapProcessor(mapperData: mapper.data)
    }
}
