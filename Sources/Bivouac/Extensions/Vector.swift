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
