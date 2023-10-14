//
//  Camera.swift
//
//  Created by Zack Brown on 06/09/2023.
//

import Euclid
import SceneKit

public final class Camera: SCNNode {
    
    internal enum Constant {
        
        static let radius = 1.0
    }
    
    public let pov: SCNNode = {
        
        let node = SCNNode()
        
        let camera = SCNCamera()
        
        camera.usesOrthographicProjection = true
        camera.orthographicScale = 5.0
        
        node.position = SCNVector3(0.0, 3.5, 10.0)
        node.camera = camera
        
        return node
    }()
    
    required override public init() {
        
        super.init()
        
        pov.look(at: SCNVector3(0.0, 0.0, 0.0))
        
        addChildNode(pov)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
