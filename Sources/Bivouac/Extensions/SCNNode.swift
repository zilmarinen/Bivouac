//
//  SCNNode.swift
//
//  Created by Zack Brown on 22/09/2023.
//

import SceneKit

extension SCNNode {
    
    public func removeAllChildren() { childNodes.forEach { $0.removeFromParentNode() } }
}
