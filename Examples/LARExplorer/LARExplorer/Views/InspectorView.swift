//
//  InspectorView.swift
//  LARExplorer
//
//  Created by Claude Code on 2025-07-02.
//

import SwiftUI
import simd

struct InspectorView: View {
    @Binding var selectedTool: ExplorerTool
    @ObservedObject var alignmentService: GPSAlignmentService
    
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
            case .editNodes:
                NodeEditInspectorView()
            case .editEdges:
                EdgeEditInspectorView()
            case .alignGPS:
                GPSAlignmentInspectorView(alignmentService: alignmentService)
            case .testRelocalization:
                RelocalizationInspectorView()
            }
            
            Spacer()
        }
        .padding()
        .frame(minWidth: 250, maxWidth: 300)
        .background(.ultraThinMaterial)
    }
    
    private func resetCurrentTool() {
        switch selectedTool {
        case .alignGPS:
            alignmentService.resetAlignment()
        default:
            break
        }
    }
}

// MARK: - Tool-specific Inspector Views

struct ExploreInspectorView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Exploration Mode")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("• Navigate the 3D scene")
            Text("• Zoom and pan the map")
            Text("• View landmark data")
        }
        .font(.caption)
    }
}

struct NodeEditInspectorView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Node Editing")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Coming soon...")
                .foregroundColor(.secondary)
        }
        .font(.caption)
    }
}

struct EdgeEditInspectorView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Edge Editing")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Coming soon...")
                .foregroundColor(.secondary)
        }
        .font(.caption)
    }
}

struct RelocalizationInspectorView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Relocalization Testing")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Coming soon...")
                .foregroundColor(.secondary)
        }
        .font(.caption)
    }
}

struct GPSAlignmentInspectorView: View {
    @ObservedObject var alignmentService: GPSAlignmentService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("GPS Alignment")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Translation Controls
            VStack(alignment: .leading, spacing: 8) {
                Text("GPS Translation Offset (meters)")
                    .font(.caption)
                    .fontWeight(.medium)
                
                HStack {
                    Text("E:")
                        .frame(width: 20, alignment: .trailing)
                    Slider(value: $alignmentService.translationX, in: -1000...1000)
                    TextField("East", value: $alignmentService.translationX, format: .number.precision(.fractionLength(1)))
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                        .font(.caption)
                }
                
                HStack {
                    Text("N:")
                        .frame(width: 20, alignment: .trailing)
                    Slider(value: $alignmentService.translationY, in: -1000...1000)
                    TextField("North", value: $alignmentService.translationY, format: .number.precision(.fractionLength(1)))
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                        .font(.caption)
                }
            }
            
            // Rotation Controls
            VStack(alignment: .leading, spacing: 8) {
                Text("GPS Heading Offset (degrees)")
                    .font(.caption)
                    .fontWeight(.medium)
                
                HStack {
                    Text("Y:")
                        .frame(width: 20, alignment: .trailing)
                    Slider(value: $alignmentService.rotation, in: -180...180)
                    TextField("Heading", value: $alignmentService.rotation, format: .number.precision(.fractionLength(1)))
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                        .font(.caption)
                }
            }
            
            // Scale Controls
            VStack(alignment: .leading, spacing: 8) {
                Text("Scale Factor")
                    .font(.caption)
                    .fontWeight(.medium)
                
                HStack {
                    Text("×:")
                        .frame(width: 20, alignment: .trailing)
                    Slider(value: $alignmentService.scaleFactor, in: 0.1...10.0)
                    TextField("Scale", value: $alignmentService.scaleFactor, format: .number.precision(.fractionLength(2)))
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                        .font(.caption)
                }
            }
            
            // Actions
            VStack(spacing: 8) {
                Button("Auto-Align from GPS") {
                    alignmentService.performAutoAlignment()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                
                Button("Apply GPS Offset") {
                    alignmentService.applyManualAlignment()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                
                Button("Apply Scale Factor") {
                    alignmentService.applyScale()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
            
            // Status
            if let status = alignmentService.statusMessage {
                Text(status)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            }
        }
    }
}