//
//  PointCloudRenderer.swift
//  LARExplorer
//
//  Created by Claude Code on 2025-06-30.
//

import SceneKit
import LocalizeAR
import AppKit

@MainActor
class PointCloudRenderer {
    // MARK: - Template Management
    private static var templateNodes: [String: SCNNode] = [:]
    
    // MARK: - Public Methods
    func loadPointCloud(
        from map: LARMap,
        into mapNode: SCNNode,
        progressHandler: @escaping (Double) -> Void
    ) async {
        // Remove existing point cloud
        await removeExistingPointClouds(from: mapNode)
        
        // Create point cloud on background queue
        let pointCloudNode = await createPointCloudNode(from: map, progressHandler: progressHandler)
        
        // Add to scene on main queue
        mapNode.addChildNode(pointCloudNode)
        print("Point cloud loaded successfully!")
    }
    
    // MARK: - Private Methods
    private func removeExistingPointClouds(from mapNode: SCNNode) async {
        mapNode.childNode(withName: AppConfiguration.PointCloud.containerNodeName, recursively: false)?.removeFromParentNode()
        mapNode.childNode(withName: "LODLandmarkPointCloud", recursively: false)?.removeFromParentNode()
    }
    
    private func createPointCloudNode(
        from map: LARMap,
        progressHandler: @escaping (Double) -> Void
    ) async -> SCNNode {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let pointCloudNode = SCNNode()
                pointCloudNode.name = AppConfiguration.PointCloud.containerNodeName
                
                // Create template nodes if needed
                self.createTemplateNodes()
                
                let landmarks = map.landmarks
                print("Creating point cloud with \(landmarks.count) landmarks")
                
                // Group landmarks by type
                var matchedLandmarks: [(SCNVector3, Int)] = []
                var usableLandmarks: [(SCNVector3, Int)] = []
                
                for (index, landmark) in landmarks.enumerated() {
                    let position = landmark.position
                    let vertex = SCNVector3(position.x, position.y, position.z)
                    
                    if landmark.isMatched {
                        matchedLandmarks.append((vertex, index))
                    } else {
                        usableLandmarks.append((vertex, index))
                    }
                    
                    // Update progress
                    let progress = Double(index) / Double(landmarks.count) * 0.5 // First 50% for processing
                    Task { @MainActor in
                        progressHandler(progress)
                    }
                }
                
                // Create batch nodes
                let dispatchGroup = DispatchGroup()
                
                if !matchedLandmarks.isEmpty {
                    dispatchGroup.enter()
                    let batchNode = self.createBatchNodes(
                        landmarks: matchedLandmarks,
                        templateKey: "matched",
                        batchName: "MatchedLandmarks"
                    )
                    pointCloudNode.addChildNode(batchNode)
                    dispatchGroup.leave()
                }
                
                if !usableLandmarks.isEmpty {
                    dispatchGroup.enter()
                    let batchNode = self.createBatchNodes(
                        landmarks: usableLandmarks,
                        templateKey: "usable",
                        batchName: "UsableLandmarks"
                    )
                    pointCloudNode.addChildNode(batchNode)
                    dispatchGroup.leave()
                }
                
                dispatchGroup.wait()
                
                Task { @MainActor in
                    progressHandler(1.0) // Complete
                }
                
                continuation.resume(returning: pointCloudNode)
            }
        }
    }
    
    private func createTemplateNodes() {
        guard Self.templateNodes.isEmpty else { return }
        
        // Template for matched landmarks
        let matchedSphere = SCNSphere(radius: AppConfiguration.PointCloud.sphereRadius)
        let matchedMaterial = SCNMaterial()
        matchedMaterial.diffuse.contents = AppConfiguration.PointCloud.matchedLandmarkColor
        matchedSphere.materials = [matchedMaterial]
        let matchedTemplate = SCNNode(geometry: matchedSphere)
        Self.templateNodes["matched"] = matchedTemplate
        
        // Template for usable landmarks
        let usableSphere = SCNSphere(radius: AppConfiguration.PointCloud.sphereRadius)
        let usableMaterial = SCNMaterial()
        usableMaterial.diffuse.contents = AppConfiguration.PointCloud.usableLandmarkColor
        usableSphere.materials = [usableMaterial]
        let usableTemplate = SCNNode(geometry: usableSphere)
        Self.templateNodes["usable"] = usableTemplate
    }
    
    private func createBatchNodes(
        landmarks: [(SCNVector3, Int)],
        templateKey: String,
        batchName: String
    ) -> SCNNode {
        let batchNode = SCNNode()
        batchNode.name = batchName
        
        guard let template = Self.templateNodes[templateKey] else {
            print("Template node not found for key: \(templateKey)")
            return batchNode
        }
        
        // Process in chunks for better performance
        let chunkSize = AppConfiguration.PointCloud.chunkSize
        let chunks = landmarks.chunked(into: chunkSize)
        
        for chunk in chunks {
            let chunkNode = SCNNode()
            
            for (position, _) in chunk {
                let clonedNode = template.clone()
                clonedNode.position = position
                // No individual names needed for visualization-only nodes
                chunkNode.addChildNode(clonedNode)
            }
            
            batchNode.addChildNode(chunkNode)
        }
        
        return batchNode
    }
}

// MARK: - Array Extension
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}