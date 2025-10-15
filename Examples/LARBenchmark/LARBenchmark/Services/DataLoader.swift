//
//  DataLoader.swift
//  LARBenchmark
//
//  Loads map.json and frames with images from disk
//

import Foundation
import CoreGraphics
import ImageIO
import LocalizeAR

enum DataLoaderError: Error {
    case fileNotFound(String)
    case invalidJSON(String)
    case imageLoadFailed(String)
}

actor DataLoader {
    /// Load LARMap from map.json in specified directory
    func loadMap(from directory: URL) async throws -> LARMap {
        let mapPath = directory.appendingPathComponent("map.json")

        guard FileManager.default.fileExists(atPath: mapPath.path) else {
            throw DataLoaderError.fileNotFound("map.json not found at \(mapPath.path)")
        }

        let data = try Data(contentsOf: mapPath)
        let map = try LARMap(jsonData: data)

        print("✓ Loaded map from \(mapPath.path)")
        return map
    }

    /// Load frames and their images from frames.json and image files
    func loadFrames(from directory: URL, limit: Int = 400) async throws -> [FrameData] {
        let framesPath = directory.appendingPathComponent("frames.json")

        guard FileManager.default.fileExists(atPath: framesPath.path) else {
            throw DataLoaderError.fileNotFound("frames.json not found at \(framesPath.path)")
        }

        print("Loading frames from \(framesPath.path)...")

        let data = try Data(contentsOf: framesPath)
        let allFrames = try LARFrame.fromJSONArray(data: data)

        let framesToLoad = Array(allFrames.prefix(limit))
        print("Loading images for \(framesToLoad.count) frames...")

        var frameDataList: [FrameData] = []
        var loadedCount = 0

        for frame in framesToLoad {
            let imagePath = directory.appendingPathComponent(getImageFilename(for: frame))

            guard let cgImage = loadCGImage(from: imagePath) else {
                print("⚠️  Failed to load image for frame \(frame.id)")
                continue
            }

            frameDataList.append(FrameData(frame: frame, image: cgImage))
            loadedCount += 1

            if loadedCount % 50 == 0 {
                print("  Loaded \(loadedCount)/\(framesToLoad.count) images...")
            }
        }

        print("✓ Loaded \(frameDataList.count) frames with images")
        return frameDataList
    }

    /// Generate image filename from frame ID (matches C++ format: 00000001_image.jpeg)
    private func getImageFilename(for frame: LARFrame) -> String {
        let idString = String(format: "%08d", frame.id)
        return "\(idString)_image.jpeg"
    }

    /// Load CGImage from file path
    private func loadCGImage(from url: URL) -> CGImage? {
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            return nil
        }

        let options: [CFString: Any] = [
            kCGImageSourceShouldCache: false  // Don't cache to save memory
        ]

        return CGImageSourceCreateImageAtIndex(imageSource, 0, options as CFDictionary)
    }
}
