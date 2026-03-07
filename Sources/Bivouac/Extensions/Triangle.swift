//
//  Triangle.swift
//  Bivouac
//
//  Created by Zack Brown on 26/10/2025.
//

import Deltille
import Euclid

extension Triangle {
    
    public var septomino: Triangle.Septomino {
        
        let septominos = Triangle.Septomino.allCases
        
        return septominos[abs(vertex.position.identifier) % septominos.count]
    }
}
