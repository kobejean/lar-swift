//
//  InspectorView.swift
//  LARExplorer
//
//  Created by Jean Flaherty on 2025-07-02.
//

import SwiftUI
import simd
import LocalizeAR

struct InspectorView: View {
    @Binding var selectedTool: ExplorerTool
    @ObservedObject var alignmentService: GPSAlignmentService
    @ObservedObject var editingService: EditingService
    @ObservedObject var localizationService: TestLocalizationService
    @ObservedObject var landmarkInspectionService: LandmarkInspectionService
    @ObservedObject var mapViewModel: MapViewModel
    // New architecture coordinator
    @ObservedObject var anchorEditCoordinator: AnchorEditCoordinator

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text("Inspector")
                    .font(.headline)
                Spacer()
                Button("Reset") {
                    resetCurrentTool()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }

            Divider()

            // Tool-specific content
            switch selectedTool {
            case .explore:
                ExploreInspectorView()
            case .editAnchors:
                // Use new coordinator-based inspector
                AnchorEditInspectorView(coordinator: anchorEditCoordinator)
            case .editEdges:
                EdgeEditInspectorView(editingService: editingService)
            case .alignGPS:
                GPSAlignmentInspectorView(alignmentService: alignmentService)
            case .testRelocalization:
                RelocalizationInspectorView(localizationService: localizationService, mapViewModel: mapViewModel)
            case .inspectLandmarks:
                LandmarksInspectorView(landmarkInspectionService: landmarkInspectionService)
            }

            Spacer()
        }
        .padding()
        .frame(minWidth: 500, maxWidth: 600)
        .background(.ultraThinMaterial)
    }

    private func resetCurrentTool() {
        switch selectedTool {
        case .alignGPS:
            alignmentService.resetAlignment()
        case .editAnchors:
            // Use coordinator to clear selection
            anchorEditCoordinator.dispatch(.clearSelection)
        case .editEdges:
            editingService.cancelEdgeCreation()
        default:
            break
        }
    }
}
