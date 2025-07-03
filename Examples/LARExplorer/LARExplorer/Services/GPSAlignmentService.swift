//
//  GPSAlignmentService.swift
//  LARExplorer
//
//  Created by Jean Flaherty on 2025-07-02.
//

import SwiftUI
import LocalizeAR
import simd

@MainActor
class GPSAlignmentService: ObservableObject {
    // MARK: - Published Properties
    @Published var translationX: Double = 0.0
    @Published var translationY: Double = 0.0
    @Published var rotation: Double = 0.0
    @Published var scaleFactor: Double = 1.0
    
    @Published var statusMessage: String?
    
    // MARK: - Private Properties
    private var mapData: LARMap?
    private var mapperData: LARMapper.Data?
    private var mapProcessor: LARMapProcessor?
    private var baseOrigin: simd_double4x4 = matrix_identity_double4x4
    
    // MARK: - Configuration
    func configure(with mapperData: LARMapper.Data) {
        self.mapperData = mapperData
        self.mapData = mapperData.map
        // Create map processor for rescaling operations
        self.mapProcessor = LARMapProcessor(mapperData: mapperData)
        // Store the current origin as our baseline
        baseOrigin = mapperData.map.origin
        resetAlignment()
        statusMessage = "GPS alignment ready - sliders show offset from base position"
    }
    
    // MARK: - Alignment Actions
    func resetAlignment() {
        translationX = 0.0
        translationY = 0.0
        rotation = 0.0
        scaleFactor = 1.0
        
        // Reset origin to base position
        if let mapData = mapData {
            mapData.updateOrigin(baseOrigin)
        }
        
        statusMessage = "Reset to base origin"
    }
    
    func performAutoAlignment() {
        guard let mapData = mapData else {
            statusMessage = "No map loaded"
            return
        }
        
        statusMessage = "Performing auto-alignment..."
        
        // TODO: Implement auto-alignment using GPS data
        // This would typically:
        // 1. Get current GPS coordinates
        // 2. Compare with map's GPS reference points
        // 3. Calculate optimal transform
        // 4. Apply the transform to the map origin
        
        // For now, simulate the operation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.statusMessage = "Auto-alignment completed"
            // Reset manual controls since auto-alignment was applied
            self.resetAlignment()
        }
    }
    
    func applyManualAlignment() {
        guard let mapData = mapData else {
            statusMessage = "No map loaded"
            return
        }
        
        statusMessage = "Applying manual alignment..."
        
        // Create transform from current values
        let transform = createTransformFromCurrentValues()
        
        // Apply GPS adjustment as absolute offset from base origin
        let newOrigin = simd_mul(baseOrigin, transform)
        mapData.updateOrigin(newOrigin)
        
        statusMessage = "Manual alignment applied"
    }
    
    func applyScale() {
        guard let mapProcessor = mapProcessor else {
            statusMessage = "No map processor available"
            return
        }
        
        guard scaleFactor > 0.0 else {
            statusMessage = "Invalid scale factor: \(scaleFactor)"
            return
        }
        
        statusMessage = "Applying scale factor: \(scaleFactor)..."
        
        // Apply rescaling using the map processor
        mapProcessor.rescale(scaleFactor)
        
        statusMessage = "Scale factor \(scaleFactor) applied successfully"
        print("🎯 Applied scale factor: \(scaleFactor)")
    }
    
    // MARK: - Private Helpers
    private func createTransformFromCurrentValues() -> simd_double4x4 {
        // Convert degrees to radians
        let ry = Double(rotation * .pi / 180)
        
        // Create rotation matrix around Y-axis (vertical axis for GPS heading)
        let rotY = simd_double4x4([
            [cos(ry), 0, sin(ry), 0],
            [0, 1, 0, 0],
            [-sin(ry), 0, cos(ry), 0],
            [0, 0, 0, 1]
        ])
        
        // Create translation matrix (translation in meters)
        // X = East/West, Y = Up/Down, Z = North/South
        var translation = matrix_identity_double4x4
        translation.columns.3 = simd_double4(translationX, 0, translationY, 1)
        
        // Combine translation and rotation
        return translation * rotY
    }
}
