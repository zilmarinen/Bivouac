//
//  Mesh.swift
//
//  Created by Zack Brown on 12/10/2023.
//

import Euclid
import Foundation

extension Mesh {
    
    public struct Profile {
        
        public let polygonCount: Int
        public let vertexCount: Int
        
        public init(polygonCount: Int,
                    vertexCount: Int) {
         
            self.polygonCount = polygonCount
            self.vertexCount = vertexCount
        }
    }
    
    public var profile: Profile { .init(polygonCount: polygons.count,
                                        vertexCount: polygons.reduce(into: Int(), { $0 += $1.vertices.count } )) }
}

extension Mesh {
    
    public static func bone(start: Vector,
                            end: Vector,
                            sides: Int = 5,
                            color: Color) throws -> Mesh {
        
        guard let line = LineSegment(start,
                                     end) else { throw MeshError.invalidLineSegment }
        
        let sides = max(3, sides)
        let step = (.pi2 / Double(sides))
        let radius = line.length * 0.05
        let direction = line.direction
        let base = line.start.lerp(line.end, 0.1)
        let apex = line.end.lerp(line.start, 0.1)
        let anchor = base.lerp(apex, 0.1)
        let perpendicular = direction.perpendicular.normalized()
        let binormal = direction.cross(perpendicular)
        
        var polygons: [Euclid.Polygon] = []
        
        for i in 0..<sides {
            
            let iStep = step * Double(i)
            let jStep = step * Double((i + 1) % sides)
            
            let v0 = anchor + radius * perpendicular * cos(iStep) + radius * binormal * sin(iStep)
            let v1 = anchor + radius * perpendicular * cos(jStep) + radius * binormal * sin(jStep)
            
            let top = Face([line.start,
                            v1,
                            v0],
                            color: color)
            
            let bottom = Face([v0,
                               v1,
                               line.end],
                               color: color)
            
            try polygons.glue(top?.polygon)
            try polygons.glue(bottom?.polygon)
        }
        
        return Mesh(polygons)
    }
}
