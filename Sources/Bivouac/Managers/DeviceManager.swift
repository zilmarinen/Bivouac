//
//  DeviceManager.swift
//
//  Created by Zack Brown on 24/11/2023.
//

import Dependencies
import Foundation
import SceneKit

public final class DeviceManager: DependencyKey {
    
    public enum DeviceError: Error {
        
        case invalidDevice
        case invalidTechnique
    }
    
    public static var liveValue = DeviceManager()
    
    private let device: MTLDevice
    public var library: MTLLibrary? { technique?.library }
    public var technique: SCNTechnique?
    
    init() {
        
        do {
            
            guard let device = MTLCreateSystemDefaultDevice() else { throw DeviceError.invalidDevice }
            guard let path = Bundle.module.path(forResource: "Technique", ofType: "plist"),
                  let dictionary = NSDictionary(contentsOfFile: path) as? [String: AnyObject],
                  let technique = SCNTechnique(dictionary: dictionary) else { throw DeviceError.invalidTechnique }
            
            technique.library = try device.makeDefaultLibrary(bundle: .module)
            
            self.device = device
            self.technique = technique
        }
        catch { fatalError(error.localizedDescription) }
    }
}
