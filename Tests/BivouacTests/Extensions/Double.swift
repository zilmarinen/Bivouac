//
//  Double.swift
//
//  Created by Zack Brown on 15/09/2023.
//

import Foundation

extension Double {
    
    func isEqual(to other: Double,
                 withPrecision p: Double) -> Bool { self == other || abs(self - other) < p }
}
