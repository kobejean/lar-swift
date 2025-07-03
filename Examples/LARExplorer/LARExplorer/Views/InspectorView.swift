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
                AnchorEditInspectorView(editingService: editingService)
            case .editEdges:
                EdgeEditInspectorView(editingService: editingService)
            case .alignGPS:
                GPSAlignmentInspectorView(alignmentService: alignmentService)
            case .testRelocalization:
                RelocalizationInspectorView(localizationService: localizationService)
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
        case .editEdges:
            editingService.cancelEdgeCreation()
        default:
            break
        }
    }
}
