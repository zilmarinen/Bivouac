//
//  LineSegment.swift
//
//  Created by Zack Brown on 07/10/2023.
//

import Euclid
import Foundation

extension LineSegment {
    
    public enum Side {
        
        case left
        case right
    }
    
    public var center: Vector { start.lerp(end, 0.5) }
    
    public func vertex(for side: Side) -> Vector { side == .left ? start : end }
}
