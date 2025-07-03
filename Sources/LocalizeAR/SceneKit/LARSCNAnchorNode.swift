//
//  LARSCNAnchorNode.swift
//
//
//  Created by Jean Flaherty on 2025/05/26.
//

import Foundation
import SceneKit
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
typealias UIColor = NSColor
#endif

public class LARSCNAnchorNode : SCNNode {
	public static let anchorCategory: Int = 1 << 10
 
    
    // MARK: - Factory Methods
    
    private static let baseTemplate = LARSCNAnchorNode()
    
    public static func create(anchorId: Int32) -> LARSCNAnchorNode {
        let newNode = baseTemplate.clone()
        newNode.anchorId = anchorId
        return newNode
    }
    
    // MARK: - Properties
    
    public var anchorId: Int32 = -1
    private var haloNode: SCNNode?
    
    public var isSelected: Bool = false {
        didSet {
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
        coder.encode(isSelected, forKey: "isSelected")
    }
    
    // MARK: - Private Methods
    
    private func setupNode() {
        // Create the sphere geometry and material
        let sphere = SCNSphere(radius: 0.1)
        let material = SCNMaterial()
		material.diffuse.contents = UIColor.white
        sphere.materials = [material]
        self.geometry = sphere
        
        createHaloNode()
		self.categoryBitMask = Self.anchorCategory
    }
    
    private func createHaloNode() {
        let haloTube = SCNTube(innerRadius: 0.2, outerRadius: 0.3, height: 0.01)
        let haloMaterial = SCNMaterial()
        haloMaterial.diffuse.contents = UIColor.white
        haloTube.materials = [haloMaterial]
        
        haloNode = SCNNode(geometry: haloTube)
        haloNode?.isHidden = true
        addChildNode(haloNode!)
    }
    
}
