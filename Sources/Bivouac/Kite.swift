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
        case kappa
        case lambda
        case omega
        case phi
        case psi
        case sigma
        
        public var id: String { rawValue.capitalized }
        
        public var divisions: [Stencil.Division] {
            
            switch self {
                
            case .delta: Stencil.Division.allCases
            case .epsilon,
                 .kappa: [.d0, .d1, .d2, .d7]
            case .gamma: [.d0, .d1, .d2, .d7, .d8, .d9]
            case .lambda: [.d0, .d1, .d2, .d3, .d7, .d9]
            case .omega: [.d0, .d1, .d2, .d3, .d7, .d8, .d9]
            case .phi: [.d0, .d1, .d2, .d3, .d7]
            case .psi: [.d0, .d1, .d2, .d7, .d8]
            case .sigma: [.d0, .d1, .d2, .d3, .d7, .d8]
            }
        }
        
        public var vertices: [Stencil.Vertex] {
                    
            switch self {
                
            case .delta: [.v0, .v1, .v2]
            case .epsilon: [.v0, .v5, .center, .v7]
            case .gamma: [.v0, .v5, .v6, .v9, .v10, .v7]
            case .kappa: [.v0, .v5, .v7]
            case .lambda: [.v0, .v5, .v9, .v10, .v6, .v7]
            case .omega: [.v0, .v5, .v9, .v10, .v7]
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
        case mobius
        case pascal
        case thales
        
        public var id: String { rawValue.capitalized }
        
        public var kites: [Triangle.Kite] {
                    
            switch self {
                
            case .descartes: [.epsilon, .epsilon, .epsilon]
            case .euclid: [.lambda, .kappa, .sigma]
            case .euler: [.psi, .omega, .kappa]
            case .gauss: [.lambda, .phi, .phi]
            case .mobius: [.kappa, .gamma, .sigma]
            case .pascal: [.gamma, .psi, .psi]
            case .thales: [.kappa, .psi, .omega]
            }
        }
    }
}
