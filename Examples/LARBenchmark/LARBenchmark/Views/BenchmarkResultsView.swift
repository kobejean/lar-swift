//
//  BenchmarkResultsView.swift
//  LARBenchmark
//
//  Displays benchmark results in a formatted table
//

import SwiftUI

struct BenchmarkResultsView: View {
    let results: BenchmarkResults

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Benchmark Results")
                .font(.title2)
                .fontWeight(.bold)

            Divider()

            // Results grid
            Grid(alignment: .leadingFirstTextBaseline, horizontalSpacing: 20, verticalSpacing: 8) {
                GridRow {
                    Text("Total Frames:")
                        .fontWeight(.medium)
                    Text("\(results.totalFrames)")
                }

                GridRow {
                    Text("Successful:")
                        .fontWeight(.medium)
                    HStack {
                        Text("\(results.successfulFrames)")
                        Text("(\(String(format: "%.1f", results.successRate))%)")
                            .foregroundColor(results.successRate > 80 ? .green : .orange)
                    }
                }

                GridRow {
                    Text("Total Time:")
                        .fontWeight(.medium)
                    Text("\(String(format: "%.2f", results.totalTime)) seconds")
                }

                GridRow {
                    Text("Avg Time/Frame:")
                        .fontWeight(.medium)
                    Text("\(String(format: "%.2f", results.averageTimePerFrame)) ms")
                }

                GridRow {
                    Text("Throughput:")
                        .fontWeight(.medium)
                    HStack {
                        Text("\(String(format: "%.2f", results.throughputFPS)) FPS")
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                }

                Divider()

                GridRow {
                    Text("Configuration:")
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    Text("\(results.threadCount) threads, \(results.staggerDelayMs)ms stagger")
                        .foregroundColor(.secondary)
                }
            }
            .font(.system(.body, design: .monospaced))

            // Copy to clipboard button
            HStack {
                Spacer()
                Button(action: copyResultsToClipboard) {
                    Label("Copy Results", systemImage: "doc.on.doc")
                }
                .buttonStyle(.borderless)
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }

    private func copyResultsToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(results.formattedSummary, forType: .string)
    }
}

#Preview {
    BenchmarkResultsView(
        results: BenchmarkResults(
            totalFrames: 100,
            successfulFrames: 95,
            totalTime: 12.5,
            threadCount: 8,
            staggerDelayMs: 300
        )
    )
    .frame(width: 400)
    .padding()
}
