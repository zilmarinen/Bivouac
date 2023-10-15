//
//  Coordinate.swift
//
//  Created by Zack Brown on 23/08/2023.
//

import Euclid

public struct Coordinate: Codable,
                          Equatable,
                          Hashable,
                          Identifiable {
    
    public let x: Int
    public let y: Int
    public let z: Int
    
    public var id: String { "[\(x), \(y), \(z)]" }
    
    public var sum: Int { x + y + z }
    public var sumAbs: Int { abs(x) + abs(y) + abs(z) }
    public var index: Int { sumAbs * x + y * z }
    
    public var equalToZero: Bool { sum == 0 }
    public var equalToOne: Bool { sum == 1 }
    public var equalToNegativeOne: Bool { sum == -1 }
    
    public init(_ x: Int,
                _ y: Int,
                _ z: Int) {
        
        self.x = x
        self.y = y
        self.z = z
    }
}

extension Coordinate {
    
    public static let zero = Coordinate(0, 0, 0)
    public static let one = Coordinate(1, 1, 1)
    public static let unitX = Coordinate(1, 0, 0)
    public static let unitY = Coordinate(0, 1, 0)
    public static let unitZ = Coordinate(0, 0, 1)
    
    public static func -(lhs: Coordinate,
                         rhs: Coordinate) -> Coordinate { Coordinate(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z) }
    
    public static func +(lhs: Coordinate,
                         rhs: Coordinate) -> Coordinate { Coordinate(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z) }
    
    public static prefix func -(rhs: Coordinate) -> Coordinate { Coordinate(-rhs.x, -rhs.y, -rhs.z) }
    
    public static func *(lhs: Coordinate,
                         rhs: Int) -> Coordinate { Coordinate(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs) }
}

extension Coordinate {
    
    public func convert(from: Grid.Scale,
                        to: Grid.Scale) -> Coordinate {
        
        guard from != to else { return self }
        
        return convert(to: from).convert(to: to)
    }
    
    public func convert(to scale: Grid.Scale) -> Vector {
        
        let edgeLength = Double(scale.rawValue)
        
        let dx = Double(y)
        let dy = Double(x)
        let dz = Double(z)
            
        return Vector((0.5 * dx + -0.5 * dz) * edgeLength,
                      0,
                      ((-.sqrt3d6 * dx) + (.sqrt3d3 * dy) - (.sqrt3d6 * dz)) * edgeLength)
    }
}

extension Coordinate {
    
    public enum Rotation {
        
        case clockwise
        case counterClockwise
    }
    
    public func rotate(rotation: Rotation) -> Self { rotation == .clockwise ? Coordinate(z, x, y) : Coordinate(y, z, x) }
}

extension Coordinate {
    
    //
    //  Directly connected adjacent vertices that share an edge.
    //
    //                  x-------x
    //                /   \   /   \
    //              x-------x-------x
    //                \   /   \   /
    //                  x-------x
    //
    
    public var adjacent: [Coordinate] { [self + (.unitX + -.unitZ),
                                         self + (.unitX + -.unitY),
                                         self + (-.unitY + .unitZ),
                                         self + (-.unitX + .unitZ),
                                         self + (-.unitX + .unitY),
                                         self + (.unitY + -.unitZ)] }
    
    //
    //  Directly connected adjacent triangles that share an vertex.
    //
    //                  ---------
    //                / x \ x / x \
    //               ------- -------
    //                \ x / x \ x /
    //                  ---------
    //
    
    public var triangles: [Grid.Triangle] { [.init(self + -(.unitY + .unitZ)),
                                             .init(self + -.unitY),
                                             .init(self + -(.unitX + .unitY)),
                                             .init(self + -.unitX),
                                             .init(self + -(.unitX + .unitZ)),
                                             .init(self + -.unitZ)] }
}
