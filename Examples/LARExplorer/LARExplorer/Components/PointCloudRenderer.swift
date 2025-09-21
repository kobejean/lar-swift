//
//  PointCloudRenderer.swift
//  LARExplorer
//
//  Created by Jean Flaherty on 2025-06-30.
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

        print("Point cloud loaded successfully with \(map.landmarks.count) landmarks (hit-testable)")
    }
    
    // MARK: - Private Methods
    private func removeExistingPointClouds(from mapNode: SCNNode) async {
        mapNode.childNode(withName: AppConfiguration.PointCloud.containerNodeName, recursively: false)?.removeFromParentNode()
        mapNode.childNode(withName: "LODLandmarkPointCloud", recursively: false)?.removeFromParentNode()
        mapNode.childNode(withName: "landmarkHitTestLayer", recursively: false)?.removeFromParentNode()
    }
    
    private func createPointCloudNode(
        from map: LARMap,
        progressHandler: @escaping (Double) -> Void
    ) async -> SCNNode {
        // Create template nodes on main actor before background work
        await createTemplateNodes()
        
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let pointCloudNode = SCNNode()
                pointCloudNode.name = AppConfiguration.PointCloud.containerNodeName
                
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

                    // Update progress every 5000 landmarks to avoid overwhelming the UI
                    if index % 5000 == 0 || index == landmarks.count - 1 {
                        let progress = Double(index + 1) / Double(landmarks.count) * 0.8 // First 80% for processing
                        DispatchQueue.main.async {
                            progressHandler(progress)
                        }
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

                // Final progress update - node creation complete
                DispatchQueue.main.async {
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
            
            for (position, index) in chunk {
                let clonedNode = template.clone()
                clonedNode.position = position

                // Make landmarks hit-testable for inspection
                clonedNode.categoryBitMask = PointCloudRenderer.landmarkHitTestCategory
                // Store landmark index in node name for identification
                clonedNode.name = "landmark_\(index)"

                chunkNode.addChildNode(clonedNode)
            }
            
            batchNode.addChildNode(chunkNode)
        }
        
        return batchNode
    }
    
    // MARK: - Landmark Highlighting for Localization Visualization
    
    /// Highlights landmarks based on their localization status with different colors and sizes
    /// - Parameters:
    ///   - spatialQueryIds: Landmarks found by spatial query (shown in yellow)
    ///   - matchIds: Landmarks that matched features (shown in orange)
    ///   - inlierIds: Landmarks that passed RANSAC validation (shown in green)
    ///   - mapNode: The scene node containing the map
    ///   - landmarks: All landmarks in the map for position lookup
    ///   - sceneView: The scene view for accessing camera (needed for scale constraint)
    func highlightLandmarks(
        spatialQueryIds: [Int],
        matchIds: [Int], 
        inlierIds: [Int],
        in mapNode: SCNNode,
        landmarks: [LARLandmark],
        sceneView: SCNView? = nil
    ) {
        // Remove any existing highlight nodes
        clearLandmarkHighlights(in: mapNode)
        
        // Configure scale constraint if enabled
        let scaleConstraint: SCNScreenSpaceScaleConstraint?
        if AppConfiguration.PointCloud.Localization.enableScaleConstraint,
           let pointOfView = sceneView?.pointOfView {
            scaleConstraint = SCNScreenSpaceScaleConstraint(pointOfView: pointOfView)
            print("Scale constraint enabled with factor: \(AppConfiguration.PointCloud.Localization.scaleDistanceFactor)")
        } else {
            scaleConstraint = nil
            print("Scale constraint disabled or no camera found")
        }
        
        // Create lookup sets for efficient checking
        let inlierSet = Set(inlierIds)
        
        // Configuration for highlight nodes
        let config = AppConfiguration.PointCloud.Localization.self
        
        // Create spatial query highlights (white, no scale constraint)
        let spatialQueryNode = createHighlightNodes(
            landmarkIds: spatialQueryIds,
            landmarks: landmarks,
            color: config.spatialQueryColor,
            nodeName: config.spatialQueryNodeName,
            radius: config.highlightRadius,
            useScaleConstraint: false
        )
        
        // Create match highlights
        let matchNode = createHighlightNodes(
            landmarkIds: matchIds.filter { !inlierSet.contains($0) }, // Exclude inliers
            landmarks: landmarks,
            color: config.matchColor,
            nodeName: config.matchNodeName,
			radius: config.highlightRadius,
            useScaleConstraint: true,
            scaleConstraint: scaleConstraint
        )
        
        // Create inlier highlights
        let inlierNode = createHighlightNodes(
            landmarkIds: inlierIds,
            landmarks: landmarks,
            color: config.inlierColor,
            nodeName: config.inlierNodeName,
            radius: config.highlightRadius,
            useScaleConstraint: true,
            scaleConstraint: scaleConstraint
        )
        
        // Add new highlight nodes
        mapNode.addChildNode(spatialQueryNode)
        mapNode.addChildNode(matchNode)
        mapNode.addChildNode(inlierNode)
        
        print("Added landmark highlights: \(spatialQueryIds.count) spatial, \(matchIds.count) matches, \(inlierIds.count) inliers")
    }
    
    func clearLandmarkHighlights(in mapNode: SCNNode) {
        // Remove all highlight nodes using configuration names
        let config = AppConfiguration.PointCloud.Localization.self
        mapNode.childNode(withName: config.spatialQueryNodeName, recursively: false)?.removeFromParentNode()
        mapNode.childNode(withName: config.matchNodeName, recursively: false)?.removeFromParentNode()
        mapNode.childNode(withName: config.inlierNodeName, recursively: false)?.removeFromParentNode()
    }
    
    private func resetLandmarkColors(in mapNode: SCNNode) {
        // Reset to original colors based on landmark state
        guard let pointCloudContainer = mapNode.childNode(withName: AppConfiguration.PointCloud.containerNodeName, recursively: false) else {
            return
        }
        
        // Reset matched landmarks to green
        if let matchedNode = pointCloudContainer.childNode(withName: "MatchedLandmarks", recursively: false) {
            setNodeTreeColor(matchedNode, color: AppConfiguration.PointCloud.matchedLandmarkColor)
        }
        
        // Reset usable landmarks to red
        if let usableNode = pointCloudContainer.childNode(withName: "UsableLandmarks", recursively: false) {
            setNodeTreeColor(usableNode, color: AppConfiguration.PointCloud.usableLandmarkColor)
        }
    }
    
    private func highlightLandmark(id: Int, color: NSColor, in mapNode: SCNNode) {
        // This is a simplified approach - for better performance, you might want to
        // maintain a map of landmark ID to scene node for direct access
        guard let pointCloudContainer = mapNode.childNode(withName: AppConfiguration.PointCloud.containerNodeName, recursively: false) else {
            return
        }
        
        // Search through all landmark nodes and update the matching one
        pointCloudContainer.enumerateChildNodes { node, _ in
            node.enumerateChildNodes { chunkNode, _ in
                chunkNode.enumerateChildNodes { landmarkNode, _ in
                    // For now, we'll color all landmarks in the highlighted sets
                    // A more sophisticated approach would track landmark IDs to nodes
                }
            }
        }
    }
    
    private func createHighlightNodes(
        landmarkIds: [Int],
        landmarks: [LARLandmark],
        color: NSColor,
        nodeName: String,
        radius: Double,
        useScaleConstraint: Bool = false,
        scaleConstraint: SCNScreenSpaceScaleConstraint? = nil
    ) -> SCNNode {
        let containerNode = SCNNode()
        containerNode.name = nodeName
        
        guard !landmarkIds.isEmpty else { return containerNode }
        
        // Create shared geometry and material for efficiency
        let sphere = SCNSphere(radius: radius)
        let material = SCNMaterial()
        material.diffuse.contents = color
        sphere.materials = [material]
        
        // Create set for efficient lookup
        let idSet = Set(landmarkIds)
        
        // Collect positions for matching landmarks
        var positions: [SCNVector3] = []
        for landmark in landmarks {
            if idSet.contains(Int(landmark.id)) {
                let position = landmark.position
                positions.append(SCNVector3(position.x, position.y, position.z))
            }
        }
        
        // For better performance with many landmarks, use a single geometry with multiple instances
        if positions.count > 50 {
            // Use instanced rendering for large sets
            let instancedNode = SCNNode(geometry: sphere)
            
            // Create transform matrices for instances
            let transforms = positions.map { position in
                SCNMatrix4MakeTranslation(position.x, position.y, position.z)
            }
            
            // Apply transforms as instances (if supported by future SceneKit versions)
            // For now, fall back to individual nodes but in batches
            let batchSize = 100
            for batch in positions.chunked(into: batchSize) {
                let batchNode = SCNNode()
                for position in batch {
                    let node = SCNNode(geometry: sphere)
                    node.position = position
                    if useScaleConstraint, let constraint = scaleConstraint {
                        node.constraints = [constraint]
                    }
                    batchNode.addChildNode(node)
                }
                containerNode.addChildNode(batchNode)
            }
        } else {
            // Use individual nodes for smaller sets
            for position in positions {
                let highlightNode = SCNNode(geometry: sphere)
                highlightNode.position = position
                if useScaleConstraint, let constraint = scaleConstraint {
                    highlightNode.constraints = [constraint]
                }
                containerNode.addChildNode(highlightNode)
            }
        }
        
        return containerNode
    }
    
    // MARK: - Landmark Hit Testing

    static let landmarkHitTestCategory: Int = 0x04

    private func setNodeTreeColor(_ node: SCNNode, color: NSColor) {
        // Set color for this node
        if let geometry = node.geometry {
            let material = SCNMaterial()
            material.diffuse.contents = color
            geometry.materials = [material]
        }
        
        // Recursively set color for child nodes
        for child in node.childNodes {
            setNodeTreeColor(child, color: color)
        }
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
