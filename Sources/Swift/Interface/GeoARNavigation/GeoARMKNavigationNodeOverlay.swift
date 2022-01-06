//
//  GeoARMKNavigationNodeOverlay.swift
//
//
//  Created by Jean Flaherty on 7/25/21.
//
import Foundation
import MapKit

public class GeoARMKNavigationNodeOverlay: MKCircle {
    
    public convenience init(coordinate: CLLocationCoordinate2D) {
        self.init(center: coordinate, radius: 0.2)
    }
    
}
