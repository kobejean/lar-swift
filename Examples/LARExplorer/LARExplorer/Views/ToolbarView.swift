//
//  ToolbarView.swift
//  LARExplorer
//
//  Created by Claude Code on 2025-06-30.
//

import SwiftUI

enum ExplorerTool: String, CaseIterable {
    case explore = "Explore"
    case editNodes = "Edit Nodes"
    case editEdges = "Edit Edges"
    case alignGPS = "Align GPS"
    case testRelocalization = "Test Relocalization"
    
    var icon: String {
        switch self {
        case .explore: return "location"
        case .editNodes: return "circle.grid.cross"
        case .editEdges: return "line.diagonal"
        case .alignGPS: return "location.north.line"
        case .testRelocalization: return "camera.viewfinder"
        }
    }
}

struct ToolbarView: View {
    @Binding var selectedTool: ExplorerTool
    @Binding var isPointCloudVisible: Bool
    let onLoadMap: () -> Void
    
    var body: some View {
        HStack {
            // Tool selection
            Picker("Tool", selection: $selectedTool) {
                ForEach(ExplorerTool.allCases, id: \.self) { tool in
                    Label(tool.rawValue, systemImage: tool.icon)
                        .tag(tool)
                }
            }
            .pickerStyle(.segmented)
            
            Spacer()
            
            // Visibility controls
            Toggle(isOn: $isPointCloudVisible) {
                Image(systemName: "circle.grid.3x3")
            }
            .help("Toggle point cloud visibility")
            
            // Actions
            Button("Load Map", action: onLoadMap)
                .buttonStyle(.bordered)
        }
        .padding()
        .background(.ultraThinMaterial)
    }
}