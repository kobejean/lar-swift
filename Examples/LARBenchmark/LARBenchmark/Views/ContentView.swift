//
//  ContentView.swift
//  LARBenchmark
//
//  Main UI for the benchmark application
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BenchmarkViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("LAR Benchmark")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                    Text("GPU & Multithreaded Performance Testing")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)

                Divider()

                // Directory Selection
                VStack(alignment: .leading, spacing: 16) {
                    Text("Data Sources")
                        .font(.headline)

                    // Map directory
                    DirectorySelectionRow(
                        title: "Map Directory",
                        directory: viewModel.mapDirectory,
                        selectAction: viewModel.selectMapDirectory
                    )

                    // Frames directory
                    DirectorySelectionRow(
                        title: "Frames Directory",
                        directory: viewModel.framesDirectory,
                        selectAction: viewModel.selectFramesDirectory
                    )
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(8)

                // Configuration
                VStack(alignment: .leading, spacing: 16) {
                    Text("Configuration")
                        .font(.headline)

                    // Thread count
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Thread Count:")
                            Spacer()
                            Text("\(viewModel.threadCount)")
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                        Slider(value: Binding(
                            get: { Double(viewModel.threadCount) },
                            set: { viewModel.threadCount = Int($0) }
                        ), in: 1...16, step: 1)
                        .disabled(viewModel.isRunning)
                    }

                    // Stagger delay
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Stagger Delay:")
                            Spacer()
                            Text("\(viewModel.staggerDelayMs)ms")
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                        Slider(value: Binding(
                            get: { Double(viewModel.staggerDelayMs) },
                            set: { viewModel.staggerDelayMs = Int($0) }
                        ), in: 0...1000, step: 50)
                        .disabled(viewModel.isRunning)
                    }

                    // Frame limit
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Frame Limit:")
                            Spacer()
                            Text("\(viewModel.frameLimit)")
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                        Slider(value: Binding(
                            get: { Double(viewModel.frameLimit) },
                            set: { viewModel.frameLimit = Int($0) }
                        ), in: 10...2000, step: 10)
                        .disabled(viewModel.isRunning)
                    }
                }
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(8)

                // Status and Controls
                VStack(spacing: 12) {
                    // Status message
                    Text(viewModel.statusMessage)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    // Progress bar
                    if viewModel.isRunning {
                        VStack(spacing: 4) {
                            ProgressView(value: viewModel.progress)
                                .progressViewStyle(.linear)
                            Text("\(viewModel.processedFrames) / \(viewModel.totalFrames) frames")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    // Start/Stop button
                    Button(action: {
                        if viewModel.isRunning {
                            viewModel.stopBenchmark()
                        } else {
                            Task {
                                await viewModel.startBenchmark()
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: viewModel.isRunning ? "stop.circle.fill" : "play.circle.fill")
                            Text(viewModel.isRunning ? "Stop Benchmark" : "Start Benchmark")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!viewModel.canStartBenchmark && !viewModel.isRunning)
                    .controlSize(.large)
                }
                .padding()

                // Results
                if let results = viewModel.results {
                    BenchmarkResultsView(results: results)
                        .transition(.opacity.combined(with: .scale))
                }
            }
            .padding()
        }
        .frame(minWidth: 700, minHeight: 600)
    }
}

struct DirectorySelectionRow: View {
    let title: String
    let directory: URL?
    let selectAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)

            HStack {
                Text(directory?.lastPathComponent ?? "Not selected")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(directory == nil ? .secondary : .primary)
                    .lineLimit(1)
                    .truncationMode(.middle)

                Spacer()

                Button("Select...") {
                    selectAction()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }

            if let dir = directory {
                Text(dir.path)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
        }
    }
}

#Preview {
    ContentView()
        .frame(width: 800, height: 700)
}
