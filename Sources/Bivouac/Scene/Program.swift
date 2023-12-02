//
//  Program.swift
//
//  Created by Zack Brown on 13/10/2023.
//

import Dependencies
import Foundation
import SceneKit

public final class Program: SCNProgram,
                            Identifiable {
    
    @Dependency(\.deviceManager) var deviceManager
    
    public enum Function: String,
                          Identifiable {
        
        case surface
        case technique
        
        public var id: String { rawValue }
    }
    
    public var id: String { "[Fragment: \(fragmentShader ?? ""), Vertex: \(vertexShader ?? "")]" }
    
    public convenience init(function: Function,
                            delegate: SCNProgramDelegate? = nil) {
        
        self.init(named: function.id,
                  delegate: delegate)
    }
    
    public convenience init(named name: String,
                            delegate: SCNProgramDelegate? = nil) {
        
        self.init()
        
        let prefix = name.lowercased().replacingOccurrences(of: " ", with: "_")
        
        self.fragmentFunctionName = "\(prefix)_fragment"
        self.vertexFunctionName = "\(prefix)_vertex"
        self.delegate = delegate ?? self
        self.library = deviceManager.library
    }
}

extension Program: SCNProgramDelegate {
    
    public func program(_ program: SCNProgram,
                        handleError error: Error) { fatalError("Program error \(id): \(error.localizedDescription)") }
}
