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
    
    public func kite(index: Int) -> Triangle.Kite {
        
        let kites = pattern.kites
        
        return kites[abs((vertex.position.identifier % kites.count) + index) % kites.count]
    }
}

// MARK: Septomino

extension Triangle {
    
    public var septomino: Triangle.Septomino {
        
        let septominos = Triangle.Septomino.allCases
        
        return septominos[abs(vertex.position.identifier) % septominos.count]
    }
}
