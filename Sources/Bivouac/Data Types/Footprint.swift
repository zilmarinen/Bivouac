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
        
        let coordinate: Coordinate
        
        let triangles: [Triangle]
        
        let rotation: Axis
    }
}
