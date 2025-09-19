//
//  LandmarksInspectorView.swift
//  LARExplorer
//
//  Created by Assistant on 2025-09-19.
//

import SwiftUI
import LocalizeAR

struct LandmarksInspectorView: View {
    @ObservedObject var landmarkInspectionService: LandmarkInspectionService

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Landmark Inspector")
                .font(.headline)
                .padding(.bottom, 8)

            if let landmark = landmarkInspectionService.selectedLandmark {
                landmarkDetailsView(landmark)
            } else {
                Text("Click on a landmark in the point cloud to inspect its details.")
                    .foregroundColor(.secondary)
                    .padding()
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    @ViewBuilder
    private func landmarkDetailsView(_ landmark: LARLandmark) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Basic info
            Group {
                labelValueRow("ID", "\(landmark.id)")
                labelValueRow("Position", String(format: "(%.2f, %.2f, %.2f)",
                                              landmark.position.x,
                                              landmark.position.y,
                                              landmark.position.z))
                labelValueRow("Sightings", "\(landmark.sightings)")
                labelValueRow("Matched", landmark.isMatched ? "Yes" : "No")
            }

            Divider()

            // Visibility bounds
            Text("Visibility Bounds")
                .font(.subheadline)
                .bold()

            Group {
                labelValueRow("Min", String(format: "(%.2f, %.2f)",
                                           landmark.boundsLower.x, landmark.boundsLower.y))
                labelValueRow("Max", String(format: "(%.2f, %.2f)",
                                           landmark.boundsUpper.x, landmark.boundsUpper.y))
                labelValueRow("Width", String(format: "%.2f m", landmark.boundsUpper.x - landmark.boundsLower.x))
                labelValueRow("Height", String(format: "%.2f m", landmark.boundsUpper.y - landmark.boundsLower.y))
            }

            Divider()

            // Actions
            HStack {
                Button("Clear Selection") {
                    landmarkInspectionService.clearSelection()
                }
                .buttonStyle(.bordered)

                Spacer()
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }

    @ViewBuilder
    private func labelValueRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label + ":")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .leading)

            Text(value)
                .font(.caption)

            Spacer()
        }
    }
}

#Preview {
    let service = LandmarkInspectionService()

    return LandmarksInspectorView(landmarkInspectionService: service)
        .frame(width: 300, height: 400)
}
