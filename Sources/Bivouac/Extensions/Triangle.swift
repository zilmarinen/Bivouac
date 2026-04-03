//
//  Triangle.swift
//  Bivouac
//
//  Created by Zack Brown on 26/10/2025.
//

import Deltille
import Euclid

// MARK: Kite

extension Triangle {
    
    public var pattern: Triangle.Kite.Pattern {
        
        let patterns = Kite.Pattern.allCases
        
        return patterns[abs(vertex.position.identifier) % patterns.count]
    }
}

// MARK: Septomino

extension Triangle {
    
    public var septomino: Triangle.Septomino {
        
        let septominos = Triangle.Septomino.allCases
        
        return septominos[abs(vertex.position.identifier) % septominos.count]
    }
}
