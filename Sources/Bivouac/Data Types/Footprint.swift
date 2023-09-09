//
//  Footprint.swift
//
//  Created by Zack Brown on 26/08/2023.
//

extension Grid {
    
    //
    //  Footprint defines a grouping of coordinates centered
    //  around a specified origin.
    //
    
    public struct Footprint {
        
        public let origin: Grid.Triangle
        
        public let coordinates: [Coordinate]
        
        public init(origin: Coordinate,
                    coordinates: [Coordinate]) {
            
            self.init(origin: Triangle(origin),
                      coordinates: coordinates)
        }
        
        public init(origin: Coordinate,
                    area: Area) {
            
            self.init(origin: origin,
                      coordinates: area.footprint)
        }
        
        public init(origin: Triangle,
                    coordinates: [Coordinate]) {
            
            self.origin = origin
            self.coordinates = coordinates.map { origin.position + (origin.isPointy ? $0 : -$0) }
        }
    }
}

extension Grid.Footprint {
 
    public func rotate(rotation: Coordinate.Rotation) -> Self {
        
        let footprint = coordinates.map {  (origin.isPointy ? $0 - origin.position : -($0 - origin.position)) }
        
        return Grid.Footprint(origin: origin.position,
                              coordinates: footprint.rotate(rotation: rotation))
    }
    
    public func intersects(rhs: Grid.Footprint) -> Bool {
        
        for coordinate in rhs.coordinates {
            
            if intersects(rhs: coordinate) { return true }
        }
        
        return false
    }
    
    public func intersects(rhs: Coordinate) -> Bool { coordinates.contains(rhs) }
}

extension Grid.Footprint {
    
    public enum Area: CaseIterable,
                      Identifiable {
        
        case triangle
        case triangleLarge
        case rhombus
        case star
        case hexagon
        case hexagonLarge
        case trapezium
        
        public var id: String {
            
            switch self {
                
            case .triangle: return "Triangle"
            case .triangleLarge: return "Large Triangle"
            case .rhombus: return "Rhombus"
            case .star: return "Star"
            case .hexagon: return "Hexagon"
            case .hexagonLarge: return "Large Hexagon"
            case .trapezium: return "Trapezium"
            }
        }
        
        public var footprint: [Coordinate] {
            
            let origin = Grid.Triangle(.zero)
            let adjacent = Grid.Triangle(origin.adjacent(along: .x))
            let diagonal = Grid.Triangle(origin.diagonal(along: .x))
            
            switch self {
                
            case .triangle: return [origin.position]
            case .triangleLarge: return [origin.position] + origin.adjacent
            case .rhombus: return [origin.position,
                                   adjacent.position]
            case .star: return origin.adjacent + adjacent.adjacent
            case .hexagon: return [origin.position,
                                   origin.adjacent(along: .y),
                                   origin.adjacent(along: .z),
                                   diagonal.position,
                                   diagonal.adjacent(along: .y),
                                   diagonal.adjacent(along: .z)]
            case .hexagonLarge: return Array(Set(Area.hexagon.footprint.flatMap { Grid.Triangle($0).perimeter }))
            case .trapezium: return [origin.position] + origin.perimeter
            }
        }
    }
}
