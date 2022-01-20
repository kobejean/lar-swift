//
//  Interpolate.swift
//  
//
//  Created by Jean Flaherty on 6/4/21.
//

import Foundation
import CoreLocation

extension CLLocation {
    
    static func + (left: CLLocation, right: CLLocation) -> CLLocation {
        let addedCoordinate = CLLocationCoordinate2D(
            latitude: left.coordinate.latitude + right.coordinate.latitude,
            longitude: left.coordinate.longitude + right.coordinate.longitude
        )
        if #available(iOS 13.4, *) {
            return CLLocation(
                coordinate: addedCoordinate,
                altitude: left.altitude + right.altitude,
                horizontalAccuracy: left.horizontalAccuracy + right.horizontalAccuracy,
                verticalAccuracy: left.verticalAccuracy + right.verticalAccuracy,
                course: 0,
                courseAccuracy: -1,
                speed: left.speed + right.speed,
                speedAccuracy: left.speedAccuracy + right.speedAccuracy,
                timestamp: Date()
            )
        } else {
            return CLLocation(
                coordinate: addedCoordinate,
                altitude: left.altitude + right.altitude,
                horizontalAccuracy: left.horizontalAccuracy + right.horizontalAccuracy,
                verticalAccuracy: left.verticalAccuracy + right.verticalAccuracy,
                course: 0,
                speed: left.speed + right.speed,
                timestamp: Date()
            )
        }
    }
    
    static func * (left: CLLocation, right: Double) -> CLLocation {
        let addedCoordinate = CLLocationCoordinate2D(
            latitude: left.coordinate.latitude * right,
            longitude: left.coordinate.longitude * right
        )
        if #available(iOS 13.4, *) {
            return CLLocation(
                coordinate: addedCoordinate,
                altitude: left.altitude * right,
                horizontalAccuracy: left.horizontalAccuracy * right,
                verticalAccuracy: left.verticalAccuracy * right,
                course: 0,
                courseAccuracy: -1,
                speed: left.speed * right,
                speedAccuracy: left.speedAccuracy * right,
                timestamp: Date()
            )
        } else {
            return CLLocation(
                coordinate: addedCoordinate,
                altitude: left.altitude * right,
                horizontalAccuracy: left.horizontalAccuracy * right,
                verticalAccuracy: left.verticalAccuracy * right,
                course: 0,
                speed: left.speed * right,
                timestamp: Date()
            )
        }
    }
    
    func interpolate(with: CLLocation, alpha: Double) -> CLLocation {
        let interpolatedCoordinate = CLLocationCoordinate2D(
            latitude: self.coordinate.latitude.interpolate(with: with.coordinate.latitude, alpha: alpha),
            longitude: self.coordinate.longitude.interpolate(with: with.coordinate.longitude, alpha: alpha)
        )
        if #available(iOS 13.4, *) {
            return CLLocation(
                coordinate: interpolatedCoordinate,
                altitude: self.altitude.interpolate(with: with.altitude, alpha: alpha),
                horizontalAccuracy: self.horizontalAccuracy.interpolate(with: with.horizontalAccuracy, alpha: alpha),
                verticalAccuracy: self.verticalAccuracy.interpolate(with: with.verticalAccuracy, alpha: alpha),
                course: self.course.interpolate(with: with.course, alpha: alpha),
                courseAccuracy: self.courseAccuracy.interpolate(with: with.courseAccuracy, alpha: alpha),
                speed: self.speed.interpolate(with: with.speed, alpha: alpha),
                speedAccuracy: self.speedAccuracy.interpolate(with: with.speedAccuracy, alpha: alpha),
                timestamp: self.timestamp.interpolate(with: with.timestamp, alpha: alpha)
            )
        } else {
            return CLLocation(
                coordinate: interpolatedCoordinate,
                altitude: self.altitude.interpolate(with: with.altitude, alpha: alpha),
                horizontalAccuracy: self.horizontalAccuracy.interpolate(with: with.horizontalAccuracy, alpha: alpha),
                verticalAccuracy: self.verticalAccuracy.interpolate(with: with.verticalAccuracy, alpha: alpha),
                course: self.course.interpolate(with: with.course, alpha: alpha),
                speed: self.speed.interpolate(with: with.speed, alpha: alpha),
                timestamp: self.timestamp.interpolate(with: with.timestamp, alpha: alpha)
            )
        }
    }
}

extension Date {
    
    func interpolate(with: Self, alpha: Double) -> Self {
        let interval = with.timeIntervalSince(self) * alpha
        return self.addingTimeInterval(interval)
    }
    
}


extension FloatingPoint {
    
    func interpolate(with: Self, alpha: Self) -> Self {
        return (Self(1) - alpha) * self + alpha * with
    }
    
}

extension SIMD where Scalar: FloatingPoint {
    
    func interpolate(with: Self, alpha: Scalar) -> Self {
        return (Scalar(1) - alpha) * self + alpha * with
    }
    
}
