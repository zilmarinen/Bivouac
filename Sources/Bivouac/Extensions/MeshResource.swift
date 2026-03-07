//
//  MeshResource.swift
//  Bivouac
//
//  Created by Zack Brown on 07/03/2026.
//

import Euclid
import RealityKit

extension MeshResource {

    public convenience init(mesh: Mesh) {

        do {
            
            try self.init(from: LowLevelMesh(mesh))
        }
        catch {
            
            fatalError("Error creating MeshResource from Mesh")
        }
    }
}

