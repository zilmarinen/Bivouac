//
//  Array.swift
//
//  Created by Zack Brown on 26/08/2023.
//

import Euclid
import Foundation

extension Array where Element == Coordinate {
    
    public func rotate(rotation: Coordinate.Rotation) -> Self { map { $0.rotate(rotation: rotation) } }
    
    public var perimeter: [Coordinate] {
        
        var coordinates = Set<Coordinate>()
        
        forEach { coordinates.formUnion(Grid.Triangle($0).perimeter) }
        
        return Array(coordinates.subtracting(self))
    }
    
    public var vertices: [Grid.Vertex] {
        
        var vertices = Set<Grid.Vertex>()
        
        forEach { vertices.formUnion(Grid.Triangle($0).vertices.map { Grid.Vertex($0) }) }
        
        return Array<Grid.Vertex>(vertices)
    }
}

extension Array where Element == Grid.Triangle.Kite {
    
    public func rotate(times: Int = 1) -> Self {
        
        let times = times % count
        
        return indices.map { self[($0 + times) % count] }
    }
}

extension Array where Element == Polygon {
    
    public enum MeshError: Error {
        
        case invalidPolygon
    }
    
    @inlinable public mutating func glue(_ polygon: Polygon?) throws {
        
        guard let polygon else { throw MeshError.invalidPolygon }
        
        append(polygon)
    }
}

extension Array where Element == Grid.Triangle {
    
    public var perimeter: [Grid.Triangle] {
        
        var triangles = Set<Grid.Triangle>()
        
        forEach { triangles.formUnion($0.perimeter.map { Grid.Triangle($0) }) }
        
        return Array(triangles.subtracting(self))
    }
    
    public var vertices: [Grid.Vertex] {
        
        var vertices = Set<Grid.Vertex>()
        
        forEach { vertices.formUnion($0.vertices.map { Grid.Vertex($0) }) }
        
        return Array<Grid.Vertex>(vertices)
    }
}

extension Array where Element == Vector {
    
    public var average: Vector {
        
        var vector = Vector.zero
        
        forEach { vector += $0 }
        
        return vector / Double(count)
    }
}
