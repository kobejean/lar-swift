//
//  EdgeEditInspectorView.swift
//  LARExplorer
//
//  Created by Jean Flaherty on 2025-07-03.
//

import SwiftUI

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