//
//  GeoARMKNavigationGuideNodeOverlay.swift
//
//
//  Created by Jean Flaherty on 7/25/21.
//
import Foundation
import MapKit

public class GeoARMKNavigationGuideNodeOverlay: MKCircle {
    
    public convenience init(coordinate: CLLocationCoordinate2D) {
        self.init(center: coordinate, radius: 0.05)
    }
    
}
//
//class MKNavigationGuideOverlay: MKPolyline {
//    
//    convenience init?(coordinates: [CLLocationCoordinate2D]) {
//        let pointer = coordinates.withUnsafeBufferPointer { buffer in buffer.baseAddress }
//        guard let pointer = pointer else { return nil }
//        self.init(coordinates: pointer, count: coordinates.count)
//    }
//    
//}
