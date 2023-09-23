//
//  Color.swift
//
//  Created by Zack Brown on 22/09/2023.
//

import Euclid
import Foundation

extension Color {
    
    public init(_ string: String) {
        
        var hex = string.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hex.hasPrefix("#") { hex.remove(at: hex.startIndex) }
        
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        
        guard scanner.scanHexInt64(&rgb) else {
            
            self.init(0)
            
            return
        }
        
        self.init(CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                  CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                  CGFloat(rgb & 0x0000FF) / 255.0,
                  CGFloat(1.0))
    }
}
