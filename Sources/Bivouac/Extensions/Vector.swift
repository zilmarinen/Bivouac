//
//  Vector.swift
//  Bivouac
//
//  Created by Zack Brown on 28/04/2026.
//

import Euclid

public extension Array where Element == Vector {
    
    var center: Vector {
        
        let vector = reduce(into: Vector.zero) { result, vertex in
            
            result += vertex
        }
        
        return vector / Double(count)
    }
}
