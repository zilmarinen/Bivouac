//
//  Camera.swift
//
//  Created by Zack Brown on 06/09/2023.
//

import Euclid
import SceneKit

public final class Camera: SCNNode {
    
    public let pov: SCNNode = {
        
        let node = SCNNode()
        
        let camera = SCNCamera()
        
        camera.usesOrthographicProjection = false
        camera.orthographicScale = 0.7
        
        node.position = SCNVector3(Vector.up * 3.5 + -Vector.forward * 3.5)
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
