//
//  Kite.swift
//
//  Created by Zack Brown on 31/08/2023.
//

import Foundation

extension Grid.Triangle {
    
    public enum Kite: Int,
                      CaseIterable,
                      Identifiable {
        
        case delta
        case epsilon
        case gamma
        case kappa
        case lambda
        case omega
        case phi
        case psi
        case sigma
        
        public static var uniform = Kite.kappa
        
        public static let apex = Double(Grid.Scale.tile.rawValue) / 10.0
        public static let base = Double(Grid.Scale.tile.rawValue) / 2.0
        
        public var id: String {
            
            switch self {
                
            case .delta: return "Delta"
            case .epsilon: return "Epsilon"
            case .gamma: return "Gamma"
            case .kappa: return "Kappa"
            case .lambda: return "Lambda"
            case .omega: return "Omega"
            case .phi: return "Phi"
            case .psi: return "Psi"
            case .sigma: return "Sigma"
            }
        }
        
        public var vertices: [Stencil.Vertex] {
            
            switch self {
                
            case .delta: return [.v0, .v5, .v7]
            case .epsilon: return [.v0, .v5, .center, .v7]
            case .gamma: return [.v0, .v5, .v6, .v9, .v10, .v7]
            case .kappa: return [.v0, .v1, .v2]
            case .lambda: return [.v0, .v5, .v9, .v10, .v6, .v7]
            case .omega: return [.v0, .v5, .v9, .v10, .v7]
            case .phi: return [.v0, .v5, .v6, .v10, .v7]
            case .psi: return [.v0, .v5, .v9, .v6, .v7]
            case .sigma: return [.v0, .v5, .v9, .v6, .v10, .v7]
            }
        }
    }
    
    public var pattern: Grid.Triangle.Kite.Pattern { Grid.Triangle.Kite.Pattern.allCases[abs(position.index) % Grid.Triangle.Kite.Pattern.allCases.count] }
    public var kites: [Grid.Triangle.Kite] { pattern.kites.rotate(times: position.sumAbs) }
}

extension Grid.Triangle.Kite {
    
    public enum Pattern: Int,
                         CaseIterable,
                         Identifiable {
        
        case descartes
        case euclid
        case euler
        case gauss
        case mobius
        case pascal
        case thales
        
        public var id: String {
            
            switch self {
                
            case .descartes: return "Descartes"
            case .euclid: return "Euclid"
            case .euler: return "Euler"
            case .gauss: return "Gauss"
            case .mobius: return "Mobius"
            case .pascal: return "Pascal"
            case .thales: return "Thales"
            }
        }
        
        public var kites: [Grid.Triangle.Kite] {
            
            switch self {
                
            case .descartes: return [.epsilon, .epsilon, .epsilon]
            case .euclid: return [.lambda, .delta, .sigma]
            case .euler: return [.psi, .delta, .omega]
            case .gauss: return [.lambda, .psi, .psi]
            case .mobius: return [.delta, .gamma, .sigma]
            case .pascal: return [.phi, .gamma, .phi]
            case .thales: return [.delta, .phi, .omega]
            }
        }
    }
}
