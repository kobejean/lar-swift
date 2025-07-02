//
//  ContentView.swift
//  LARExplorer
//
//  Created by Jean Flaherty on 2025/06/29.
//  Refactored by Claude Code on 2025-06-30.
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
    
    // MARK: - State
    @State private var selectedTool: ExplorerTool = .explore
    @State private var isPointCloudVisible = true
    
    // MARK: - View References (for navigation setup)
    @State private var mapView: MKMapView?
    @State private var mapNode: SCNNode?
    @State private var navigationManager: LARNavigationManager?
    
    var body: some View {
        VStack(spacing: AppConfiguration.UI.toolbarSpacing) {
            ToolbarView(
                selectedTool: $selectedTool,
                isPointCloudVisible: $isPointCloudVisible,
                onLoadMap: loadMap
            )
            
            // Main content area
            VStack(spacing: 0) {
                // SceneKit view on top
                SceneView(onSceneViewCreated: handleSceneReady)
                    .frame(maxHeight: .infinity)
                
                // Divider
                Divider()
                
                // Bottom section with MapKit and Inspector
                HStack(spacing: 0) {
                    // MapKit view on left
                    MapView(onMapViewCreated: handleMapReady)
                        .frame(maxWidth: .infinity)
                    
                    // Vertical divider
                    Divider()
                    
                    // Inspector panel on right
                    InspectorView(selectedTool: $selectedTool, alignmentService: alignmentService)
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
        .errorAlert(message: explorerViewModel.errorMessage) {
            explorerViewModel.clearError()
        }
    }
    
    // MARK: - Computed Properties
    private var defaultMapURL: URL {
        URL(fileURLWithPath: AppConfiguration.Map.defaultMapPath, isDirectory: true)
    }
    
    // MARK: - Event Handlers
    private func handleSceneReady(sceneView: SCNView, mapNode: SCNNode) {
        self.mapNode = mapNode
        MapConfigurationService.configureScene(sceneView: sceneView)
        
        if explorerViewModel.isMapLoaded {
            configureApplicationWithLoadedMap()
        }
    }
    
    private func handleMapReady(mapView: MKMapView) {
        self.mapView = mapView
        
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
        editingService.configure(mapNode: mapNode, map: mapData)
        alignmentService.configure(with: explorerViewModel.mapperData!)
        
        // Initialize navigation
        navigationManager = MapConfigurationService.createNavigationManager(
            with: mapData,
            mapView: mapView,
            mapNode: mapNode
        )
        
        // Load point cloud
        Task {
            do {
                try await MapConfigurationService.loadPointCloud(
                    from: mapData,
                    into: mapNode,
                    progressHandler: { progress in
                        print("Point cloud loading: \(Int(progress * 100))%")
                    }
                )
            } catch {
                explorerViewModel.errorMessage = "Failed to load point cloud: \(error.localizedDescription)"
            }
        }
    }
    
    private func togglePointCloudVisibility(_ isVisible: Bool) {
        guard let mapNode = mapNode else { return }
        MapConfigurationService.togglePointCloudVisibility(in: mapNode, isVisible: isVisible)
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
