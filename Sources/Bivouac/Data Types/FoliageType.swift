//
//  FoliageType.swift
//
//  Created by Zack Brown on 04/09/2023.
//

import Foundation

public enum FoliageType: Int,
                         CaseIterable,
                         Identifiable {

    case cherryBlossom
    case chicle
    case goldenGingko
    case jacaranda
    case linden
    case spruce
    case thujaOccidentalis
    
    public var id: String {
        
        switch self {
            
        case .cherryBlossom: return "Cherry Blossom"
        case .chicle: return "Chicle"
        case .goldenGingko: return "Golden Gingko"
        case .jacaranda: return "Jacaranda"
        case .linden: return "Linden"
        case .spruce: return "Spruce"
        case .thujaOccidentalis: return "Thuja Occidentalis"
        }
    }
    
    public var area: Grid.Footprint.Area {
        
        switch self {
            
        case .cherryBlossom: return .truchet
        case .chicle: return .pinwheel
        case .goldenGingko: return .penrose
        case .jacaranda: return .wang
        case .linden: return .snub
        case .spruce: return .floret
        case .thujaOccidentalis: return .voronoi
        }
    }
}
