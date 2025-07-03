//
//  ExploreInspectorView.swift
//  LARExplorer
//
//  Created by Jean Flaherty on 2025-07-03.
//

import SwiftUI

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