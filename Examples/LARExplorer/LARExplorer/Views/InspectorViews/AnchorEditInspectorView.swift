//
//  AnchorEditInspectorView.swift
//  LARExplorer
//
//  Created by Jean Flaherty on 2025-07-03.
//

import SwiftUI

struct AnchorEditInspectorView: View {
    @ObservedObject var coordinator: AnchorEditCoordinator

    // Local state for offset sliders (binds to coordinator on change)
    @State private var offsetX: Float = 0
    @State private var offsetY: Float = 0
    @State private var offsetZ: Float = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Anchor Editing")
                .font(.subheadline)
                .foregroundColor(.secondary)

            // Selection info
            if coordinator.state.selectedAnchorIds.isEmpty {
                Text("Click on navigation anchors to select them")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                Text("\(coordinator.state.selectedAnchorIds.count) anchor(s) selected")
                    .font(.caption)
                    .fontWeight(.medium)

                // Selected anchors list
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(Array(coordinator.state.selectedAnchorIds).sorted(), id: \.self) { anchorId in
                            Text("• Anchor \(anchorId)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(maxHeight: 100)
            }

            // Position offset controls
            if !coordinator.state.selectedAnchorIds.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Position Offset (meters)")
                        .font(.caption)
                        .fontWeight(.medium)

                    HStack {
                        Text("X:")
                            .frame(width: 20, alignment: .trailing)
                        Slider(value: $offsetX, in: -10...10)
                            .onChange(of: offsetX) { _, newValue in
                                updateOffset()
                            }
                        TextField("X", value: $offsetX, format: .number.precision(.fractionLength(2)))
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 60)
                            .font(.caption)
                    }

                    HStack {
                        Text("Y:")
                            .frame(width: 20, alignment: .trailing)
                        Slider(value: $offsetY, in: -10...10)
                            .onChange(of: offsetY) { _, newValue in
                                updateOffset()
                            }
                        TextField("Y", value: $offsetY, format: .number.precision(.fractionLength(2)))
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 60)
                            .font(.caption)
                    }

                    HStack {
                        Text("Z:")
                            .frame(width: 20, alignment: .trailing)
                        Slider(value: $offsetZ, in: -10...10)
                            .onChange(of: offsetZ) { _, newValue in
                                updateOffset()
                            }
                        TextField("Z", value: $offsetZ, format: .number.precision(.fractionLength(2)))
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 60)
                            .font(.caption)
                    }
                }
                .padding(.vertical, 8)
            }

            // Preview toggle
            if coordinator.state.hasSelection && coordinator.state.hasOffset {
                Toggle("Show Preview", isOn: Binding(
                    get: { coordinator.state.isPreviewingOffset },
                    set: { newValue in
                        coordinator.dispatch(.setPreviewingOffset(newValue))
                    }
                ))
                .font(.caption)
                .toggleStyle(.switch)
                .controlSize(.small)
            }

            // Actions
            VStack(spacing: 8) {
                if !coordinator.state.selectedAnchorIds.isEmpty {
                    Button("Apply Position Offset") {
                        coordinator.dispatch(.applyOffset)
                        resetLocalOffset()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .disabled(!coordinator.state.hasOffset)

                    if coordinator.state.hasOffset {
                        Button("Reset Offset") {
                            resetLocalOffset()
                            coordinator.dispatch(.setOffset(.zero))
                            coordinator.dispatch(.setPreviewingOffset(false))
                        }
                        .buttonStyle(.plain)
                        .controlSize(.small)
                        .foregroundColor(.secondary)
                    }

                    Button("Delete Selected Anchors") {
                        coordinator.dispatch(.deleteSelected)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                }

                Button("Clear Selection") {
                    coordinator.dispatch(.clearSelection)
                    resetLocalOffset()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .disabled(coordinator.state.selectedAnchorIds.isEmpty)
            }
        }
        .font(.caption)
        .onAppear {
            syncLocalOffset()
        }
        .onChange(of: coordinator.state.positionOffset) { _, newOffset in
            // Sync local state when coordinator state changes
            if newOffset == .zero {
                resetLocalOffset()
            }
        }
    }

    // MARK: - Private Methods

    private func updateOffset() {
        let offset = SIMD3<Float>(offsetX, offsetY, offsetZ)
        coordinator.dispatch(.setOffset(offset))
    }

    private func resetLocalOffset() {
        offsetX = 0
        offsetY = 0
        offsetZ = 0
    }

    private func syncLocalOffset() {
        let offset = coordinator.state.positionOffset
        offsetX = offset.x
        offsetY = offset.y
        offsetZ = offset.z
    }
}
