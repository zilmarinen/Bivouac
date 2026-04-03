//
//  Kite.swift
//  Bivouac
//
//  Created by Zack Brown on 13/03/2026.
//

import Deltille
import Euclid

extension Triangle {
    
    public enum Kite: String,
                      CaseIterable,
                      Identifiable,
                      Sendable {
        
        public static let uniform = Kite.delta
        
        case delta
        case epsilon
        case gamma
        case iota
        case kappa
        case lambda
        case omega
        case omicron
        case phi
        case psi
        case sigma
        
        public var id: String { rawValue.capitalized }
        
        public var divisions: [Stencil.Division] {
            
            switch self {
                
            case .delta: Stencil.Division.allCases
            case .epsilon: [.d0, .d1, .d2, .d3, .d7, .d8, .d9, .d10]
            case .gamma: [.d0, .d1, .d2, .d7, .d8, .d9]
            case .iota: [.d0, .d1, .d2, .d7, .d8, .d9, .d10]
            case .kappa: [.d0, .d1, .d2, .d7]
            case .lambda: [.d0, .d1, .d2, .d3, .d7, .d9]
            case .omega: [.d0, .d1, .d2, .d3, .d7, .d8, .d9]
            case .omicron: [.d0, .d1, .d2, .d3, .d7, .d9, .d10]
            case .phi: [.d0, .d1, .d2, .d3, .d7]
            case .psi: [.d0, .d1, .d2, .d7, .d8]
            case .sigma: [.d0, .d1, .d2, .d3, .d7, .d8]
            }
        }
        
        public var vertices: [Stencil.Vertex] {
                    
            switch self {
                
            case .delta: [.v0, .v1, .v2]
            case .epsilon: [.v0, .v5, .v9, .v13, .v10, .v7]
            case .gamma: [.v0, .v5, .v6, .v9, .v10, .v7]
            case .iota: [.v0, .v5, .v6, .v9, .v13, .v10, .v7]
            case .kappa: [.v0, .v5, .v6, .v7]
            case .lambda: [.v0, .v5, .v9, .v10, .v6, .v7]
            case .omega: [.v0, .v5, .v9, .v10, .v7]
            case .omicron: [.v0, .v5, .v9, .v13, .v10, .v6, .v7]
            case .phi: [.v0, .v5, .v9, .v6, .v7]
            case .psi: [.v0, .v5, .v6, .v10, .v7]
            case .sigma: [.v0, .v5, .v9, .v6, .v10, .v7]
            }
        }
    }
}

extension Triangle.Kite {
    
    public enum Pattern: String,
                         CaseIterable,
                         Identifiable,
                         Sendable {
        
        case descartes
        case euclid
        case euler
        case gauss
        case lovelace
        case mobius
        case nightingale
        case pascal
        case thales
        
        public var id: String { rawValue.capitalized }
        
        public var kites: [Triangle.Kite] {
                    
            switch self {
                
            case .descartes: [.epsilon, .kappa, .kappa]
            case .euclid: [.gamma, .sigma, .kappa]
            case .euler: [.lambda, .phi, .phi]
            case .gauss: [.omega, .phi, .kappa]
            case .lovelace: [.iota, .psi, .kappa]
            case .mobius: [.psi, .omega, .kappa]
            case .nightingale: [.omicron, .kappa, .phi]
            case .pascal: [.psi, .psi, .gamma]
            case .thales: [.sigma, .kappa, .gamma]
            }
        }
    }
}
