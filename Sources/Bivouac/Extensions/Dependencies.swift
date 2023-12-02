//
//  Dependencies.swift
//
//  Created by Zack Brown on 24/11/2023.
//

import Dependencies
import Foundation

extension DependencyValues {
    
    public var deviceManager: DeviceManager {
        
        get { self[DeviceManager.self] }
        set { self[DeviceManager.self] = newValue }
    }
}
