//
//  Stencil.swift
//  Bivouac
//
//  Created by Zack Brown on 30/03/2026.
//

import Deltille

extension Triangle.Stencil.Vertex: @retroactive Rotatable {
    
    public static let turns: Int = Triangle.turns
    
    public func rotate(_ rotation: Rotation) -> Self {
        
        var rotated = self
        
        for _ in 0..<Self.wrap(rotation.turns) {
            
            rotated = switch rotated {
                
            case .center: .center
            case .v0: .v1
            case .v1: .v2
            case .v2: .v0
            case .v3: .v12
            case .v4: .v8
            case .v5: .v13
            case .v6: .v9
            case .v7: .v5
            case .v8: .v14
            case .v9: .v10
            case .v10: .v6
            case .v11: .v3
            case .v12: .v11
            case .v13: .v7
            case .v14: .v4
            }
        }
        
        return rotated
    }
}

extension Array where Element == Triangle.Stencil.Vertex {
    
    public func rotate(_ rotation: Rotation) -> Self {
     
        map {
            
            $0.rotate(rotation)
        }
    }
}
