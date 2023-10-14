//
//  Septomino.swift
//
//  Created by Zack Brown on 24/09/2023.
//

extension Grid.Triangle {
    
    public enum Septomino: Int,
                           CaseIterable,
                           Identifiable {
        
        case alcyone
        case asterope
        case atlas
        case celaeno
        case electra
        case maia
        case merope
        case pleione
        case sterope
        case taygeta
        
        public var id: String {
            
            switch self {
                
            case .alcyone: return "Alcyone"
            case .asterope: return "Asterope"
            case .atlas: return "Atlas"
            case .celaeno: return "Celaeno"
            case .electra: return "Electra"
            case .maia: return "Maia"
            case .merope: return "Merope"
            case .pleione: return "Pleione"
            case .sterope: return "Sterope"
            case .taygeta: return "Taygeta"
            }
        }
        
        public var footprint: [Coordinate] {
            
            switch self {
                
            case .alcyone: return [Coordinate(0, 0, 0),
                                   Coordinate(0, 0, -1),
                                   Coordinate(1, 0, -1),
                                   Coordinate(1, 0, -2),
                                   Coordinate(2, 0, -2),
                                   Coordinate(2, 0, -3),
                                   Coordinate(3, 0, -3)]
                
            case .asterope: return [Coordinate(0, 0, 0),
                                    Coordinate(0, 0, -1),
                                    Coordinate(1, 0, -1),
                                    Coordinate(1, 0, -2),
                                    Coordinate(2, 0, -2),
                                    Coordinate(1, -1, -1),
                                    Coordinate(1, 1, -2)]
                        
            case .atlas: return [Coordinate(0, 0, 0),
                                 Coordinate(-1, 0, 0),
                                 Coordinate(-1, 1, 0),
                                 Coordinate(-2, 1, 0),
                                 Coordinate(-2, 1, 1),
                                 Coordinate(-2, 0, 1),
                                 Coordinate(-1, 0, 1)]
                
            case .celaeno: return [Coordinate(0, 0, 0),
                                   Coordinate(0, 0, -1),
                                   Coordinate(1, 0, -1),
                                   Coordinate(1, 0, -2),
                                   Coordinate(2, 0, -2),
                                   Coordinate(1, 1, -2),
                                   Coordinate(2, -1, -2)]
                
            case .electra: return [Coordinate(-1, 0, 0),
                                   Coordinate(0, 0, 0),
                                   Coordinate(0, 0, -1),
                                   Coordinate(1, 0, -1),
                                   Coordinate(1, 0, -2),
                                   Coordinate(1, 1, -2),
                                   Coordinate(1, 1, -3),]
                
            case .maia: return [Coordinate(0, 0, 0),
                                Coordinate(0, 0, -1),
                                Coordinate(1, 0, -1),
                                Coordinate(1, 0, -2),
                                Coordinate(2, 0, -2),
                                Coordinate(0, -1, 0),
                                Coordinate(1, 1, -2)]
                
            case .merope: return [Coordinate(0, 0, 0),
                                  Coordinate(0, 0, -1),
                                  Coordinate(1, 0, -1),
                                  Coordinate(1, 0, -2),
                                  Coordinate(2, 0, -2),
                                  Coordinate(-1, 0, 0),
                                  Coordinate(1, -1, -1)]

            case .pleione: return [Coordinate(-1, 0, 0),
                                   Coordinate(0, 0, 0),
                                   Coordinate(0, 0, -1),
                                   Coordinate(1, 0, -1),
                                   Coordinate(1, 0, -2),
                                   Coordinate(1, 1, -2),
                                   Coordinate(-1, 1, 0)]
                
            case .sterope: return [Coordinate(0, 0, 0),
                                   Coordinate(0, 0, -1),
                                   Coordinate(1, 0, -1),
                                   Coordinate(0, 1, -1),
                                   Coordinate(-1, 1, -1),
                                   Coordinate(-1, 2, -1),
                                   Coordinate(-2, 2, -1)]
                
            case .taygeta: return [Coordinate(-1, 0, 0),
                                   Coordinate(0, 0, 0),
                                   Coordinate(0, -1, 0),
                                   Coordinate(0, -1, 1),
                                   Coordinate(0, -2, 1),
                                   Coordinate(1, -2, 1),
                                   Coordinate(1, -3, 1)]
            }
        }
    }
}
