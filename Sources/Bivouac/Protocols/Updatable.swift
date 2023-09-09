//
//  Updatable.swift
//
//  Created by Zack Brown on 09/09/2023.
//

import Foundation

internal protocol Updatable {
    
    func update(delta: TimeInterval,
                time: TimeInterval)
}
