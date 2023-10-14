//
//  Mesh.swift
//
//  Created by Zack Brown on 12/10/2023.
//

import Euclid

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
