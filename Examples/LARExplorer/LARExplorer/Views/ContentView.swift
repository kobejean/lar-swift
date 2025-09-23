//
//  ContentView.swift
//  LARExplorer
//
//  Created by Jean Flaherty on 2025/06/29.
//

import SwiftUI
import AppKit
import MapKit
import SceneKit
import LocalizeAR

struct ContentView: View {
    // MARK: - Services
    @StateObject private var mapService = MapService()
    @StateObject private var editingService = EditingService()
    @StateObject private var alignmentService = GPSAlignmentService()
    @StateObject private var localizationService = TestLocalizationService()
    @StateObject private var landmarkInspectionService = LandmarkInspectionService()
    @StateObject private var interactionManager: SceneInteractionManager
    @StateObject private var progressService = ProgressService()

    init() {
        // Create the interaction manager with all dependencies
        let editingService = EditingService()
        let landmarkInspectionService = LandmarkInspectionService()
        let mapService = MapService()

        _editingService = StateObject(wrappedValue: editingService)
        _landmarkInspectionService = StateObject(wrappedValue: landmarkInspectionService)
        _mapService = StateObject(wrappedValue: mapService)
        _interactionManager = StateObject(wrappedValue: SceneInteractionManager(
            editingService: editingService,
            landmarkInspectionService: landmarkInspectionService,
            mapService: mapService
        ))
    }
    
    // MARK: - State
    @State private var selectedTool: ExplorerTool = .explore
    @State private var isPointCloudVisible = true
    
    // MARK: - View References (for navigation setup)
    @State private var mapView: MKMapView?
    @State private var mapNode: SCNNode?
    @State private var navigationManager: LARNavigationManager?
    @State private var sceneViewModel: SceneViewModel?
    @StateObject private var mapViewModel = MapViewModel()
    
    var body: some View {
        VStack(spacing: AppConfiguration.UI.toolbarSpacing) {
            ToolbarView(
                selectedTool: $selectedTool,
                isPointCloudVisible: $isPointCloudVisible,
                onLoadMap: loadMap,
                onSaveMap: saveMap
            )
            
            // Main content area
            VStack(spacing: 0) {
                // SceneKit view on top
                SceneView(interactionManager: interactionManager, onSceneViewCreated: handleSceneReady)
                    .frame(maxHeight: .infinity)
                
                // Divider
                Divider()
                
                // Bottom section with MapKit and Inspector
                HStack(spacing: 0) {
                    // MapKit view on left
                    MapView(mapViewModel: mapViewModel, onMapViewCreated: handleMapReady)
                        .frame(maxWidth: .infinity)
                    
                    // Vertical divider
                    Divider()
                    
                    // Inspector panel on right
                    InspectorView(
                        selectedTool: $selectedTool,
                        alignmentService: alignmentService,
                        editingService: editingService,
                        localizationService: localizationService,
                        landmarkInspectionService: landmarkInspectionService,
                        mapViewModel: mapViewModel
                    )
                }
                .frame(height: AppConfiguration.UI.mapViewHeight)
            }
        }
        .task {
            // Initialize services
            progressService.configure(mapService: mapService, sceneViewModel: sceneViewModel)
			mapService.loadMap(from: defaultMapURL)
        }
        .onChange(of: mapService.mapLoadCounter) { _, _ in
            configureApplicationWithLoadedMap()
        }
        .onChange(of: selectedTool) { _, newTool in
            editingService.selectedTool = newTool
            interactionManager.selectedTool = newTool
        }
        .onChange(of: isPointCloudVisible) { _, isVisible in
            togglePointCloudVisibility(isVisible)
        }
        .onChange(of: localizationService.localizationResult) { _, result in
            updateVisualizationState(for: result)
        }
        .onChange(of: landmarkInspectionService.selectedLandmark) { _, selectedLandmark in
            updateLandmarkInspectionVisualization(for: selectedLandmark)
        }
        .onChange(of: sceneViewModel) { _, newSceneViewModel in
            progressService.configure(mapService: mapService, sceneViewModel: newSceneViewModel)
        }
        .errorAlert(message: mapService.errorMessage) {
            mapService.resetError()
        }
        .overlay(
            ProgressOverlay(progressService: progressService)
        )
    }
    
    // MARK: - Computed Properties
    private var defaultMapURL: URL {
        URL(fileURLWithPath: AppConfiguration.Map.defaultMapPath, isDirectory: true)
    }
    
    // MARK: - Event Handlers
    private func handleSceneReady(sceneView: SCNView, mapNode: SCNNode, sceneViewModel: SceneViewModel) {
        self.mapNode = mapNode
        self.sceneViewModel = sceneViewModel
        MapConfigurationService.configureScene(sceneView: sceneView)

        // Configure localization service with SceneView for camera pose access
        localizationService.configure(sceneView: sceneView)

        if mapService.isMapLoaded {
            configureApplicationWithLoadedMap()
        }
    }
    
    private func handleMapReady(mapView: MKMapView) {
        self.mapView = mapView
        mapViewModel.configure(mapView: mapView)
        
        if mapService.isMapLoaded {
            configureApplicationWithLoadedMap()
        }
    }
    
    private func configureApplicationWithLoadedMap() {
        guard let mapData = mapService.mapData,
              let mapView = mapView,
              let mapNode = mapNode else {
            return
        }

        // Cleanup
        mapNode.childNodes.forEach { $0.removeFromParentNode() }
        mapView.removeOverlays(mapView.overlays)

        // Clear navigation manager reference (will be recreated)
        navigationManager = nil

        // Configure all components using services
        MapConfigurationService.configureMapRegion(mapView: mapView, for: mapData)
        alignmentService.configure(with: mapService)

        // Initialize navigation
        navigationManager = MapConfigurationService.createNavigationManager(
            with: mapData,
            mapView: mapView,
            mapNode: mapNode
        )

        // Set map data and navigation manager
        mapViewModel.setMapData(mapData, navigationManager: navigationManager)

        // Configure editing service with navigation manager
        editingService.configure(navigationManager: navigationManager!, mapService: mapService)

        // Configure localization service
        localizationService.configure(with: mapData)

        // Load point cloud through SceneViewModel
        sceneViewModel?.loadPointCloud(from: mapData)
    }
    
    private func togglePointCloudVisibility(_ isVisible: Bool) {
        guard let mapNode = mapNode else { return }
        MapConfigurationService.togglePointCloudVisibility(in: mapNode, isVisible: isVisible)
    }
    
    private func updateVisualizationState(for result: TestLocalizationService.LocalizationResult?) {
        guard let result = result,
              let mapData = mapService.mapData else {
            // Clear visualizations when result is nil
            sceneViewModel?.updateVisualization(state: LocalizationVisualization.State.empty)
            mapViewModel.updateVisualization(state: LocalizationVisualization.State.empty)
            return
        }
        
        // Create visualization state from result
        let state = LocalizationVisualization.State.from(localizationResult: result, landmarks: mapData.landmarks)
        
        // Update both view models with the same state
        sceneViewModel?.updateVisualization(state: state)
        mapViewModel.updateVisualization(state: state)
    }

    private func updateLandmarkInspectionVisualization(for selectedLandmark: LARLandmark?) {
        if let landmark = selectedLandmark {
            // Show bounds for the selected landmark
            let state = LocalizationVisualization.State.from(selectedLandmark: landmark)
            mapViewModel.updateVisualization(state: state)
        } else {
            // Clear bounds when no landmark is selected
            mapViewModel.updateVisualization(state: LocalizationVisualization.State.empty)
        }
    }
    
    // MARK: - Action Methods
    private func loadMap() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.allowsMultipleSelection = false
        openPanel.title = "Select Map Directory"
        
        if openPanel.runModal() == .OK, let url = openPanel.url {
            Task {
                await mapService.loadMap(from: url)
            }
        }
    }
    
    private func saveMap() {
        guard mapService.mapProcessor != nil else {
            mapService.errorMessage = "No map processor available to save"
            return
        }
        
        let savePanel = NSOpenPanel()
        savePanel.canChooseDirectories = true
        savePanel.canChooseFiles = false
        savePanel.allowsMultipleSelection = false
        savePanel.canCreateDirectories = true
        savePanel.title = "Select Directory to Save Map"
        savePanel.prompt = "Save"
        
        if savePanel.runModal() == .OK, let url = savePanel.url {
            _ = mapService.saveMap(to: url.path)
            // Map saved successfully - could show success message in UI if needed
        }
    }
}

#Preview {
    ContentView()
}


// MARK: - Extensions
extension View {
    func errorAlert(message: String?, onDismiss: @escaping () -> Void) -> some View {
        self.alert("Error", isPresented: .constant(message != nil)) {
            Button("OK", action: onDismiss)
        } message: {
            Text(message ?? "")
        }
    }
}
