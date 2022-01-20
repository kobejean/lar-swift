//
//  PointCloud+LocationPoints.swift
//
//
//  Created by Jean Flaherty on 6/26/21.
//

import Foundation
import LANumerics
import CoreLocation
import simd


extension PointCloud {
    
    func add(_ locationPoints: [LocationPoint]) {
        self.locationPoints.append(contentsOf: locationPoints)
        _invalidateLocationCalculationsCache()
    }
    
    func estimatedVirtualLocation(for real: CLLocation) -> simd_float2? {
        guard let centroids = locationCentroids(),
              let rotationMatrix = locationRotationMatrix()
        else { return nil }
        
        let centroidVirtual2 = simd_float2(centroids.virtual.x, centroids.virtual.z)
        let displacement = centroids.real.xzPlaneDisplacement(to: real)
        return centroidVirtual2 + (rotationMatrix * displacement)
    }
    
    @inline(__always)
    private func _estimatedRealLocation(
        for virtual2: simd_float2,
        centroids: (real: CLLocation, virtual: simd_float4),
        rotationMatrix: simd_float2x2) -> CLLocation {
        let centroidVirtual2 = simd_float2(centroids.virtual.x, centroids.virtual.z)
        let displacement = rotationMatrix.transpose * (virtual2 - centroidVirtual2)
        return centroids.real.movedBy(xzPlaneDisplacement: displacement)
    }
    
    func estimatedRealLocation(for virtual2: simd_float2) -> CLLocation? {
        guard let centroids = locationCentroids(),
              let rotationMatrix = locationRotationMatrix()
        else { return nil }
        return _estimatedRealLocation(for: virtual2, centroids: centroids, rotationMatrix: rotationMatrix)
    }
    
    func estimatedRealLocations(for virtual2Array: [simd_float2]) -> [CLLocation]? {
        guard let centroids = locationCentroids(),
              let rotationMatrix = locationRotationMatrix()
        else { return nil }
        
        var locations = [CLLocation]()
        for virtual2 in virtual2Array {
            let location = _estimatedRealLocation(for: virtual2, centroids: centroids, rotationMatrix: rotationMatrix)
            locations.append(location)
        }
        return locations
    }
    
    public func locationsForTransforms(_ transforms: [simd_float4x4]) -> [CLLocation] {
        let virtual2Array: [simd_float2] = transforms.map({ simd_float2($0[3,0], $0[3,2]) })
        return estimatedRealLocations(for: virtual2Array) ?? []
    }
    
    
    // MARK: Calculations
    
    /// Calculates real and virtual location centroids
    func locationCentroids() -> (real: CLLocation, virtual: simd_float4)? {
        if let cache = _locationCentroids { return cache }
        
        let initial: (real: CLLocation?, virtual: simd_float4) = (nil, simd_float4(0, 0, 0, 0))
        var weightSum: Double = 0
        
        let sum = locationPoints.reduce(into: initial) { result, locationPoint in
            let weight = loctionWeight(for: locationPoint.location)
            weightSum += weight
            
            let weightedLocation = locationPoint.location * weight
            let weightedPosition = locationPoint.transform.columns.3 * Float(weight)
            
            result.real = result.real != nil ? result.real! + weightedLocation : weightedLocation
            result.virtual = result.virtual + weightedPosition
        }
        
        let virtualSum = sum.virtual
        guard let realSum = sum.real else { return nil }
        
        let realFraction = 1.0 / weightSum
        let virtualFraction = 1.0 / sum.virtual.w
        
        // TODO: Look at numerical stability
        let real = realSum * realFraction
        let virtual = virtualSum * virtualFraction
        return (real, virtual)
    }
    
    /// Calculates rotation matrix that takes you from real to virtual coordinate spaces
    func locationRotationMatrix() -> simd_float2x2? {
        if let cache = _locationlRotationMatrix { return cache }
        
        guard let K = locationCrossCovarianceMatrix(),
              let (_, U, VT) = Matrix(K).svd()
        else { return nil }
        
        let R = (U * VT).simd2x2
        
        guard R.determinant >= 0 else { return (U * Matrix(diagonal: [1,-1]) * VT).simd2x2 }
        return R
    }
    
    /// Calculates the cross covariance matrix of virtual locations and real locations
    func locationCrossCovarianceMatrix() -> simd_float2x2? {
        if let cache = _locationCrossCovarianceMatrix { return cache }
        
        guard let centroids = locationCentroids() else { return nil }
        var weightSum = Float(0)
        let sum = locationPoints.reduce(into: simd_float2x2()) { result, locationPoint in
            let weight = Float(loctionWeight(for: locationPoint.location))
            weightSum += weight
            
            let r = centroids.real.xzPlaneDisplacement(to: locationPoint.location)
            let v = locationPoint.transform.columns.3 - centroids.virtual

            result += simd_float2x2([[v.x * r.x, v.z * r.x],
                                     [v.x * r.y, v.z * r.y]]) * weight
        }
        // TODO: Look at numerical stability
        return sum * (1.0 / weightSum)
    }
    
    /// Calculates location weight with inverse square of error
    func loctionWeight(for location: CLLocation) -> Double {
        guard location.horizontalAccuracy > 0 else { return 1e-4 }
        let square = location.horizontalAccuracy * location.horizontalAccuracy
        return 1 / square
    }
    
    private func _invalidateLocationCalculationsCache() {
        _locationCentroids = nil
        _locationlRotationMatrix = nil
        _locationCrossCovarianceMatrix = nil
    }
    
}
