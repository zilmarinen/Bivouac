//
//  Triangle.swift
//
//  Created by Zack Brown on 23/08/2023.
//

import Euclid
import Foundation

extension Grid {
    
    public struct Triangle {
        
        public var isPointy: Bool { coordinate.equalToZero }
        
        public var delta: Int { isPointy ? -1 : 1 }
        
        public let coordinate: Coordinate
        
        public init(_ coordinate: Coordinate) {
            
            self.coordinate = coordinate
        }
    }
}

extension Grid.Triangle {
    
    public enum Corner: CaseIterable {
        
        case c0, c1, c2
    }
    
    public var corners: [Coordinate] { Corner.allCases.map { corner(corner: $0) } }
        
    public func corner(corner: Corner) -> Coordinate {
        
        switch corner {
        case .c0: return Coordinate(delta + coordinate.x,
                                    coordinate.y,
                                    coordinate.z)
            
        case .c1: return Coordinate(coordinate.x,
                                    coordinate.y,
                                    delta + coordinate.z)
            
        case .c2: return Coordinate(coordinate.x,
                                    delta + coordinate.y,
                                    coordinate.z)
        }
    }
    
    public func vertices(for scale: Grid.Scale) -> [Vector] { corners.map { $0.convert(to: scale) } }
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
        
        let v0 = corner(corner: .c0).convert(to: scale)
        let v1 = corner(corner: .c1).convert(to: scale)
        let v2 = corner(corner: .c2).convert(to: scale)
        
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
                
                triangles.append(.init(coordinate + offset))
            }
        }
        
        return Triangulation(coordinate: coordinate,
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
        public let coordinates: [Coordinate]
    }
    
    public func sieve(for scale: Grid.Scale) -> Sieve {
        
        let columns = scale.rawValue + 1
        let size = Int(ceil(Double(scale.rawValue) / sqrt(.silver)))
        let half = Int(floor(Double(size) / 2.0))
        let origin = coordinate.convert(from: scale,
                                        to: .tile)
        let pointy = origin.equalToZero
        
        var handles: [Coordinate] = []

        for column in 0..<columns {

            let rows = columns - column

            let s = half - column
            
            for row in 0..<rows {

                let t = half - row
                let u = -size + column + row

                let offset = Coordinate(pointy ? u : -u - 1,
                                        pointy ? t : -t - 1,
                                        pointy ? s : -s - 1)

                handles.append(origin + offset)
            }
        }
        
        return Sieve(coordinate: coordinate,
                     scale: scale,
                     coordinates: handles)
    }
}

extension Grid.Triangle {
    
    public enum Kite: Int,
                      CaseIterable,
                      Identifiable {
        
        case delta
        case epsilon
        case gamma
        case lambda
        case omega
        case phi
        case psi
        case sigma
        
        public var id: String {
            
            switch self {
                
            case .delta: return "Delta"
            case .epsilon: return "Epsilon"
            case .gamma: return "Gamma"
            case .lambda: return "Lambda"
            case .omega: return "Omega"
            case .phi: return "Phi"
            case .psi: return "Psi"
            case .sigma: return "Sigma"
            }
        }
        
        public func vertices(for scale: Grid.Scale) -> [Stencil.Vertex] {
            
            switch self {
                
            case .delta: return [.v0, .v5, .v7]
            case .epsilon: return [.v0, .v5, .center, .v7]
            case .gamma: return [.v0, .v5, .v9, .v10, .v6, .v7]
            case .lambda: return [.v0, .v5, .v6, .v9, .v10, .v7]
            case .omega: return [.v0, .v5, .v9, .v10, .v7]
            case .phi: return [.v0, .v5, .v9, .v6, .v7]
            case .psi: return [.v0, .v5, .v6, .v10, .v7]
            case .sigma: return [.v0, .v5, .v9, .v6, .v10, .v7]
            }
        }
    }
}

extension Grid.Triangle {
    
    public enum Pattern: Int,
                         Identifiable {
        
        case descartes
        case euclid
        case euler
        case gauss
        case mobius
        case pascal
        case thales
        
        public var id: String {
            
            switch self {
                
            case .descartes: return "Descartes"
            case .euclid: return "Euclid"
            case .euler: return "Euler"
            case .gauss: return "Gauss"
            case .mobius: return "Mobius"
            case .pascal: return "Pascal"
            case .thales: return "Thales"
            }
        }
        
        public var kites: [Kite] {
            
            switch self {
                
            case .descartes: return [.epsilon, .epsilon, .epsilon]
            case .euclid: return [.lambda, .delta, .sigma]
            case .euler: return [.psi, .delta, .omega]
            case .gauss: return [.lambda, .psi, .psi]
            case .mobius: return [.delta, .gamma, .sigma]
            case .pascal: return [.phi, .gamma, .phi]
            case .thales: return [.delta, .phi, .omega]
            }
        }
    }
}

