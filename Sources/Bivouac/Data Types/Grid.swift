//
//  Grid.swift
//
//  Created by Zack Brown on 23/08/2023.
//

import Foundation

public enum Grid {
    
    public enum Scale: Int {
        
        case tile = 1
        case chunk = 7
        case region = 28
    }
    
    public enum Axis: CaseIterable {
        
        case x, y, z
    }
}
