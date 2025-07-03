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
    // MARK: - View Models
    @StateObject private var explorerViewModel = LARExplorerViewModel()
    @StateObject private var editingService = EditingService()
    @StateObject private var alignmentService = GPSAlignmentService()
    @StateObject private var localizationService = TestLocalizationService()
    
    // MARK: - State
    @State private var selectedTool: ExplorerTool = .explore
    @State private var isPointCloudVisible = true
    
    // MARK: - View References (for navigation setup)
    @State private var mapView: MKMapView?
    @State private var mapNode: SCNNode?
    @State private var navigationManager: LARNavigationManager?
    @State private var sceneViewRef: SceneView?
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
                SceneView(editingService: editingService, onSceneViewCreated: handleSceneReady)
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
                        localizationService: localizationService
                    )
                }
                .frame(height: AppConfiguration.UI.mapViewHeight)
            }
        }
        .task {
            await explorerViewModel.loadMap(from: defaultMapURL)
        }
        .onChange(of: explorerViewModel.isMapLoaded) { _, _ in
            configureApplicationWithLoadedMap()
        }
        .onChange(of: selectedTool) { _, newTool in
            editingService.selectedTool = newTool
        }
        .onChange(of: isPointCloudVisible) { _, isVisible in
            togglePointCloudVisibility(isVisible)
        }
        .onChange(of: localizationService.localizationResult) { _, result in
            updateVisualizationState(for: result)
        }
        .errorAlert(message: explorerViewModel.errorMessage) {
            explorerViewModel.resetError()
        }
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
        
        if explorerViewModel.isMapLoaded {
            configureApplicationWithLoadedMap()
        }
    }
    
    private func handleMapReady(mapView: MKMapView) {
        self.mapView = mapView
        mapViewModel.configure(mapView: mapView)
        
        if explorerViewModel.isMapLoaded {
            configureApplicationWithLoadedMap()
        }
    }
    
    private func configureApplicationWithLoadedMap() {
        guard let mapData = explorerViewModel.mapData,
              let mapView = mapView,
              let mapNode = mapNode else { return }
        
        // Configure all components using services
        MapConfigurationService.configureMapRegion(mapView: mapView, for: mapData)
        alignmentService.configure(with: explorerViewModel.mapperData!)
        
        // Initialize navigation
        navigationManager = MapConfigurationService.createNavigationManager(
            with: mapData,
            mapView: mapView,
            mapNode: mapNode
        )
        
        // Set map data and navigation manager
        mapViewModel.setMapData(mapData, navigationManager: navigationManager)
        
        // Configure editing service with navigation manager
        editingService.configure(navigationManager: navigationManager!, map: mapData)
        
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
              let mapData = explorerViewModel.mapData else {
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
    
    // MARK: - Action Methods
    private func loadMap() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.allowsMultipleSelection = false
        openPanel.title = "Select Map Directory"
        
        if openPanel.runModal() == .OK, let url = openPanel.url {
            Task {
                await explorerViewModel.loadMap(from: url)
            }
        }
    }
    
    private func saveMap() {
        guard let mapperData = explorerViewModel.mapperData else {
            explorerViewModel.errorMessage = "No map data available to save"
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
            let mapProcessor = LARMapProcessor(mapperData: mapperData)
            mapProcessor.saveMap(url.path)
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
