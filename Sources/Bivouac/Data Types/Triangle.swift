//
//  Triangle.swift
//
//  Created by Zack Brown on 23/08/2023.
//

import Euclid
import Foundation

extension Grid {
    
    public struct Triangle: Equatable {
        
        enum Constant {
            
            public static let inverseRotation = 180.0
        }
        
        public var isPointy: Bool { position.equalToZero }
        
        public var delta: Int { isPointy ? -1 : 1 }
        
        public var rotation: Double { isPointy ? 0.0 : Constant.inverseRotation }
        
        public let position: Coordinate
        
        public init(_ position: Coordinate) {
            
            self.position = position
        }
    }
}

extension Grid.Triangle {
    
    public enum Vertex: Int,
                        CaseIterable {
        
        case v0, v1, v2
        
        internal var axis: Grid.Axis {
            
            switch self {
                
            case .v0: return .x
            case .v1: return .y
            case .v2: return .z
            }
        }
        
        public var vertices: [Vertex] {
            
            switch self {
                
            case .v0: return [.v1, .v2]
            case .v1: return [.v2, .v0]
            case .v2: return [.v0, .v1]
            }
        }
    }
    
    public var vertices: [Coordinate] { Vertex.allCases.map { vertex($0) } }
        
    public func vertex(_ vertex: Vertex) -> Coordinate {
        
        let unit = (vertex.axis.coordinate * -1) + (isPointy ? .zero : .one)
        
        return position + (isPointy ? -unit : unit)
    }
    
    public func vertices(for scale: Grid.Scale) -> [Vector] { vertices.map { $0.convert(to: scale) } }
    
    public func index(of vertex: Grid.Vertex) -> Grid.Triangle.Vertex? { Vertex.allCases.first { self.vertex($0) == vertex.position } }
}

extension Grid.Triangle {
    
    //
    //  Stencil defines a fixed set of points for the corners,
    //  edges and interior subdivisions of a triangle and its center.
    //
    //      0-------3-------5-------8-------1
    //        \   /   \   /   \   /   \   /
    //          4-------6-------9-------12
    //            \   /   \ c /   \   /
    //              7------10-------13
    //                \   /   \   /
    //                 11-------14
    //                    \   /
    //                      2
    //
    
    public struct Stencil {
        
        public enum Vertex {
            
            case v0, v1, v2
            case v5, v7, v13
            case v6, v9, v10
            case v3, v4, v8, v11, v12, v14
            case center
        }
        
        // Triangle corners
        public let v0, v1, v2: Vector
        
        // Edge midpoints
        public let v5, v7, v13: Vector
        
        // Inner subdivision
        public let v6, v9, v10: Vector
        
        // Outer subdivisions
        public let v3, v4, v8, v11, v12, v14: Vector
        
        public let scale: Grid.Scale
        
        public var center: Vector { (v0 + v1 + v2) / 3 }
        
        public func vertex(for vertex: Vertex) -> Vector {
            
            switch vertex {
                
            case .v0: return v0
            case .v1: return v1
            case .v2: return v2
            case .v3: return v3
            case .v4: return v4
            case .v5: return v5
            case .v6: return v6
            case .v7: return v7
            case .v8: return v8
            case .v9: return v9
            case .v10: return v10
            case .v11: return v11
            case .v12: return v12
            case .v13: return v13
            case .v14: return v14
            case .center: return center
            }
        }
    }
    
    public func stencil(for scale: Grid.Scale) -> Stencil {
        
        let v0 = vertex(.v0).convert(to: scale)
        let v1 = vertex(.v1).convert(to: scale)
        let v2 = vertex(.v2).convert(to: scale)
        
        let v5 = v0.lerp(v1, 0.5)
        let v7 = v0.lerp(v2, 0.5)
        let v13 = v1.lerp(v2, 0.5)
        
        return Stencil(v0: v0,
                       v1: v1,
                       v2: v2,
                       v5: v5,
                       v7: v7,
                       v13: v13,
                       v6: v5.lerp(v7, 0.5),
                       v9: v5.lerp(v13, 0.5),
                       v10: v7.lerp(v13, 0.5),
                       v3: v0.lerp(v5, 0.5),
                       v4: v0.lerp(v7, 0.5),
                       v8: v1.lerp(v5, 0.5),
                       v11: v2.lerp(v7, 0.5),
                       v12: v1.lerp(v13, 0.5),
                       v14: v2.lerp(v13, 0.5),
                       scale: scale)
    }
}

extension Grid.Triangle {
    
    //
    //  Triangulation partitions a given triangle of a
    //  specific scale into a set of smaller, inner triangles.
    //
    //       -------------------------------
    //        \ x / x \ x / x \ x / x \ x /
    //          -------------------------
    //            \ x / x \ x / x \ x /
    //              -----------------
    //                \ x / x \ x /
    //                  ---------
    //                   \  x  /
    //                      -
    //
    
    public struct Triangulation {
            
        public let coordinate: Coordinate
        public let scale: Grid.Scale
        public let triangles: [Grid.Triangle]
    }
    
    public func triangulation(for scale: Grid.Scale) -> Triangulation {
        
        let pointy = isPointy
        let size = Int(floor(Double(scale.rawValue) / 2.0))
        let half = Int(Double(size) / 2.0)
        
        var triangles: [Grid.Triangle] = []
        
        for column in 0..<scale.rawValue {
            
            let rows = ((column * 2) + 1)
            
            let s = size - column
            
            for row in 0..<rows {
                
                let i = Int(ceil(Double(row) * 0.5))
                let j = Int(ceil(Double(row - 1) * 0.5))
                
                let t = (half - column) + i
                let u = half - j
                
                let offset = Coordinate(pointy ? -s : -u,
                                        pointy ? t : -t,
                                        pointy ? u : s)
                
                triangles.append(.init(position + offset))
            }
        }
        
        return Triangulation(coordinate: position,
                             scale: scale,
                             triangles: triangles)
    }
}

extension Grid.Triangle {
    
    //
    //  Sieve defines all the corner vertices for each subdivided
    //  inner triangle for a given triangle of a specific scale.
    //
    //      x-------x-------x-------x-------x
    //        \   /   \   /   \   /   \   /
    //          x-------x-------x-------x
    //            \   /   \   /   \   /
    //              x-------x-------x
    //                \   /   \   /
    //                  x-------x
    //                    \   /
    //                      x
    //
    
    public struct Sieve {
            
        public let coordinate: Coordinate
        public let scale: Grid.Scale
        public let vertices: [Grid.Vertex]
    }
    
    public func sieve(for scale: Grid.Scale) -> Sieve {
        
        let columns = scale.rawValue + 1
        let size = Int(ceil(Double(scale.rawValue) / sqrt(.silver)))
        let half = Int(floor(Double(size) / 2.0))
        let origin = position.convert(from: scale,
                                      to: .tile)
        let pointy = position.equalToZero
        
        var vertices: [Grid.Vertex] = []

        for column in 0..<columns {

            let rows = columns - column

            let s = half - column
            
            for row in 0..<rows {

                let t = half - row
                let u = -size + column + row

                let offset = Coordinate(pointy ? u : -u - 1,
                                        pointy ? t : -t - 1,
                                        pointy ? s : -s - 1)

                vertices.append(.init(origin + offset))
            }
        }
        
        return Sieve(coordinate: position,
                     scale: scale,
                     vertices: vertices)
    }
}

extension Grid.Triangle {
    
    public var perimeter: [Coordinate] { adjacent + diagonals + touching }
    
    //
    //  Directly connected adjacent triangles that share an edge.
    //
    //                  :-------:
    //
    //              :-------:-------:
    //                  z   o   y
    //          :-------:-------:-------:
    //                      x
    //              :-------:-------:
    //
 
    public var adjacent: [Coordinate] { Grid.Axis.allCases.map { adjacent(along: $0) } }
    
    public func adjacent(along axis: Grid.Axis) -> Coordinate { position + (axis.coordinate * delta) }
    
    //
    //  Indirectly connected diagonal triangles that are touching a corner.
    //
    //                  :-------:
    //                      x
    //              :-------:-------:
    //                      o
    //          :-------:-------:-------:
    //              y               z
    //              :-------:-------:
    //
    
    public var diagonals: [Coordinate] { Grid.Axis.allCases.map { diagonal(along: $0) } }
    
    public func diagonal(along axis: Grid.Axis) -> Coordinate {
        
        switch axis {
            
        case .x: return .init(-delta + position.x, delta + position.y, delta + position.z)
        case .y: return .init(delta + position.x, -delta + position.y, delta + position.z)
        case .z: return .init(delta + position.x, delta + position.y, -delta + position.z)
        }
    }
    
    //
    //  Indirectly connected triangles that are touching a corner.
    //
    //                  :-------:
    //                  z       y
    //              :-------:-------:
    //              z       o       y
    //          :-------:-------:-------:
    //                  x       x
    //              :-------:-------:
    //
    
    public var touching: [Coordinate] { Grid.Axis.allCases.flatMap { touching(along: $0) } }
    
    public func touching(along axis: Grid.Axis) -> [Coordinate] {
        
        switch axis {
            
        case .x: return [.init(-delta + position.x, position.y, delta + position.z),
                         .init(-delta + position.x, delta + position.y, position.z)]
        case .y: return [.init(position.x, -delta + position.y, delta + position.z),
                         .init(delta + position.x, -delta + position.y, position.z)]
        case .z: return [.init(position.x, delta + position.y, -delta + position.z),
                         .init(delta + position.x, position.y, -delta + position.z)]
        }
    }
}
