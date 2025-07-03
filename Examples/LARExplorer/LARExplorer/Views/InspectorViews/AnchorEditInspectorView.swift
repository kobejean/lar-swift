//
//  AnchorEditInspectorView.swift
//  LARExplorer
//
//  Created by Jean Flaherty on 2025-07-03.
//

import SwiftUI

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
                    editingService.resetSelection()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .disabled(editingService.selectedAnchors.isEmpty)
            }
        }
        .font(.caption)
    }
}