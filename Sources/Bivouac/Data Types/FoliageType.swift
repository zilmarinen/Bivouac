//
//  FoliageType.swift
//
//  Created by Zack Brown on 04/09/2023.
//

import Foundation

public enum FoliageType: Int,
                         CaseIterable,
                         Identifiable {

    case bamboo
    case cherryBlossom
    case goldenGingko
    case jacaranda
    case thujaOccidentalis
    
    public var id: String {
        
        switch self {
            
        case .bamboo: return "Bamboo"
        case .cherryBlossom: return "Cherry Blossom"
        case .goldenGingko: return "Golden Gingko"
        case .jacaranda: return "Jacaranda"
        case .thujaOccidentalis: return "Thuja Occidentalis"
        }
    }
}
