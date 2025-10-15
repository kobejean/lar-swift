//
//  BenchmarkViewModel.swift
//  LARBenchmark
//
//  Manages benchmark state, file selection, and orchestrates data loading and benchmark execution
//

import Foundation
import SwiftUI
import AppKit

@MainActor
class BenchmarkViewModel: ObservableObject {
    // File selection
    @Published var mapDirectory: URL?
    @Published var framesDirectory: URL?

    // Configuration
    @Published var threadCount: Int = 8
    @Published var staggerDelayMs: Int = 300
    @Published var frameLimit: Int = 400

    // State
    @Published var isRunning: Bool = false
    @Published var progress: Double = 0
    @Published var processedFrames: Int = 0
    @Published var totalFrames: Int = 0
    @Published var statusMessage: String = "Ready"

    // Results
    @Published var results: BenchmarkResults?

    var canStartBenchmark: Bool {
        mapDirectory != nil && framesDirectory != nil && !isRunning
    }

    init() {
        setDefaultDirectories()
    }

    /// Set default directories to ./output/aizu-park-map and ./input/aizu-park-4-ext
    func setDefaultDirectories() {
        let fileManager = FileManager.default
        let currentDir = fileManager.currentDirectoryPath

        // Try to set default map directory
        let defaultMapPath = "\(currentDir)/output/aizu-park-map"
        if fileManager.fileExists(atPath: defaultMapPath) {
            mapDirectory = URL(fileURLWithPath: defaultMapPath)
            print("✓ Default map directory: \(defaultMapPath)")
        } else {
            print("⚠️  Default map directory not found: \(defaultMapPath)")
        }

        // Try to set default frames directory
        let defaultFramesPath = "\(currentDir)/input/aizu-park-4-ext"
        if fileManager.fileExists(atPath: defaultFramesPath) {
            framesDirectory = URL(fileURLWithPath: defaultFramesPath)
            print("✓ Default frames directory: \(defaultFramesPath)")
        } else {
            print("⚠️  Default frames directory not found: \(defaultFramesPath)")
        }
    }

    /// Open file picker for map directory
    func selectMapDirectory() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.message = "Select directory containing map.json"
        panel.directoryURL = mapDirectory

        if panel.runModal() == .OK {
            mapDirectory = panel.url
            print("Selected map directory: \(panel.url?.path ?? "nil")")
        }
    }

    /// Open file picker for frames directory
    func selectFramesDirectory() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.message = "Select directory containing frames.json and images"
        panel.directoryURL = framesDirectory

        if panel.runModal() == .OK {
            framesDirectory = panel.url
            print("Selected frames directory: \(panel.url?.path ?? "nil")")
        }
    }

    /// Start the benchmark
    func startBenchmark() async {
        guard let mapDir = mapDirectory,
              let framesDir = framesDirectory else {
            statusMessage = "Error: Directories not selected"
            return
        }

        isRunning = true
        progress = 0
        processedFrames = 0
        totalFrames = 0
        results = nil
        statusMessage = "Loading data..."

        do {
            // Load map
            statusMessage = "Loading map..."
            let loader = DataLoader()
            let map = try await loader.loadMap(from: mapDir)

            // Load frames
            statusMessage = "Loading frames and images..."
            let frames = try await loader.loadFrames(from: framesDir, limit: frameLimit)
            totalFrames = frames.count

            if frames.isEmpty {
                statusMessage = "Error: No frames loaded"
                isRunning = false
                return
            }

            // Run benchmark
            statusMessage = "Running benchmark..."
            let runner = BenchmarkRunner()
            let benchmarkResults = await runner.run(
                map: map,
                frames: frames,
                threadCount: threadCount,
                staggerMs: staggerDelayMs,
                progressCallback: { [weak self] processed, total in
                    guard let self = self else { return }
                    Task { @MainActor in
                        self.processedFrames = processed
                        self.totalFrames = total
                        self.progress = Double(processed) / Double(total)
                    }
                }
            )

            results = benchmarkResults
            statusMessage = "Benchmark completed!"

        } catch {
            statusMessage = "Error: \(error.localizedDescription)"
            print("Benchmark error: \(error)")
        }

        isRunning = false
    }

    /// Stop the benchmark (not implemented yet - would need cancellation support)
    func stopBenchmark() {
        // TODO: Implement cancellation
        isRunning = false
        statusMessage = "Benchmark stopped (manual stop not fully implemented)"
    }
}
