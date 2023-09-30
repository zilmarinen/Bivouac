//
//  Area.swift
//
//  Created by Zack Brown on 30/09/2023.
//

import Euclid
import Foundation

extension Grid.Footprint {
    
    public enum Area: CaseIterable,
                      Identifiable {
        
        case escher
        case floret
        case penrose
        case pinwheel
        case snub
        case truchet
        case voronoi
        case wang
        
        public func center(at scale: Grid.Scale) -> Vector { footprint.map { $0.convert(to: scale) }.average }
        
        public var id: String {
            
            switch self {
                
            case .escher: return "Escher"
            case .floret: return "Floret"
            case .penrose: return "Penrose"
            case .pinwheel: return "Pinwheel"
            case .snub: return "Snub"
            case .truchet: return "Truchet"
            case .voronoi: return "Voronoi"
            case .wang: return "Wang"
            }
        }
        
        public var footprint: [Coordinate] {
            
            switch self {
                
            case .escher: return perimeter + [Coordinate(-1, 0, 0)]
            case .penrose: return perimeter + [Coordinate(1, 0, -1),
                                               Coordinate(1, 0, -2),
                                               Coordinate(2, 0, -2),
                                               Coordinate(2, -1, -2),
                                               Coordinate(2, -1, -1),
                                               Coordinate(1, -1, -1)]
            case .pinwheel: return perimeter + [Coordinate(1, 0, -1)]
            case .snub: return perimeter + [Coordinate(1, -1, -1),
                                            Coordinate(2, -1, -1)]
            case .voronoi: return perimeter + [Coordinate(1, -1, 0),
                                               Coordinate(1, -1, -1),
                                               Coordinate(2, -1, -1),
                                               Coordinate(2, -1, -2),
                                               Coordinate(3, -1, -2),
                                               Coordinate(3, -2, -2),
                                               Coordinate(3, -2, -1),
                                               Coordinate(2, -2, -1),
                                               Coordinate(2, -2, 0),
                                               Coordinate(1, -2, 0)]
            default: return perimeter
            }
        }
        
        public var perimeter: [Coordinate] {
            
            switch self {
                
            case .escher: return [Coordinate(-1, 1, 0),
                                  Coordinate(-1, 0, 1),
                                  Coordinate(0, 0, 0)]
                
            case .floret: return [Coordinate(0, -1, 0),
                                  Coordinate(1, -1, 0),
                                  Coordinate(1, -1, -1),
                                  Coordinate(1, 0, -1),
                                  Coordinate(0, 0, -1),
                                  Coordinate(0, 0, 0)]
                
            case .penrose: return [Coordinate(0, -1, 0),
                                   Coordinate(1, -1, 0),
                                   Coordinate(1, -2, 0),
                                   Coordinate(2, -2, 0),
                                   Coordinate(2, -2, -1),
                                   Coordinate(3, -2, -1),
                                   Coordinate(3, -2, -2),
                                   Coordinate(3, -1, -2),
                                   Coordinate(3, -1, -3),
                                   Coordinate(3, 0, -3),
                                   Coordinate(2, 0, -3),
                                   Coordinate(2, 1, -3),
                                   Coordinate(1, 1, -3),
                                   Coordinate(1, 1, -2),
                                   Coordinate(0, 1, -2),
                                   Coordinate(0, 1, -1),
                                   Coordinate(0, 0, -1),
                                   Coordinate(0, 0, 0)]
                
            case .pinwheel: return [Coordinate(0, -1, 0),
                                    Coordinate(1, -1, 0),
                                    Coordinate(1, -1, -1),
                                    Coordinate(2, -1, -1),
                                    Coordinate(2, -1, -2),
                                    Coordinate(2, 0, -2),
                                    Coordinate(1, 0, -2),
                                    Coordinate(1, 1, -2),
                                    Coordinate(0, 1, -2),
                                    Coordinate(0, 1, -1),
                                    Coordinate(0, 0, -1),
                                    Coordinate(0, 0, 0)]
                
            case .snub: return [Coordinate(0, -1, 0),
                                Coordinate(1, -1, 0),
                                Coordinate(1, -2, 0),
                                Coordinate(2, -2, 0),
                                Coordinate(2, -2, -1),
                                Coordinate(3, -2, -1),
                                Coordinate(3, -2, -2),
                                Coordinate(3, -1, -2),
                                Coordinate(2, -1, -2),
                                Coordinate(2, 0, -2),
                                Coordinate(1, 0, -2),
                                Coordinate(1, 0, -1),
                                Coordinate(0, 0, -1),
                                Coordinate(0, 0, 0)]
                
            case .truchet: return [Coordinate(0, -1, 0),
                                   Coordinate(1, -1, 0),
                                   Coordinate(1, -1, -1),
                                   Coordinate(2, -1, -1),
                                   Coordinate(2, -1, -2),
                                   Coordinate(2, 0, -2),
                                   Coordinate(1, 0, -2),
                                   Coordinate(1, 0, -1),
                                   Coordinate(0, 0, -1),
                                   Coordinate(0, 0, 0)]
                
            case .voronoi: return [Coordinate(0, -1, 0),
                                   Coordinate(0, -1, 1),
                                   Coordinate(0, -2, 1),
                                   Coordinate(1, -2, 1),
                                   Coordinate(1, -3, 1),
                                   Coordinate(2, -3, 1),
                                   Coordinate(2, -3, 0),
                                   Coordinate(3, -3, 0),
                                   Coordinate(3, -3, -1),
                                   Coordinate(4, -3, -1),
                                   Coordinate(4, -3, -2),
                                   Coordinate(4, -2, -2),
                                   Coordinate(4, -2, -3),
                                   Coordinate(4, -1, -3),
                                   Coordinate(3, -1, -3),
                                   Coordinate(3, 0, -3),
                                   Coordinate(2, 0, -3),
                                   Coordinate(2, 0, -2),
                                   Coordinate(1, 0, -2),
                                   Coordinate(1, 0, -1),
                                   Coordinate(0, 0, -1),
                                   Coordinate(0, 0, 0)]
                
            case .wang: return [Coordinate(0, -1, 0),
                                Coordinate(1, -1, 0),
                                Coordinate(1, -2, 0),
                                Coordinate(1, -2, 1),
                                Coordinate(1, -3, 1),
                                Coordinate(2, -3, 1),
                                Coordinate(2, -3, 0),
                                Coordinate(2, -2, 0),
                                Coordinate(2, -2, -1),
                                Coordinate(3, -2, -1),
                                Coordinate(3, -2, -2),
                                Coordinate(3, -1, -2),
                                Coordinate(2, -1, -2),
                                Coordinate(2, -1, -1),
                                Coordinate(1, -1, -1),
                                Coordinate(1, 0, -1),
                                Coordinate(0, 0, -1),
                                Coordinate(0, 0, 0)]
            }
        }
    }
}
