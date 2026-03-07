//
//  Septomino.swift
//  Bivouac
//
//  Created by Zack Brown on 13/09/2025.
//

import Deltille

extension Triangle {
    
    public enum Septomino: String,
                           CaseIterable,
                           Codable,
                           Identifiable,
                           Sendable {
        
        case antlia
        case auriga
        case bootes
        case cepheus
        case cygnus
        case delphinus
        case eridanus
        case fornax
        case grus
        case horologium
        case indus
        case lacerta
        case lyra
        case musca
        case norma
        case ophiuchus
        case pictor
        case pyxis
        case reticulum
        case scorpius
        case serpens
        case triangulum
        case vela
        case volans
        
        public var id: String { rawValue.capitalized }
        
        public var coordinates: [Coordinate] {
            
            switch self {
                
            case .antlia: [.init(-1, 2, -1),
                           .init(-1, 1, -1),
                           .init(-1, 1, 0),
                           .init(-1, 0, 0),
                           .init(-1, 0, 1),
                           .init(-1, -1, 1),
                           .init(-1, -1, 2)]
                
            case .auriga: [.init(1, -1, -1),
                           .init(1, 0, -1),
                           .init(0, 0, -1),
                           .init(0, 1, -1),
                           .zero,
                           .init(-1, 0, 0),
                           .init(-1, 0, 1)]
                
            case .bootes: [.init(0, 0, -1),
                           .zero,
                           .init(-1, 1, -1),
                           .init(-1, 1, 0),
                           .init(-1, 0, 0),
                           .init(-1, 0, 1),
                           .init(-1, -1, 1)]
                
            case .cepheus: [.init(1, -1, 0),
                            .init(0, -1, 0),
                            .zero,
                            .init(0, 1, -1),
                            .init(0, 0, -1),
                            .init(-1, 0, 0),
                            .init(-1, 0, 1)]
                
            case .cygnus: [.zero,
                           .init(-1, 1, -1),
                           .init(-1, 1, 0),
                           .init(-1, 0, 0),
                           .init(-1, 0, 1),
                           .init(-1, -1, 1),
                           .init(-1, -1, 2)]
                
            case .delphinus: [.init(0, 1, -1),
                              .init(-1, 2, -1),
                              .init(-1, 1, -1),
                              .init(-1, 1, 0),
                              .init(-1, 0, 0),
                              .init(-1, 0, 1),
                              .init(-1, -1, 1)]
                
            case .eridanus: [.init(-1, 2, -1),
                             .init(-1, 1, -1),
                             .init(-1, 1, 0),
                             .init(-1, 0, 0),
                             .init(-1, 0, 1),
                             .init(-1, -1, 1),
                             .init(0, -1, 1)]
                
            case .fornax: [.init(0, 0, -1),
                           .init(0, 1, -1),
                           .init(-1, 1, -1),
                           .init(-1, 1, 0),
                           .init(-1, 0, 0),
                           .init(-1, 0, 1),
                           .init(-1, -1, 1)]
                
            case .grus: [.init(0, 1, -1),
                         .init(0, 0, -1),
                         .zero,
                         .init(-1, 0, 0),
                         .init(-1, 0, 1),
                         .init(-1, -1, 1),
                         .init(0, -1, 1)]
                
            case .horologium: [.init(0, 1, -1),
                               .init(0, 0, -1),
                               .init(1, 0, -1),
                               .init(1, -1, -1),
                               .init(1, -1, 0),
                               .init(0, -1, 0),
                               .init(0, -1, 1)]
                
            case .indus: [.init(-1, 1, -1),
                          .init(0, 1, -1),
                          .init(0, 0, -1),
                          .zero,
                          .init(0, -1, 0),
                          .init(0, -1, 1),
                          .init(-1, -1, 1)]
                
            case .lacerta: [.init(1, -1, 0),
                            .init(0, -1, 0),
                            .zero,
                            .init(0, 0, -1),
                            .init(-1, 1, 0),
                            .init(-1, 0, 0),
                            .init(-1, 0, 1)]
                
            case .lyra: [.init(-1, 2, -1),
                         .init(-1, 1, -1),
                         .init(0, 1, -1),
                         .init(0, 0, -1),
                         .zero,
                         .init(0, -1, 0),
                         .init(0, -1, 1)]
                
            case .musca: [.init(1, 0, -1),
                          .init(0, 0, -1),
                          .init(0, 1, -1),
                          .zero,
                          .init(1, -1, 0),
                          .init(0, -1, 0),
                          .init(0, -1, 1)]
                
            case .norma: [.init(0, 1, -1),
                          .init(0, 0, -1),
                          .zero,
                          .init(0, -1, 0),
                          .init(-1, 0, 0),
                          .init(-1, 0, 1),
                          .init(-1, -1, 1)]
                
            case .ophiuchus: [.init(0, 0, -1),
                              .zero,
                              .init(0, -1, 0),
                              .init(0, -1, 1),
                              .init(-1, -1, 1),
                              .init(-1, 0, 0),
                              .init(-1, 0, 1)]
                
            case .pictor: [.init(0, 0, -1),
                           .zero,
                           .init(0, -1, 0),
                           .init(0, -1, 1),
                           .init(-1, -1, 1),
                           .init(-1, 0, 0),
                           .init(-1, 1, 0)]
                
            case .pyxis: [.init(0, 1, -1),
                          .init(0, 0, -1),
                          .init(1, 0, -1),
                          .init(1, -1, -1),
                          .init(2, -1, -1),
                          .init(1, -1, 0),
                          .init(0, -1, 0)]
                
            case .reticulum: [.init(1, 0, -1),
                              .init(0, 0, -1),
                              .init(0, 1, -1),
                              .zero,
                              .init(0, -1, 0),
                              .init(0, -1, 1),
                              .init(-1, -1, 1)]
                
            case .scorpius: [.init(0, 1, -1),
                             .init(-1, 1, -1),
                             .init(-1, 1, 0),
                             .init(-1, 0, 0),
                             .zero,
                             .init(-1, 0, 1),
                             .init(-1, -1, 1)]
                
            case .serpens: [.init(0, 0, -1),
                            .zero,
                            .init(1, -1, 0),
                            .init(0, -1, 0),
                            .init(0, -1, 1),
                            .init(-1, -1, 1),
                            .init(-1, -1, 2)]
                
            case .triangulum: [.init(0, 0, -1),
                               .zero,
                               .init(0, -1, 0),
                               .init(-1, 1, 0),
                               .init(-1, 0, 0),
                               .init(-1, 0, 1),
                               .init(-1, -1, 1)]
                
            case .vela: [.init(0, -1, 0),
                         .zero,
                         .init(0, 0, -1),
                         .init(0, 1, -1),
                         .init(-1, 2, -1),
                         .init(-1, 1, -1),
                         .init(-1, 1, 0)]
                
            case .volans: [.init(-1, 2, -1),
                           .init(-1, 1, -1),
                           .init(0, 1, -1),
                           .init(0, 0, -1),
                           .zero,
                           .init(0, -1, 0),
                           .init(1, -1, 0)]
            }
        }
    }
}
