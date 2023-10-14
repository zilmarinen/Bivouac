//
//  Grid.swift
//
//  Created by Zack Brown on 23/08/2023.
//

import Euclid
import Foundation

public enum Grid { }

extension Grid {
    
    public enum Scale: Int {
        
        case tile = 1
        case chunk = 7
        case region = 28
    }
}

extension Grid {
    
    public enum Axis: Int,
                      CaseIterable,
                      Identifiable {
        
        case x, y, z
        
        public var id: String {
            
            switch self {
                
            case .x: return "X"
            case .y: return "Y"
            case .z: return "Z"
            }
        }
        
        public var color: Color {
            
            switch self {
                
            case .x: return .red
            case .y: return .green
            case .z: return .blue
            }
        }
        
        internal var coordinate: Coordinate {
            
            switch self {
                
            case .x: return .unitX
            case .y: return .unitY
            case .z: return .unitZ
            }
        }
        
        internal var vector: Vector { Vector(coordinate) }
    }
}
