//
//  MeshError.swift
//
//  Created by Zack Brown on 15/10/2023.
//

import Euclid
import Foundation

public enum MeshError: Error {
    
    case errors([Error])
    
    case invalidLineSegment
    case invalidPolygon
    case invalidStencil
    
    case invalid(face: [Vertex])
    case invalid(triangle: Coordinate)
    case invalid(vertex: Coordinate)
}
