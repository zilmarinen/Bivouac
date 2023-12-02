//
//  Surface.swift
//
//  Created by Zack Brown on 13/10/2023.
//

import Euclid
import Foundation
import SceneKit

internal class Surface: SCNNode {
    
    required override public init() {
        
        super.init()
        
        self.geometry = SCNPlane(width: 2.0,
                                 height: 2.0)
        self.geometry?.program = Program(function: .surface)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
