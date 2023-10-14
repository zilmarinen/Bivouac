//
//  SCNProgram.swift
//
//  Created by Zack Brown on 13/10/2023.
//

import Foundation
import SceneKit

extension SCNProgram: Identifiable {
    
    public var id: String { "[Fragment: \(fragmentShader ?? ""), Vertex: \(vertexShader ?? "")]" }
    
    public convenience init(named name: String,
                            delegate: SCNProgramDelegate? = nil) {
        
        self.init()
        
        let prefix = name.lowercased().replacingOccurrences(of: " ", with: "_")
        
        self.fragmentFunctionName = "\(prefix)_fragment"
        self.vertexFunctionName = "\(prefix)_vertex"
        self.delegate = delegate ?? self
        self.library = SCNProgram.makeBivouacLibrary()
    }
}

extension SCNProgram {
    
    static func makeBivouacLibrary() -> MTLLibrary? {
        
        do {
            
            return try MTLCreateSystemDefaultDevice()?.makeDefaultLibrary(bundle: Bundle.module)
        }
        catch {
            
            fatalError(error.localizedDescription)
        }
    }
}

extension SCNProgram: SCNProgramDelegate {
    
    public func program(_ program: SCNProgram,
                        handleError error: Error) {
        
        fatalError("SCNProgram error \(id): \(error.localizedDescription)")
    }
}
