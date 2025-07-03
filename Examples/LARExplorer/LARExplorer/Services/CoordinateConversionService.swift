//
//  CoordinateConversionService.swift
//  LARExplorer
//
//  Created by Jean Flaherty on 2025-07-03.
//

import Foundation
import LocalizeAR
import CoreLocation
import simd

/// Service for converting between map coordinates and GPS coordinates
struct CoordinateConversionService {
    
    /// Converts map space coordinates to GPS coordinates
    /// - Parameters:
    ///   - mapPoint: Point in map space (XZ plane coordinates)
    ///   - map: The LARMap instance for coordinate conversion
    /// - Returns: GPS coordinate, or nil if map origin not ready
    static func mapToGPS(_ mapPoint: simd_double3, using map: LARMap) -> CLLocationCoordinate2D? {
        guard map.originReady else { return nil }
        return map.location(from: mapPoint).coordinate
    }
    
    /// Calculates bounding box from landmarks in GPS coordinates
    /// - Parameters:
    ///   - landmarks: Array of landmarks to calculate bounds for
    ///   - map: The LARMap instance for coordinate conversion
    /// - Returns: Tuple of (southWest, northEast) coordinates, or nil if conversion fails
    static func landmarkBounds(for landmarks: [LARLandmark], using map: LARMap) -> (CLLocationCoordinate2D, CLLocationCoordinate2D)? {
        guard map.originReady, !landmarks.isEmpty else { return nil }
        
        // Calculate bounding box from landmarks in map space
        var minX = Double.infinity
        var maxX = -Double.infinity
        var minZ = Double.infinity
        var maxZ = -Double.infinity
        
        for landmark in landmarks {
            let pos = landmark.position
            minX = min(minX, pos.x)
            maxX = max(maxX, pos.x)
            minZ = min(minZ, pos.z)
            maxZ = max(maxZ, pos.z)
        }
        
        // Convert bounds to GPS coordinates
        guard let southWest = mapToGPS(simd_double3(minX, 0, minZ), using: map),
              let northEast = mapToGPS(simd_double3(maxX, 0, maxZ), using: map) else {
            return nil
        }
        
        return (southWest, northEast)
    }
    
    /// Creates polygon coordinates for a rectangular bounds in GPS space
    /// - Parameters:
    ///   - lower: Lower bounds (min X, min Z) in map space
    ///   - upper: Upper bounds (max X, max Z) in map space
    ///   - map: The LARMap instance for coordinate conversion
    /// - Returns: Array of GPS coordinates for the polygon corners, or empty array if conversion fails
    static func boundsToPolygon(lower: simd_double2, upper: simd_double2, using map: LARMap) -> [CLLocationCoordinate2D] {
        guard map.originReady else { return [] }
        
        let corners = [
            simd_double3(lower.x, 0, lower.y), // SW
            simd_double3(upper.x, 0, lower.y), // SE
            simd_double3(upper.x, 0, upper.y), // NE
            simd_double3(lower.x, 0, upper.y)  // NW
        ]
        
        return corners.compactMap { corner in
            mapToGPS(corner, using: map)
        }
    }
}
