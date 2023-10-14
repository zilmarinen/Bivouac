//
//  Polygon.swift
//
//  Created by Zack Brown on 26/08/2023.
//

import Euclid

extension Polygon {
    
    public struct Face {
        
        public let vertices: [Vertex]
        public let normal: Vector
        
        public var polygon: Polygon? { Polygon(vertices) }
        
        public init?(_ vectors: [Vector],
                     color: Color) {
            
            guard vectors.count > 2 else { return nil }
            
            let v0 = vectors[0]
            let v1 = vectors[1]
            let v2 = vectors[2]
            
            let ab = v2 - v1
            let bc = v0 - v1
                        
            let normal = ab.cross(bc).normalized()
            
            self.vertices = vectors.map { Vertex($0,
                                                 normal,
                                                 nil,
                                                 color) }
            self.normal = normal
        }
        
        public init?(_ vectors: [Vector],
                     colors: [Color]) {
            
            guard vectors.count > 2 else { return nil }
            
            let v0 = vectors[0]
            let v1 = vectors[1]
            let v2 = vectors[2]
            
            let ab = v2 - v1
            let bc = v0 - v1
                        
            let normal = ab.cross(bc).normalized()
            
            self.vertices = vectors.indices.map { Vertex(vectors[$0],
                                                         normal,
                                                         nil,
                                                         colors[$0]) }
            self.normal = normal
        }
    }
}
