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
    // New architecture coordinators
    @ObservedObject var anchorEditCoordinator: AnchorEditCoordinator
    @ObservedObject var edgeEditCoordinator: EdgeEditCoordinator
    @ObservedObject var gpsAlignmentCoordinator: GPSAlignmentCoordinator
    @ObservedObject var relocalizationCoordinator: RelocalizationCoordinator
    @ObservedObject var landmarksCoordinator: LandmarksCoordinator

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
                EdgeEditInspectorView(coordinator: edgeEditCoordinator)
            case .alignGPS:
                GPSAlignmentInspectorView(coordinator: gpsAlignmentCoordinator)
            case .testRelocalization:
                RelocalizationInspectorView(
                    coordinator: relocalizationCoordinator,
                    localizationService: localizationService,
                    mapViewModel: mapViewModel
                )
            case .inspectLandmarks:
                LandmarksInspectorView(
                    coordinator: landmarksCoordinator,
                    landmarkInspectionService: landmarkInspectionService
                )
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
            gpsAlignmentCoordinator.dispatch(.reset)
        case .editAnchors:
            // Use coordinator to clear selection
            anchorEditCoordinator.dispatch(.clearSelection)
        case .editEdges:
            edgeEditCoordinator.dispatch(.cancelEdgeCreation)
        default:
            break
        }
    }
}
