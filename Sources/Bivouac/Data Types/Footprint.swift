//
//  Footprint.swift
//
//  Created by Zack Brown on 26/08/2023.
//

extension Grid {
    
    //
    //  Footprint defines a grouping of triangles centered around
    //  a specified coordinate rotated to align with a given axis.
    //
    
    public struct Footprint {
        
        public let origin: Coordinate
        
        public let coordinates: [Coordinate]
        
        public let rotation: Axis
        
        init(origin: Coordinate,
             coordinates: [Coordinate],
             rotation: Axis = .x) {
            
            self.origin = origin
            self.coordinates = coordinates.rotate(toward: rotation).map { origin + $0 }
            self.rotation = rotation
        }
        
        init(origin: Coordinate,
             area: Area,
             rotation: Axis = .x) {
            
            self.init(origin: origin,
                      coordinates: area.footprint,
                      rotation: rotation)
        }
    }
}

extension Grid.Footprint {
    
    public enum Area {
        
        case triangle
        case trianglePerimeter
        case rhombus
        case star
        case hexagon
        case hexagonPerimeter
        case trapezium
        
        public var footprint: [Coordinate] {
            
            let origin = Grid.Triangle(.zero)
            let xAdjacent = Grid.Triangle(origin.adjacent(along: .x))
            let xDiagonal = Grid.Triangle(origin.diagonal(along: .x))
            
            switch self {
                
            case .triangle: return [origin.coordinate]
            case .trianglePerimeter: return [origin.coordinate] + origin.adjacent
            case .rhombus: return [origin.coordinate,
                                   xAdjacent.coordinate]
            case .star: return origin.adjacent + xAdjacent.adjacent
            case .hexagon: return [origin.coordinate,
                                   origin.adjacent(along: .y),
                                   origin.adjacent(along: .z),
                                   xDiagonal.coordinate,
                                   xDiagonal.adjacent(along: .y),
                                   xDiagonal.adjacent(along: .z)]
            case .hexagonPerimeter: return Array(Set(Area.hexagon.footprint.flatMap { Grid.Triangle($0).perimeter }))
            case .trapezium: return [origin.coordinate] + origin.perimeter
            }
        }
    }
}
