//
//  QuadraticBezier.swift
//
//  Created by Zack Brown on 18/11/2023.
//

import Euclid

public struct QuadraticBezier {
    
    public let points: [Vector]
    
    public init(from: Vector,
                towards: Vector,
                control: Vector,
                steps: Int) {
        
        let steps = max(steps, 1) + 1
        
        let stride = 1.0 / Double(steps)
        
        self.points = (0...steps).map {
            
            let t = stride * Double($0)
            let lhs = from.lerp(control, t)
            let rhs = control.lerp(towards, t)
            
            return lhs.lerp(rhs, t)
        }
    }
}
