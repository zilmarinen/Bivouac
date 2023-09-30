//
//  TerrainType.swift
//
//  Created by Zack Brown on 01/09/2023.
//

import Foundation

public enum TerrainType: Int,
                         CaseIterable,
                         Identifiable {
    
    case boreal
    case chaparral
    case deciduous
    case prairie
    case rainforest
    case scrubland
    case tundra
    
    public var id: String {
        
        switch self {
            
        case .boreal: return "Boreal"
        case .chaparral: return "Chaparral"
        case .deciduous: return "Deciduous"
        case .prairie: return "Prairie"
        case .rainforest: return "Rainforest"
        case .scrubland: return "Scrubland"
        case .tundra: return "Tundra"
        }
    }
    
    public var transitions: [TerrainType] {
        
        switch self {
            
        case .boreal: return [.chaparral, .deciduous, .tundra]
        case .chaparral: return [.boreal, .prairie, .scrubland]
        case .deciduous: return [.boreal, .rainforest, .scrubland]
        case .prairie: return [.chaparral]
        case .rainforest: return [.deciduous]
        case .scrubland: return [.chaparral, .deciduous]
        case .tundra: return [.boreal]
        }
    }
}
