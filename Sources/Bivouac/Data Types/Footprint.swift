//
//  Footprint.swift
//
//  Created by Zack Brown on 26/08/2023.
//

import Euclid

extension Grid {
    
    //
    //  Footprint defines a grouping of coordinates centered
    //  around a specified origin.
    //
    
    public struct Footprint {
        
        public let origin: Grid.Triangle
        
        public let coordinates: [Coordinate]
        
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
        
        return Grid.Footprint(origin: origin,
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
