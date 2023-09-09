//
//  ArchitectureType.swift
//
//  Created by Zack Brown on 08/09/2023.
//

import Foundation

public enum ArchitectureType: Int,
                              CaseIterable,
                              Identifiable {

    case bernina
    case daisen
    case elna
    case juki
    case merrow
    case necchi
    case singer
    
    public var id: String {
        
        switch self {
            
        case .bernina: return "Bernina"
        case .daisen: return "Daisen"
        case .elna: return "Elna"
        case .juki: return "Juki"
        case .merrow: return "Merrow"
        case .necchi: return "Necchi"
        case .singer: return "Singer"
        }
    }
}
