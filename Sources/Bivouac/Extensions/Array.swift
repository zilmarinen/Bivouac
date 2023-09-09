//
//  Array.swift
//
//  Created by Zack Brown on 26/08/2023.
//

import Euclid
import Foundation

extension Array where Element == Coordinate {
    
    public func rotate(rotation: Coordinate.Rotation) -> Self { map { $0.rotate(rotation: rotation) } }
}

extension Array where Element == Grid.Triangle.Kite {
    
    public func rotate(times: Int = 1) -> Self {
        
        let times = times % 3
        
        return indices.map { self[$0 + times] }
    }
}

extension Array where Element == Polygon {
    
    public enum MeshError: Error {
        
        case invalidPolygon
    }
    
    @inlinable public mutating func glue(_ polygon: Polygon?) throws {
        
        guard let polygon else { throw MeshError.invalidPolygon }
        
        append(polygon)
    }
}
