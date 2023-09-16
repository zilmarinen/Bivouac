//
//  Vector.swift
//
//  Created by Zack Brown on 15/09/2023.
//

import Euclid
import Foundation

extension Vector {
    
    func isEqual(to other: Vector,
                 withPrecision p: Double = 1e-8) -> Bool {  x.isEqual(to: other.x, withPrecision: p) &&
                                                            y.isEqual(to: other.y, withPrecision: p) &&
                                                            z.isEqual(to: other.z, withPrecision: p) }
}
