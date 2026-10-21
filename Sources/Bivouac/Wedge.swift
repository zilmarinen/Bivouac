//
//  Wedge.swift
//  Bivouac
//
//  Created by Zack Brown on 18/11/2025.
//

import Collections
import Deltille

public enum Wedge: Codable,
                   Hashable,
                   Identifiable,
                   Sendable{
    
    case corner(triangle: Triangle,
                corner: Triangle.Corner)
    case edge(triangle: Triangle,
              edge: Triangle.Edge)
    case tile(triangle: Triangle,
              corners: OrderedSet<Triangle.Corner>)
    
    public var id: String {
        
        switch self {
            
        case .corner: "Corner"
        case .edge: "Edge"
        case .tile: "Tile"
        }
    }
    
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

extension Wedge {
    
    public var orientation: Double {
        
        switch self {
            
        case .corner(let triangle,
                     let corner):
            
            let rotation = Triangle.Rotation(-corner.rawValue)
            
            return triangle.orientation + rotation.radians
            
        case .edge(let triangle,
                   let edge):
            
            let rotation = Triangle.Rotation(-edge.rawValue)
            
            return triangle.orientation + rotation.radians
            
        case .tile(let triangle,
                   _):
            
            return triangle.orientation
        }
    }
}
