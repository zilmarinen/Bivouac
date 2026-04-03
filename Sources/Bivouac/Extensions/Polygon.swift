//
//  Polygon.swift
//  Bivouac
//
//  Created by Zack Brown on 02/04/2026.
//

import Euclid

// MARK: Surface

public extension Polygon {
    
    static func surface(_ vectors: [Vector],
                        _ color: Color) -> Self? {
        
        guard vectors.count >= 3 else { return nil }
        
        let a = vectors[0]
        let b = vectors[1]
        let c = vectors[2]
        
        let ac = c - a
        let bc = c - b
        
        let normal = ac.cross(bc).normalized()
        
        let vertices = vectors.map {
            
            Vertex($0,
                   normal,
                   nil,
                   color)
        }
        
        return Polygon(vertices)
    }
}
