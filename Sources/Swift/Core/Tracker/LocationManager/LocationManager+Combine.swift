//
//  File.swift
//  
//
//  Created by Jean Flaherty on 7/4/21.
//

import Foundation
import ARKit
import CoreLocation
import Collections
import LANumerics

extension LocationManager {
    
    func combineUncombinedData() -> [LocationPoint] {
        var locationPoints = [LocationPoint]()
        
        guard _uncombinedFrames.count > 1 else { return locationPoints }
        
        while let location = _uncombinedLocations.first,
              let (before, after, discardCount) = _adjacentFrames(location: location) {
            
            // add geo-anchor
            let locationPoint = LocationPoint(
                before: before,
                after: after,
                location: location
            )
            locationPoints.append(locationPoint)
            
            // dequeue
            _uncombinedLocations.removeFirst()
            _uncombinedFrames.removeFirst(discardCount)
        }
        
        return locationPoints
    }
    
    
    // MARK: - Helper Methods
    
    private func _adjacentFrames(location: CLLocation) -> (before: Frame, after: Frame, discardCount: Int)? {
        let timestamp = location.timestamp.timeIntervalSinceBootup()
        guard let indexBefore = _uncombinedFrames.lastIndex(where: { $0.timestamp < timestamp }),
              indexBefore + 1 < _uncombinedFrames.count else { return nil }
        return (
            before: _uncombinedFrames[indexBefore],
            after: _uncombinedFrames[indexBefore + 1],
            discardCount: indexBefore
        )
    }
}

private extension LocationPoint{
    
    convenience init(before: LocationManager.Frame, after: LocationManager.Frame, location: CLLocation) {
        let locationTimestamp = location.timestamp.timeIntervalSinceBootup()
        // alpha is 0 when locationTimestamp == previousFrame.timestamp
        // and 1 when locationTimestamp == nextFrame.timestamp
        let alpha = (locationTimestamp - before.timestamp) / (after.timestamp - before.timestamp)
        let beforeCoordinate = before.cameraTransform.columns.3
        let afterCoordinate = after.cameraTransform.columns.3
        // TODO: See if there is a better way to do interpolation because
        // interpolation doesn't guarantee a normal rotation matrix.
        let interpolatedCoordinate = beforeCoordinate.interpolate(with: afterCoordinate, alpha: Float(alpha))
        
        var transform = matrix_identity_float4x4
        transform.columns.3 = interpolatedCoordinate
        
        self.init(transform: transform, location: location)
    }
    
}
