//
//  SCNNode.swift
//
//  Created by Zack Brown on 22/09/2023.
//

import Euclid
import SceneKit

extension SCNNode {
    
    public convenience init(_ name: String) {
        
        self.init()
        
        self.name = name
        
        let size = 0.03
        
        var mesh = Mesh.cube(size: Vector(size: 0.01),
                             material: Color.gray)
        
        if let x = try? Mesh.bone(start: Vector(worldRight) * 0.01,
                                  end: Vector(worldRight) * size,
                                  color: .red) {
            
            mesh = mesh.merge(x)
        }
        
        if let y = try? Mesh.bone(start: Vector(worldUp) * 0.01,
                                  end: Vector(worldUp) * size,
                                  color: .green) {
            
            mesh = mesh.merge(y)
        }
        
        if let z = try? Mesh.bone(start: Vector(worldFront) * 0.01,
                                  end: Vector(worldFront) * size,
                                  color: .blue) {
            
            mesh = mesh.merge(z)
        }
        
        geometry = SCNGeometry(mesh)
    }
}

extension SCNNode {
 
    public var recursiveChildren: [SCNNode] { childNodes + childNodes.flatMap { $0.recursiveChildren } }
}

extension SCNNode {
    
    public func removeAllChildren() { childNodes.forEach { $0.removeFromParentNode() } }
    
    public func addChildNodes(_ children: [SCNNode]) { children.forEach { addChildNode($0) } }
    
    public func addConstraint(_ constraint: SCNConstraint) { constraints = (constraints ?? []) + [constraint] }
}
