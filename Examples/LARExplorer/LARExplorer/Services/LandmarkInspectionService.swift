//
//  LandmarkInspectionService.swift
//  LARExplorer
//
//  Created by Assistant on 2025-09-19.
//

import Foundation
import LocalizeAR
import Combine

class LandmarkInspectionService: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedLandmark: LARLandmark?

    // MARK: - Public Methods
    func selectLandmark(_ landmark: LARLandmark?) {
        selectedLandmark = landmark
    }

    func clearSelection() {
        selectedLandmark = nil
    }
}