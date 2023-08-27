//
//  Array.swift
//
//  Created by Zack Brown on 26/08/2023.
//

import Euclid
import Foundation

extension Array where Element == Polygon {
    
    public enum MeshError: Error {
        
        case invalidPolygon
    }
    
    @inlinable public mutating func glue(_ polygon: Polygon?) throws {
        
        guard let polygon else { throw MeshError.invalidPolygon }
        
        append(polygon)
    }
}
