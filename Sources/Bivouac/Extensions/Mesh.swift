//
//  Mesh.swift
//  Bivouac
//
//  Created by Zack Brown on 29/09/2025.
//

import Euclid
import RealityKit

// MARK: Mesh Descriptor

extension Mesh {
    
    internal struct Descriptor {
        
        internal let vertices: [LowLevelMesh.Vertex]
        internal let indices: [UInt32]
    }
    
    internal var descriptor: Descriptor {
        
        var vertices: [LowLevelMesh.Vertex] = []
        var indices: [UInt32] = []
        var vertexIndices = [Vertex: UInt32]()
        
        let pbm = polygonsByMaterial
        
        for (_, material) in materials.enumerated() {
            
            let polygons = pbm[material] ?? []
            
            let tessellated = polygons.flatMap {
                
                $0.tessellate(maxSides: 3)
            }
            
            for polygon in tessellated {
                
                for vertex in polygon.vertices {
                    
                    if let index = vertexIndices[vertex] {
                        
                        indices.append(index)
                        
                        continue
                    }
                    
                    let index = UInt32(vertexIndices.count)
                    
                    vertexIndices[vertex] = index
                    
                    indices.append(index)
                    
                    vertices.append(.init(position: .init(vertex.position),
                                          normal: .init(vertex.normal),
                                          color: .init(vertex.color)))
                    
                }
            }
        }
        
        return .init(vertices: vertices,
                     indices: indices)
    }
}

// MARK: Surface

public extension Mesh {
    
    static func surface(_ vectors: [Vector],
                        _ color: Color) -> Self? {
        
        guard let surface = Polygon.surface(vectors,
                                            color) else { return nil }
        
        return Mesh([surface])
    }
}
