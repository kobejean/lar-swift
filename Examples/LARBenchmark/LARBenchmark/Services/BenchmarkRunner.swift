//
//  BenchmarkRunner.swift
//  LARBenchmark
//
//  Orchestrates multithreaded localization benchmark
//  Mirrors the behavior of lar_localize.cpp
//

import Foundation
import CoreGraphics
import LocalizeAR

/// Thread-safe atomic counter using os_unfair_lock
class AtomicCounter {
    private var _value: Int = 0
    private var lock = os_unfair_lock()

    init(_ initialValue: Int = 0) {
        _value = initialValue
    }

    func increment() -> Int {
        os_unfair_lock_lock(&lock)
        let current = _value
        _value += 1
        os_unfair_lock_unlock(&lock)
        return current
    }

    var value: Int {
        os_unfair_lock_lock(&lock)
        let current = _value
        os_unfair_lock_unlock(&lock)
        return current
    }
}

actor BenchmarkRunner {
    /// Run multithreaded localization benchmark
    func run(
        map: LARMap,
        frames: [FrameData],
        threadCount: Int,
        staggerMs: Int = 300,
        progressCallback: @escaping @Sendable (Int, Int) -> Void
    ) async -> BenchmarkResults {

        print("\n=== Starting Multithreaded Localization Benchmark ===")
        print("Frames: \(frames.count)")
        print("Threads: \(threadCount)")
        print("Stagger delay: \(staggerMs)ms")
        print()

        let startTime = Date()

        // Thread-safe counters (shared across all threads)
        let nextFrameIndex = AtomicCounter(0)
        let successCount = AtomicCounter(0)
        let processedCount = AtomicCounter(0)

        // Get image size from first frame
        let imageSize = CGSize(
            width: frames.first?.image.width ?? 1920,
            height: frames.first?.image.height ?? 1440
        )

        // Run workers in parallel with staggered starts
        await withTaskGroup(of: Void.self) { group in
            for threadId in 0..<threadCount {
                group.addTask {
                    // Stagger thread starts (except first thread)
                    if threadId > 0 {
                        try? await Task.sleep(nanoseconds: UInt64(staggerMs) * 1_000_000)
                    }

                    print("Thread \(threadId) started")

                    // Create thread-local worker with its own LARTracker instance
                    let worker = LocalizationWorker(
                        map: map,
                        imageSize: imageSize,
                        threadId: threadId
                    )

                    // Process frames from shared queue
                    while true {
                        let index = nextFrameIndex.increment()
                        guard index < frames.count else {
                            print("Thread \(threadId) completed")
                            break
                        }

                        let frameData = frames[index]

                        // Localize frame
                        let result = worker.localize(frameData: frameData)

                        if result.success {
                            _ = successCount.increment()
                        }

                        let processed = processedCount.increment()

                        // Progress callback on main thread
                        await MainActor.run {
                            progressCallback(processed, frames.count)
                        }

                        // Log progress
                        let status = result.success ? "✓ SUCCESS" : "✗ FAILED"
                        print("Thread \(threadId) - Frame \(frameData.frame.id) [\(processed)/\(frames.count)] \(status)")
                    }
                }
            }
        }

        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)

        let results = BenchmarkResults(
            totalFrames: frames.count,
            successfulFrames: successCount.value,
            totalTime: duration,
            threadCount: threadCount,
            staggerDelayMs: staggerMs
        )

        print("\n\(results.formattedSummary)")

        return results
    }
}
