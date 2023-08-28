//
//  ColorPalette.swift
//
//  Created by Zack Brown on 24/08/2023.
//

import Euclid

public struct ColorPalette {
    
    public let primary: Color
    public let secondary: Color
    public let tertiary: Color
    public let quaternary: Color
    
    public init(primary: Color,
                secondary: Color,
                tertiary: Color? = nil,
                quaternary: Color? = nil) {
        
        self.primary = primary
        self.secondary = secondary
        self.tertiary = tertiary ?? primary
        self.quaternary = quaternary ?? secondary
    }
}
