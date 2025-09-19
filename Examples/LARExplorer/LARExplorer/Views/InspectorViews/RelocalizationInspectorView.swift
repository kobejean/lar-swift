//
//  RelocalizationInspectorView.swift
//  LARExplorer
//
//  Created by Jean Flaherty on 2025-07-03.
//

import SwiftUI
import LocalizeAR

struct RelocalizationInspectorView: View {
    @ObservedObject var localizationService: TestLocalizationService
    @ObservedObject var mapViewModel: MapViewModel
    @State private var selectedFrame: LARFrame?
    @State private var currentPage = 0
    private let framesPerPage = 50
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Relocalization Testing")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Directory selection (full width)
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
                        .onChange(of: localizationService.frames.count) { _ in
                            currentPage = 0 // Reset to first page when frames change
                        }
                }
            }
            
            Divider()
            
            // Two-column layout for frame selection and results
            HStack(alignment: .top, spacing: 16) {
                // Left column: Frame selection
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Select Frame")
                            .font(.caption)
                            .fontWeight(.medium)

                        Spacer()

                        // Pagination controls
                        if localizationService.frames.count > framesPerPage {
                            HStack(spacing: 4) {
                                Button(action: { currentPage = max(0, currentPage - 1) }) {
                                    Image(systemName: "chevron.left")
                                }
                                .buttonStyle(.plain)
                                .disabled(currentPage == 0)

                                Text("\(currentPage + 1)/\(totalPages)")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .frame(minWidth: 30)

                                Button(action: { currentPage = min(totalPages - 1, currentPage + 1) }) {
                                    Image(systemName: "chevron.right")
                                }
                                .buttonStyle(.plain)
                                .disabled(currentPage >= totalPages - 1)
                            }
                        }
                    }

                    if !localizationService.frames.isEmpty {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
                                ForEach(paginatedFrames, id: \.frameId) { frame in
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
                        .frame(maxHeight: 300)
                        
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
                }
                .frame(minWidth: 180, maxWidth: 220)
                
                // Right column: Status and results
                VStack(alignment: .leading, spacing: 12) {
                    
                    // Processing indicator
                    if localizationService.isProcessing {
                        HStack {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .controlSize(.small)
                            Text("Processing...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Error display
                    if let error = localizationService.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(8)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    // Results
                    if let result = localizationService.localizationResult {
                        LocalizationResultView(result: result, usedCameraPose: localizationService.usedCameraPose)
                    }
                    
                    // Visualization controls
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Visualization")
                            .font(.caption)
                            .fontWeight(.medium)
                        
                        Toggle("Show Bounds Overlays", isOn: $mapViewModel.showBoundsOverlays)
                            .toggleStyle(.checkbox)
                            .controlSize(.small)
                    }
                    
                    Spacer()
                }
                .frame(minWidth: 200)
            }
        }
        .font(.caption)
    }

    private var totalPages: Int {
        let frameCount = localizationService.frames.count
        return (frameCount + framesPerPage - 1) / framesPerPage
    }

    private var paginatedFrames: ArraySlice<LARFrame> {
        let startIndex = currentPage * framesPerPage
        let endIndex = min(startIndex + framesPerPage, localizationService.frames.count)

        guard startIndex < localizationService.frames.count else {
            return ArraySlice<LARFrame>()
        }

        return localizationService.frames[startIndex..<endIndex]
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
                        .frame(width: 80, height: 80)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 80, height: 80)
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
                VStack(alignment: .leading) {
                    Text(result.success ? "Success" : "Failed")
                        .fontWeight(.medium)
                    if !result.success {
                        Text("(showing debug highlights)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                if result.success {
                    Text(String(format: "Position: (%.2f, %.2f, %.2f)", 
                         result.position.x, 
                         result.position.y, 
                         result.position.z))
                }
                
                HStack {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.gray)
                    Text("Query: \(result.spatialQueryLandmarkIds.count)")
                }
                .font(.caption2)
                
                HStack {
                    Image(systemName: "circle.fill")
						.foregroundColor(.orange)
                    Text("Matches: \(result.matchLandmarkIds.count)")
                }
                .font(.caption2)
                
                HStack {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.green)
                    Text("Inliers: \(result.inlierLandmarkIds.count)")
                }
                .font(.caption2)
                .fontWeight(result.success ? .medium : .regular)
                
                if result.gravityAngleDifference > 0 {
                    Text(String(format: "Gravity angle: %.3f°", result.gravityAngleDifference))
                }
                
                Text(String(format: "Processing time: %.3f s", result.processingTime))
            }
			.font(.caption2)
			.foregroundColor(.secondary)
        }
    }
}
