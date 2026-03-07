//
//  LowLevelMesh.swift
//  Bivouac
//
//  Created by Zack Brown on 07/03/2026.
//

import Euclid
import RealityKit

extension LowLevelMesh {
    
    internal convenience init(_ mesh: Mesh) throws {
        
        let profile = mesh.descriptor
        
        try self.init(descriptor: .init(vertexCapacity: profile.vertices.count,
                                        vertexAttributes: Vertex.attributes,
                                        vertexLayouts: Vertex.layouts,
                                        indexCapacity: profile.indices.count,
                                        indexType: .uint32))
        
        withUnsafeMutableBytes(bufferIndex: 0) { bytes in
            
            let vertices = bytes.bindMemory(to: Vertex.self)
            
            for index in profile.vertices.indices {
                
                vertices[index] = profile.vertices[index]
            }
        }
        
        withUnsafeMutableIndices { bytes in
            
            let indices = bytes.bindMemory(to: UInt32.self)
            
            for index in profile.indices.indices {
                
                indices[Int(index)] = profile.indices[Int(index)]
            }
        }
        
        parts.replaceAll([.init(indexCount: profile.indices.count,
                                topology: .triangle,
                                bounds: .init(mesh.bounds))])
    }
}

extension LowLevelMesh {
    
    internal struct Vertex {
        
        internal let position: SIMD3<Float>
        internal let normal: SIMD3<Float>
        internal let color: SIMD4<Float>
    }
}

extension LowLevelMesh.Vertex {
    
    internal static let attributes: [LowLevelMesh.Attribute] = [
        
        .init(semantic: .position,
              format: .float3,
              offset: MemoryLayout<Self>.offset(of: \.position) ?? 0),
        
        .init(semantic: .normal,
              format: .float3,
              offset: MemoryLayout<Self>.offset(of: \.normal) ?? 0),
        
        .init(semantic: .color,
              format: .float4,
              offset: MemoryLayout<Self>.offset(of: \.color) ?? 0)
    ]
    
    internal static let layouts: [LowLevelMesh.Layout] = [
        
        .init(bufferIndex: 0,
              bufferStride: MemoryLayout<Self>.stride)
    ]
}
