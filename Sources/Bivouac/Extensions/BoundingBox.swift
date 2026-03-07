//
//  BoundingBox.swift
//  Bivouac
//
//  Created by Zack Brown on 07/03/2026.
//

import Euclid
import RealityKit

extension BoundingBox {
    
    internal init(_ bounds: Bounds) {
        
        self.init(min: .init(bounds.min),
                  max: .init(bounds.max))
    }
}

