//
//  LARSCNAnchorNode.swift
//
//
//  Created by Jean Flaherty on 2025/05/26.
//

import Foundation
import SceneKit
import UIKit

public class LARSCNAnchorNode : SCNNode {
    
    // MARK: - Static Selection Management
    private static weak var currentlySelected: LARSCNAnchorNode?
    
    // MARK: - Factory Methods
    
    private static let baseTemplate = LARSCNAnchorNode()
    
    public static func create(anchorId: Int32) -> LARSCNAnchorNode {
        let newNode = baseTemplate.clone()
        newNode.anchorId = anchorId
        newNode.isSelected = false
        newNode.anchorId = anchorId
        return newNode
    }
    
    
    // MARK: - Properties
    
    public var anchorId: Int32 = -1
    private var haloNode: SCNNode?
    
    public var isSelected: Bool = false {
        didSet {
            if isSelected {
                // Deselect the previously selected node
                Self.currentlySelected?.isSelected = false
                Self.currentlySelected = self
            } else if Self.currentlySelected === self {
                Self.currentlySelected = nil
            }
            haloNode?.isHidden = !isSelected
        }
    }
    
    // MARK: - Initialization
    
    public override init() {
        super.init()
        setupNode()
    }
    
    public required init?(coder: NSCoder) {
        self.anchorId = coder.decodeInt32(forKey: "anchorId")
        let wasSelected = coder.decodeBool(forKey: "isSelected")
        super.init(coder: coder)
        setupNode()
        
        // Restore selection state after setup
        if wasSelected {
            self.isSelected = true
        }
    }
    
    // MARK: - Encoding
    
    public override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(anchorId, forKey: "anchorId")
    }
    
    // MARK: - Private Methods
    
    private func setupNode() {
        // Create the sphere geometry and material
        let sphere = SCNSphere(radius: 0.02)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.magenta
        sphere.materials = [material]
        self.geometry = sphere
        
        createHaloNode()
    }
    
    private func createHaloNode() {
        let haloTube = SCNTube(innerRadius: 0.025, outerRadius: 0.035, height: 0.005)
        let haloMaterial = SCNMaterial()
        haloMaterial.diffuse.contents = UIColor.white
        haloTube.materials = [haloMaterial]
        
        haloNode = SCNNode(geometry: haloTube)
        haloNode?.isHidden = true
        addChildNode(haloNode!)
    }
    
    // MARK: - Public Methods
    
    /// Deselects all anchor nodes
    public static func deselectAll() {
        currentlySelected?.isSelected = false
    }
    
    /// Gets the currently selected anchor node
    public static var selectedNode: LARSCNAnchorNode? {
        return currentlySelected
    }
}
