//
//  Path.swift
//
//  Created by Zack Brown on 08/10/2023.
//

import Euclid
import Foundation

extension Path {
    
    public init(_ vertices: [Vector],
                color: Color,
                isCurved: Bool = false) {
        
        self.init(vertices.map { PathPoint($0,
                                           texcoord: nil,
                                           color: color,
                                           isCurved: isCurved) })
    }
    
    public func extrude(depth: Double = 0.05) -> Mesh { Mesh.extrude(self,
                                                                     depth: depth) }
}
