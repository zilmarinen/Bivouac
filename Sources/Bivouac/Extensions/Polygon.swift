//
//  Polygon.swift
//
//  Created by Zack Brown on 26/08/2023.
//

import Euclid

extension Polygon {
    
    public struct Face {
        
        private let vectors: [Vector]
        
        public init(vectors: [Vector]) {
         
            self.vectors = vectors
        }
        
        public func polygon(color: Color) -> Polygon? {
            
            guard vectors.count > 2 else { return nil }
            
            let v0 = vectors[0]
            let v1 = vectors[1]
            let v2 = vectors[2]
            
            let ab = v2 - v1
            let bc = v0 - v1
                        
            let normal = ab.cross(bc).normalized()
            
            let vertices = vectors.map { Vertex($0,
                                                normal,
                                                nil,
                                                color) }
            
            return Polygon(vertices)
        }
    }
}
