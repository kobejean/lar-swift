//
//  BenchmarkResults.swift
//  LARBenchmark
//
//  Container for benchmark statistics and timing data
//

import Foundation

struct BenchmarkResults {
    let totalFrames: Int
    let successfulFrames: Int
    let totalTime: TimeInterval  // seconds
    let threadCount: Int
    let staggerDelayMs: Int

    // Computed properties
    var successRate: Double {
        guard totalFrames > 0 else { return 0 }
        return Double(successfulFrames) / Double(totalFrames) * 100.0
    }

    var averageTimePerFrame: Double {
        guard totalFrames > 0 else { return 0 }
        return (totalTime * 1000.0) / Double(totalFrames)  // milliseconds
    }

    var throughputFPS: Double {
        guard totalTime > 0 else { return 0 }
        return Double(totalFrames) / totalTime
    }

    var formattedSummary: String {
        """
        === Benchmark Results ===
        Successfully localized: \(successfulFrames)/\(totalFrames) frames
        Success rate: \(String(format: "%.1f", successRate))%
        Total processing time: \(String(format: "%.2f", totalTime)) s
        Average time per frame: \(String(format: "%.2f", averageTimePerFrame)) ms
        Throughput: \(String(format: "%.2f", throughputFPS)) FPS
        Configuration: \(threadCount) threads (stagger: \(staggerDelayMs)ms)
        """
    }
}
