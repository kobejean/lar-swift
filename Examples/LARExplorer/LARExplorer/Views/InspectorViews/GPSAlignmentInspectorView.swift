//
//  GPSAlignmentInspectorView.swift
//  LARExplorer
//
//  Created by Jean Flaherty on 2025-07-03.
//

import SwiftUI

struct GPSAlignmentInspectorView: View {
    @ObservedObject var coordinator: GPSAlignmentCoordinator

    // Local state for two-way binding with sliders/text fields
    @State private var translationX: Double = 0.0
    @State private var translationY: Double = 0.0
    @State private var rotation: Double = 0.0
    @State private var scaleFactor: Double = 1.0

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
                    Slider(value: $translationX, in: -1000...1000)
                    TextField("East", value: $translationX, format: .number.precision(.fractionLength(1)))
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                        .font(.caption)
                }

                HStack {
                    Text("N:")
                        .frame(width: 20, alignment: .trailing)
                    Slider(value: $translationY, in: -1000...1000)
                    TextField("North", value: $translationY, format: .number.precision(.fractionLength(1)))
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
                    Slider(value: $rotation, in: -180...180)
                    TextField("Heading", value: $rotation, format: .number.precision(.fractionLength(1)))
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
                    Slider(value: $scaleFactor, in: 0.1...10.0)
                    TextField("Scale", value: $scaleFactor, format: .number.precision(.fractionLength(2)))
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                        .font(.caption)
                }
            }

            // Actions
            VStack(spacing: 8) {
                Button("Auto-Align from GPS") {
                    coordinator.dispatch(.performAutoAlignment)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)

                Button("Apply GPS Offset") {
                    coordinator.dispatch(.applyAlignment)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)

                Button("Apply Scale Factor") {
                    coordinator.dispatch(.applyScale)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }

            // Status
            if let status = coordinator.state.statusMessage {
                Text(status)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            }
        }
        .onAppear {
            syncFromCoordinator()
        }
        .onChange(of: coordinator.state) { _, _ in
            syncFromCoordinator()
        }
        .onChange(of: translationX) { _, newValue in
            if newValue != coordinator.state.translationX {
                coordinator.dispatch(.setTranslationX(newValue))
            }
        }
        .onChange(of: translationY) { _, newValue in
            if newValue != coordinator.state.translationY {
                coordinator.dispatch(.setTranslationY(newValue))
            }
        }
        .onChange(of: rotation) { _, newValue in
            if newValue != coordinator.state.rotation {
                coordinator.dispatch(.setRotation(newValue))
            }
        }
        .onChange(of: scaleFactor) { _, newValue in
            if newValue != coordinator.state.scaleFactor {
                coordinator.dispatch(.setScaleFactor(newValue))
            }
        }
    }

    private func syncFromCoordinator() {
        translationX = coordinator.state.translationX
        translationY = coordinator.state.translationY
        rotation = coordinator.state.rotation
        scaleFactor = coordinator.state.scaleFactor
    }
}
