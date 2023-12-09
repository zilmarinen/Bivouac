//
//  Bezier.swift
//
//  Created by Zack Brown on 20/11/2023.
//

import Euclid

public class Bezier {
    
    public let start: Vector
    public let end: Vector
    
    public let controls: [Vector]
    
    init(start: Vector,
         end: Vector,
         controls: [Vector]) {
        
        self.start = start
        self.end = end
        self.controls = controls
    }
}

extension Bezier {
    
    public class Cubic: Bezier {
        
        public let c0: Vector
        public let c1: Vector
        
        public init(start: Vector,
                    end: Vector,
                    c0: Vector,
                    c1: Vector) {
            
            self.c0 = c0
            self.c1 = c1
            
            super.init(start: start,
                       end: end,
                       controls: [c0,
                                 c1])
        }
        
        public func steps(_ steps: Int) -> [Vector] {
            
            let steps = max(steps, 1) + 1
            
            let stride = 1.0 / Double(steps)
            
            return (0...steps).map {
                
                let t = stride * Double($0)
                
                let sc0 = start.lerp(c0, t)
                let c0c1 = c0.lerp(c1, t)
                let c1e = c1.lerp(end, t)
                
                let lhs = sc0.lerp(c0c1, t)
                let rhs = c0c1.lerp(c1e, t)
                
                return lhs.lerp(rhs, t)
            }
        }
    }
}

extension Bezier {
    
    public class Quadratic: Bezier {
        
        public let c: Vector
        
        public init(start: Vector,
                    end: Vector,
                    c: Vector) {
            
            self.c = c
            
            super.init(start: start,
                       end: end,
                       controls: [c])
        }
        
        public func steps(_ steps: Int) -> [Vector] {
            
            let steps = max(steps, 1) + 1
            
            let stride = 1.0 / Double(steps)
            
            return (0...steps).map {
                
                let t = stride * Double($0)
                let lhs = start.lerp(c, t)
                let rhs = c.lerp(end, t)
                
                return lhs.lerp(rhs, t)
            }
        }
    }
}
