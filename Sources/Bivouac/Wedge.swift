//
//  Wedge.swift
//  Bivouac
//
//  Created by Zack Brown on 18/11/2025.
//

import Deltille

public enum Wedge: Codable {
    
    case corner(triangle: Triangle,
                corner: Triangle.Corner)
    case edge(triangle: Triangle,
              edge: Triangle.Edge)
    case tile(triangle: Triangle,
              corners: [Triangle.Corner])
    
    public init(_ triangle: Triangle,
                _ vertices: [Triangle.Vertex]) {
        
        let corners = vertices.compactMap {
            
            triangle.corner($0)
        }
        
        switch corners.count {
            
        case 1:
            
            self = .corner(triangle: triangle,
                           corner: corners.first!)
            
        case 2:
            
            let edge = triangle.edges.first { Set($0.corners).isSubset(of: corners) }
            
            self = .edge(triangle: triangle,
                         edge: edge!)
            
        default:
            
            self = .tile(triangle: triangle,
                         corners: triangle.corners)
        }
    }
}
