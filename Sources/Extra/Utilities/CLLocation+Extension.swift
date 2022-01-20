//
//  CLLocation+Extension.swift
//  
//
//  Created by Jean Flaherty on 6/14/21.
//

import Foundation
import ARKit
import CoreLocation
import MapKit

extension CLLocation {
    
    func xzPlaneDisplacement(to destination: CLLocation) -> simd_float2 {
        let intermediate = CLLocation(latitude: self.coordinate.latitude, longitude: destination.coordinate.longitude)
        let absZ = destination.distance(from: intermediate)
        let absX = intermediate.distance(from: self)
        let z = destination.coordinate.latitude < self.coordinate.latitude ? absZ : -absZ
        let x = destination.coordinate.longitude > self.coordinate.longitude ? absX : -absX
        return [Float(x),Float(z)]
    }
    
    func movedBy(xzPlaneDisplacement: simd_float2) -> CLLocation {
        let latitudinalMeters = Double(-xzPlaneDisplacement.y)
        let longitudinalMeters = Double(xzPlaneDisplacement.x)
        return movedBy(latitudinalMeters: latitudinalMeters, longitudinalMeters: longitudinalMeters)
    }
    
    func movedBy(latitudinalMeters: CLLocationDistance, longitudinalMeters: CLLocationDistance) -> CLLocation {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: abs(latitudinalMeters), longitudinalMeters: abs(longitudinalMeters))

        let latitudeDelta = region.span.latitudeDelta
        let longitudeDelta = region.span.longitudeDelta

        let latitudialSign = CLLocationDistance(latitudinalMeters.sign == .minus ? -1 : 1)
        let longitudialSign = CLLocationDistance(longitudinalMeters.sign == .minus ? -1 : 1)

        let newLatitude = coordinate.latitude + latitudialSign * latitudeDelta
        let newLongitude = coordinate.longitude + longitudialSign * longitudeDelta

        let newCoordinate = CLLocationCoordinate2D(latitude: newLatitude, longitude: newLongitude)

        let newLocation = CLLocation(coordinate: newCoordinate, altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy, course: course, speed: speed, timestamp: Date())

        return newLocation
    }
}
