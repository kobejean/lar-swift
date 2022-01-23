//
//  LARLocationObserver.swift
//  
//
//  Created by Jean Flaherty on 2022/01/24.
//

import ARKit
import CoreLocation
import Collections
import Foundation

public struct LARPositionObservation {
    public let timestamp: TimeInterval
    public let position: simd_float3
    
    init(timestamp: TimeInterval, position: simd_float3) {
        self.timestamp = timestamp
        self.position = position
    }
    
    public init(frame: ARFrame) {
        self.init(timestamp: frame.timestamp, position: simd_make_float3(frame.camera.transform[3]))
    }
    
    func interpolate(other: Self, timestamp: TimeInterval) -> Self {
        let alpha = Float((timestamp - self.timestamp) / (other.timestamp - self.timestamp))
        let position = alpha * self.position + (1-alpha) * other.position
        return Self(timestamp: timestamp, position: position)
    }
}

public class LARLocationMatcher {
    
    private var positions = Deque<LARPositionObservation>()
    private var locations = Deque<CLLocation>()
    
    
    public init() {
    }
    
    public func matches() -> [(CLLocation, simd_float3)] {
        var matches = [(CLLocation, simd_float3)]()
        guard positions.count > 1 else { return matches }
        
        while let location = locations.first, let observation = match(location: location) {
            matches.append((location, observation.position))
            locations.removeFirst()
        }
        
        return matches
    }
    
    func match(location: CLLocation) -> LARPositionObservation? {
        let timestamp = location.timestamp.timeIntervalSinceBootup()
        // TODO: Consider if its worth doing binary search instead
        guard let i = positions.lastIndex(where: { $0.timestamp < timestamp }),
              i+1 < positions.count
        else { return nil }
        
        let position = positions[i].interpolate(other: positions[i+1], timestamp: timestamp)
        positions.removeFirst(i)
        return position
    }
    
    public func observe(location: CLLocation) {
        guard positions.count > 0 else { return }
        locations.append(location)
    }
    
    public func observe(position: LARPositionObservation) {
        positions.append(position)
        
        // If we have a 10min backlog, that's too many observations
        if positions.count > 36000 {
            positions.removeFirst(18000)
        }
    }
    
    
}
