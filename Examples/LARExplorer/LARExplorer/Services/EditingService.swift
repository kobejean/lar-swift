//
//  EditingService.swift
//  LARExplorer
//
//  Created by Jean Flaherty on 2025-06-30.
//

import Foundation
import SceneKit
import LocalizeAR
import Combine

@MainActor
class EditingService: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedAnchors: Set<Int32> = []
    @Published var selectedEdges: Set<String> = []
    @Published var selectedTool: ExplorerTool = .explore
    @Published var isEditingMode = false
    
    // MARK: - Internal Properties
    private weak var navigationManager: LARNavigationCoordinator?
    private weak var mapService: MapService?
    @Published var edgeCreationSourceAnchor: Int32?
    
    // Position offset properties
    @Published var positionOffsetX: Float = 0.0 {
        didSet { updatePreviewPositions() }
    }
    @Published var positionOffsetY: Float = 0.0 {
        didSet { updatePreviewPositions() }
    }
    @Published var positionOffsetZ: Float = 0.0 {
        didSet { updatePreviewPositions() }
    }
    @Published var isPreviewingOffset: Bool = false
    
    // MARK: - Initialization
    init() {
        // Observe tool changes to update editing mode
        $selectedTool
            .map { $0 != .explore }
            .assign(to: &$isEditingMode)
        
        // Clear state when switching tools
        $selectedTool
            .sink { [weak self] newTool in
                self?.handleToolChange(to: newTool)
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func handleToolChange(to newTool: ExplorerTool) {
        // Clear selection and state when switching tools
        resetSelection()
        
        if newTool != .editEdges {
            cancelEdgeCreation()
        }
    }
    
    // MARK: - Configuration
    func configure(navigationManager: LARNavigationCoordinator, mapService: MapService) {
        self.navigationManager = navigationManager
        self.mapService = mapService
    }
    
    // MARK: - Anchor Editing
    func selectAnchor(id: Int32) {
        if selectedAnchors.contains(id) {
            selectedAnchors.remove(id)
        } else {
            selectedAnchors.insert(id)
        }
        updateAnchorVisualState(id)
        updatePreviewPositions()
    }
    
    func deleteSelectedAnchors() {
        guard let map = mapService?.mapData, !selectedAnchors.isEmpty else { return }
        
        resetSelectionVisuals()
        removeAnchorsFromMap(selectedAnchors, map: map)
        selectedAnchors.removeAll()
    }
    
    private func resetSelectionVisuals() {
        selectedAnchors.forEach { anchorId in
            navigationManager?.setAnchorSelection(id: anchorId, selected: false)
        }
    }
    
    private func removeAnchorsFromMap(_ anchorIds: Set<Int32>, map: LARMap) {
        print("🔵 EditingService: removeAnchorsFromMap called with IDs: \(anchorIds.sorted())")
        for anchorId in anchorIds {
            guard let anchor = map.anchors.first(where: { $0.id == anchorId }) else {
                print("🔵 WARNING: No anchor found in map with ID: \(anchorId)")
                continue
            }
            print("🔵 Found anchor with ID: \(anchor.id), calling map.removeAnchor()")
            map.removeAnchor(anchor)
        }
    }
    
    func resetSelection() {
        guard !selectedAnchors.isEmpty else { return }
        resetSelectionVisuals()
        selectedAnchors.removeAll()
        hidePreview()
    }
    
    func applyPositionOffset() {
        guard let map = mapService?.mapData, let navigationManager = navigationManager, !selectedAnchors.isEmpty else { return }
        
        let offset = simd_float3(positionOffsetX, positionOffsetY, positionOffsetZ)
        
        for anchorId in selectedAnchors {
            guard let anchor = map.anchors.first(where: { $0.id == anchorId }) else { continue }
            
            // Calculate new transform with offset
            let currentTransform = anchor.transform
            let currentPosition = simd_float3(Float(currentTransform.columns.3.x), Float(currentTransform.columns.3.y), Float(currentTransform.columns.3.z))
            let newPosition = currentPosition + offset
            
            // Convert simd_double4x4 to simd_float4x4 and update position
            let newTransform = convertTransform(from: currentTransform, withPosition: newPosition)
            
            // Update anchor in map
            map.updateAnchor(anchor, transform: newTransform)
            
            // Update visual representation
            navigationManager.updateNavigationPoint(anchor: anchor, transform: newTransform)
        }
        
        // Refresh guide nodes and map overlays to update connections
        navigationManager.refreshGuideNodes()
        navigationManager.updateMapOverlays()
        
        // Hide preview and reset offset values
        hidePreview()
        resetPositionOffset()
    }
    
    func resetPositionOffset() {
        positionOffsetX = 0.0
        positionOffsetY = 0.0
        positionOffsetZ = 0.0
        hidePreview()
    }
    
    func showPreview() {
        isPreviewingOffset = true
        updatePreviewPositions()
    }
    
    func hidePreview() {
        isPreviewingOffset = false
        navigationManager?.hidePreviewNodes()
    }
    
    private func updatePreviewPositions() {
        guard isPreviewingOffset, !selectedAnchors.isEmpty,
              let navigationManager = navigationManager else {
            return
        }
        
        let offset = simd_float3(positionOffsetX, positionOffsetY, positionOffsetZ)
        
        // Create preview positions for selected anchors
        var previewPositions: [(id: Int32, position: simd_float3)] = []
        
        for anchorId in selectedAnchors {
            guard let anchor = mapService?.mapData?.anchors.first(where: { $0.id == anchorId }) else { continue }
            
            let currentTransform = anchor.transform
            let currentPosition = simd_float3(
                Float(currentTransform.columns.3.x),
                Float(currentTransform.columns.3.y),
                Float(currentTransform.columns.3.z)
            )
            let previewPosition = currentPosition + offset
            
            previewPositions.append((id: anchorId, position: previewPosition))
        }
        
        // Update preview visualization
        navigationManager.showPreviewNodes(for: previewPositions)
    }
    
    // MARK: - Edge Editing
    
    func handleAnchorClickForEdgeCreation(_ anchorId: Int32) {
        guard selectedTool == .editEdges else { return }
        
        if let sourceId = edgeCreationSourceAnchor {
            // Second click - create edge
            if sourceId != anchorId {
                createEdge(from: sourceId, to: anchorId)
            }
            resetEdgeCreationState()
        } else {
            // First click - select source anchor
            setEdgeCreationSource(anchorId)
        }
    }
    
    private func setEdgeCreationSource(_ anchorId: Int32) {
        edgeCreationSourceAnchor = anchorId
        // Visual feedback for source selection
        navigationManager?.setAnchorSelection(id: anchorId, selected: true)
    }
    
    private func createEdge(from sourceId: Int32, to targetId: Int32) {
        guard let map = mapService?.mapData,
              let navigationManager = navigationManager else { return }
        
        // Add edge to the map (C++ layer)
        map.addEdge(from: sourceId, to: targetId)
        
        // Add visual edge to navigation manager
        navigationManager.addNavigationEdge(from: sourceId, to: targetId)
    }
    
    private func resetEdgeCreationState() {
        if let sourceId = edgeCreationSourceAnchor {
            navigationManager?.setAnchorSelection(id: sourceId, selected: false)
        }
        edgeCreationSourceAnchor = nil
    }
    
    func cancelEdgeCreation() {
        resetEdgeCreationState()
    }
    
    func deleteSelectedEdges() {
        // Edge deletion not yet implemented
        selectedEdges.removeAll()
    }
    
    // MARK: - Private Methods
    
    private func updateAnchorVisualState(_ anchorId: Int32) {
        let shouldSelect = selectedAnchors.contains(anchorId)
        navigationManager?.setAnchorSelection(id: anchorId, selected: shouldSelect)
    }
    
    // MARK: - Helper Methods
    
    private func convertTransform(from doubleTransform: simd_double4x4, withPosition position: simd_float3) -> simd_float4x4 {
        return simd_float4x4(
            simd_float4(Float(doubleTransform.columns.0.x), Float(doubleTransform.columns.0.y), Float(doubleTransform.columns.0.z), Float(doubleTransform.columns.0.w)),
            simd_float4(Float(doubleTransform.columns.1.x), Float(doubleTransform.columns.1.y), Float(doubleTransform.columns.1.z), Float(doubleTransform.columns.1.w)),
            simd_float4(Float(doubleTransform.columns.2.x), Float(doubleTransform.columns.2.y), Float(doubleTransform.columns.2.z), Float(doubleTransform.columns.2.w)),
            simd_float4(position.x, position.y, position.z, Float(doubleTransform.columns.3.w))
        )
    }
}
