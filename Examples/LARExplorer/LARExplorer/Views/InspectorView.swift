//
//  InspectorView.swift
//  LARExplorer
//
//  Created by Claude Code on 2025-07-02.
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
        .frame(minWidth: 250, maxWidth: 300)
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

struct AnchorEditInspectorView: View {
    @ObservedObject var editingService: EditingService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Anchor Editing")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Selection info
            if editingService.selectedAnchors.isEmpty {
                Text("Click on navigation anchors to select them")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                Text("\(editingService.selectedAnchors.count) anchor(s) selected")
                    .font(.caption)
                    .fontWeight(.medium)
                
                // Selected anchors list
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(Array(editingService.selectedAnchors).sorted(), id: \.self) { anchorId in
                            Text("• Anchor \(anchorId)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(maxHeight: 100)
            }
            
            // Position offset controls
            if !editingService.selectedAnchors.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Position Offset (meters)")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    HStack {
                        Text("X:")
                            .frame(width: 20, alignment: .trailing)
                        Slider(value: $editingService.positionOffsetX, in: -10...10)
                        TextField("X", value: $editingService.positionOffsetX, format: .number.precision(.fractionLength(2)))
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 60)
                            .font(.caption)
                    }
                    
                    HStack {
                        Text("Y:")
                            .frame(width: 20, alignment: .trailing)
                        Slider(value: $editingService.positionOffsetY, in: -10...10)
                        TextField("Y", value: $editingService.positionOffsetY, format: .number.precision(.fractionLength(2)))
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 60)
                            .font(.caption)
                    }
                    
                    HStack {
                        Text("Z:")
                            .frame(width: 20, alignment: .trailing)
                        Slider(value: $editingService.positionOffsetZ, in: -10...10)
                        TextField("Z", value: $editingService.positionOffsetZ, format: .number.precision(.fractionLength(2)))
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 60)
                            .font(.caption)
                    }
                }
                .padding(.vertical, 8)
            }
            
            // Preview toggle
            if !editingService.selectedAnchors.isEmpty && 
               (editingService.positionOffsetX != 0 || editingService.positionOffsetY != 0 || editingService.positionOffsetZ != 0) {
                Toggle("Show Preview", isOn: Binding(
                    get: { editingService.isPreviewingOffset },
                    set: { newValue in
                        if newValue {
                            editingService.showPreview()
                        } else {
                            editingService.hidePreview()
                        }
                    }
                ))
                .font(.caption)
                .toggleStyle(.switch)
                .controlSize(.small)
            }
            
            // Actions
            VStack(spacing: 8) {
                if !editingService.selectedAnchors.isEmpty {
                    Button("Apply Position Offset") {
                        editingService.applyPositionOffset()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .disabled(editingService.positionOffsetX == 0 && editingService.positionOffsetY == 0 && editingService.positionOffsetZ == 0)
                    
                    if editingService.positionOffsetX != 0 || editingService.positionOffsetY != 0 || editingService.positionOffsetZ != 0 {
                        Button("Reset Offset") {
                            editingService.resetPositionOffset()
                        }
                        .buttonStyle(.plain)
                        .controlSize(.small)
                        .foregroundColor(.secondary)
                    }
                    
                    Button("Delete Selected Anchors") {
                        editingService.deleteSelectedAnchors()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                }
                
                Button("Clear Selection") {
                    editingService.clearSelection()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .disabled(editingService.selectedAnchors.isEmpty)
            }
        }
        .font(.caption)
    }
}

struct EdgeEditInspectorView: View {
    @ObservedObject var editingService: EditingService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Edge Creation")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Instructions
            VStack(alignment: .leading, spacing: 4) {
                Text("Instructions:")
                    .font(.caption)
                    .fontWeight(.medium)
                
                Text("1. Click first anchor (source)")
                Text("2. Click second anchor (target)")
                Text("3. Edge will be created automatically")
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            // Current state
            if let sourceId = editingService.edgeCreationSourceAnchor {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Source anchor selected:")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    Text("• Anchor \(sourceId)")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Text("Click target anchor to create edge")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(.blue.opacity(0.1))
                .cornerRadius(8)
            } else {
                Text("Click an anchor to start creating an edge")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 8)
            }
            
            // Actions
            VStack(spacing: 8) {
                if editingService.edgeCreationSourceAnchor != nil {
                    Button("Cancel Edge Creation") {
                        editingService.cancelEdgeCreation()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
            }
        }
        .font(.caption)
    }
}

struct RelocalizationInspectorView: View {
    @ObservedObject var localizationService: TestLocalizationService
    @State private var selectedFrame: LARFrame?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Relocalization Testing")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Directory selection
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Button("Select Directory") {
                        localizationService.selectDirectory()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    
                    if let dir = localizationService.selectedDirectory {
                        Text(dir.lastPathComponent)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                
                if !localizationService.frames.isEmpty {
                    Text("\(localizationService.frames.count) frames loaded")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            // Frame selection gallery
            if !localizationService.frames.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select Frame")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 8) {
                            ForEach(localizationService.frames.prefix(50), id: \.frameId) { frame in
                                FrameThumbnailView(
                                    frame: frame,
                                    isSelected: selectedFrame?.frameId == frame.frameId,
                                    image: localizationService.imageCache[Int(frame.frameId)]
                                ) {
                                    selectedFrame = frame
                                }
                                .onAppear {
                                    localizationService.loadImage(for: Int(frame.frameId))
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
                
                // Localize button
                if let frame = selectedFrame {
                    Button("Localize Frame \(frame.frameId)") {
                        localizationService.performLocalization(for: Int(frame.frameId))
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                    .disabled(localizationService.isProcessing)
                }
            }
            
            // Camera pose indicator
            if localizationService.hasSceneView {
                HStack {
                    Image(systemName: "camera.fill")
                        .foregroundColor(.blue)
                    Text("Using SceneView camera pose for spatial querying")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(4)
            }
            
            // Results
            if let result = localizationService.localizationResult {
                Divider()
                LocalizationResultView(result: result, usedCameraPose: localizationService.usedCameraPose)
            }
            
            // Error display
            if let error = localizationService.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
            // Processing indicator
            if localizationService.isProcessing {
                ProgressView()
                    .progressViewStyle(.linear)
                    .controlSize(.small)
            }
        }
        .font(.caption)
    }
}

struct FrameThumbnailView: View {
    let frame: LARFrame
    let isSelected: Bool
    let image: NSImage?
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 2) {
                if let image = image {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 60, height: 60)
                        .overlay(
                            ProgressView()
                                .progressViewStyle(.circular)
                                .controlSize(.small)
                        )
                }
                
                Text("Frame \(frame.frameId)")
                    .font(.caption2)
                    .lineLimit(1)
            }
            .padding(4)
            .background(isSelected ? Color.accentColor.opacity(0.3) : Color.clear)
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

struct LocalizationResultView: View {
    let result: TestLocalizationService.LocalizationResult
    let usedCameraPose: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Localization Result")
                .font(.caption)
                .fontWeight(.medium)
            
            HStack {
                Image(systemName: result.success ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(result.success ? .green : .red)
                Text(result.success ? "Success" : "Failed")
                    .fontWeight(.medium)
            }
            
            if result.success {
                VStack(alignment: .leading, spacing: 4) {
                    Text(String(format: "Position: (%.2f, %.2f, %.2f)", 
                         result.position.x, 
                         result.position.y, 
                         result.position.z))
                    
                    Text(String(format: "Difference: (%.2f, %.2f, %.2f)",
                         result.positionDifference.x,
                         result.positionDifference.y,
                         result.positionDifference.z))
                    
                    Text(String(format: "Processing time: %.3f s", result.processingTime))
                    
                    HStack {
                        Image(systemName: usedCameraPose ? "camera.fill" : "cube")
                            .foregroundColor(usedCameraPose ? .blue : .gray)
                        Text(usedCameraPose ? "Used camera pose" : "Used frame pose")
                            .foregroundColor(usedCameraPose ? .blue : .gray)
                    }
                    .font(.caption2)
                }
                .font(.caption2)
                .foregroundColor(.secondary)
            }
        }
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