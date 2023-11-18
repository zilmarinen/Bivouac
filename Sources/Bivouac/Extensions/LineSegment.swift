//
//  LineSegment.swift
//
//  Created by Zack Brown on 07/10/2023.
//

import Euclid
import Foundation

extension LineSegment: Identifiable {
    
    public var id: String { "\(start.id) -> \(end.id)" }
}

extension LineSegment {
    
    public enum Side {
        
        case left
        case right
    }
    
    public func vertex(for side: Side) -> Vector { side == .left ? start : end }
}

extension LineSegment {
    
    public var center: Vector { start.lerp(end, 0.5) }
    
    public var binormal: Vector {
        
        let d = direction
        let p = d.perpendicular.normalized()
        
        return d.cross(p)
    }
}

extension LineSegment {
    
    public func influence(vector: Vector,
                          tolerance: Double) -> Double {
        
        let d = direction
        
        let ac = vector - start
        
        let dot = ac.dot(d)
        
        let l = d * dot
        
        let projected = start + l
        
        guard (vector - projected).length <= tolerance else { return -1 }
        
        return (1.0 / length) * l.length
    }
}
