//
//  SIMD.swift
//  Bivouac
//
//  Created by Zack Brown on 07/03/2026.
//

#if canImport(simd)

import Euclid
import simd

public extension simd_float4 {
    
    init(_ color: Color) {
        
        self.init(Float(color.r),
                  Float(color.g),
                  Float(color.b),
                  Float(color.a))
    }
}

#endif
