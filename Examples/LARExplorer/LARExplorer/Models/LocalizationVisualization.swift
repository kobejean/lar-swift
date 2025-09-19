//
//  LocalizationVisualization.swift
//  LARExplorer
//
//  Created by Jean Flaherty on 2025-07-03.
//

import Foundation
import LocalizeAR
import simd

/// Models for localization visualization data
enum LocalizationVisualization {
    
    /// 3D Scene landmark highlights
    struct LandmarkHighlights: Equatable {
        let spatialQueryIds: [Int]
        let matchIds: [Int]
        let inlierIds: [Int]
        let landmarks: [LARLandmark]
        
        static func == (lhs: LandmarkHighlights, rhs: LandmarkHighlights) -> Bool {
            lhs.spatialQueryIds == rhs.spatialQueryIds &&
            lhs.matchIds == rhs.matchIds &&
            lhs.inlierIds == rhs.inlierIds
        }
    }
    
    /// Map overlay bounds
    struct LandmarkBounds: Equatable {
        let bounds: [(simd_double2, simd_double2)]
        
        static func == (lhs: LandmarkBounds, rhs: LandmarkBounds) -> Bool {
            lhs.bounds.count == rhs.bounds.count &&
            zip(lhs.bounds, rhs.bounds).allSatisfy { pair in
                simd_equal(pair.0.0, pair.1.0) && simd_equal(pair.0.1, pair.1.1)
            }
        }
    }
    
    /// Complete visualization state
    struct State {
        let highlights: LandmarkHighlights?
        let bounds: LandmarkBounds?
        
        static let empty = State(highlights: nil, bounds: nil)
        
        static func from(localizationResult: TestLocalizationService.LocalizationResult, landmarks: [LARLandmark]) -> State {
            let highlights = LandmarkHighlights(
                spatialQueryIds: localizationResult.spatialQueryLandmarkIds,
                matchIds: localizationResult.matchLandmarkIds,
                inlierIds: localizationResult.inlierLandmarkIds,
                landmarks: landmarks
            )

            let bounds = LandmarkBounds(bounds: localizationResult.inlierBounds)

            return State(highlights: highlights, bounds: bounds)
        }

        static func from(selectedLandmark: LARLandmark) -> State {
            // Create bounds from the selected landmark's spatial bounds
            let landmarkBounds = [(selectedLandmark.boundsLower, selectedLandmark.boundsUpper)]
            let bounds = LandmarkBounds(bounds: landmarkBounds)

            return State(highlights: nil, bounds: bounds)
        }
    }
}