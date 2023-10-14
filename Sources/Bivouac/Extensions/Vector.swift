//
//  Vector.swift
//
//  Created by Zack Brown on 23/08/2023.
//

import Euclid
import Foundation

extension Vector: Identifiable {
    
    public var id: String { "[\(x), \(y), \(z)]" }
    
    init(_ coordinate: Coordinate) {
        
        self.init(Double(coordinate.x),
                  Double(coordinate.y),
                  Double(coordinate.z))
    }
}

extension Vector {
    
    public static let up = Vector(0, 1, 0)
}

extension Vector {
    
    public func convert(to scale: Grid.Scale) -> Coordinate {
        
        let edgeLength = Double(scale.rawValue)
        let offset = Double.sqrt3d6 * edgeLength
        let slope = (.sqrt3d3 * z)
        
        let j = (2.0 * slope) + offset
        let i = (x - slope) + offset
        let k = (-x - slope) + offset
        
        return Coordinate(Int(floor(j / edgeLength)),
                          Int(floor(i / edgeLength)),
                          Int(ceil(k / edgeLength) - 1))
    }
}

extension Vector {
    
    public static func curve(from: Vector,
                             towards: Vector,
                             control: Vector,
                             steps: Int) -> [Vector] {
        
        let steps = min(max(steps, 1), 10) + 1
        
        let stride = 1.0 / Double(steps)
        
        return (0..<steps).map {
            
            let step = stride * Double($0)
            
            let c0 = from.lerp(control, step)
            let c1 = control.lerp(towards, step)
            
            return c0.lerp(c1, step)
        }
    }
    
    public func derp(_ a: Vector, _ t: Double) -> Vector {
        
        let d = (a - self).length
        let s = 1.0 / d
        
        return lerp(a, s * t)
    }
}
