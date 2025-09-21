//
//  ProgressPopupView.swift
//  LARExplorer
//
//  Created by Jean Flaherty on 2025-09-20.
//

import SwiftUI

// MARK: - ProgressOverlay
struct ProgressOverlay: View {
    @ObservedObject var progressService: ProgressService

    var body: some View {
        Group {
            if progressService.currentProgress.isLoading {
                ProgressPopupView(
                    title: progressService.currentProgress.title,
                    progress: progressService.currentProgress.progress,
                    isVisible: true
                )
            }
        }
    }
}

// MARK: - ProgressPopupView
struct ProgressPopupView: View {
    let title: String
    let progress: Double
    let isVisible: Bool

    var body: some View {
        Group {
            if isVisible {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        VStack(spacing: 16) {
                            Text(title)
                                .font(.headline)
                                .foregroundColor(.primary)

                            ProgressView(value: progress, total: 1.0)
                                .progressViewStyle(LinearProgressViewStyle())
                                .frame(width: 200)

                            Text("\(Int(progress * 100))%")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(24)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 8)
                    )
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: isVisible)
            }
        }
    }
}

#Preview {
    ProgressPopupView(title: "Loading Point Cloud", progress: 0.65, isVisible: true)
        .padding()
}