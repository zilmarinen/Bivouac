//
//  Vertex.swift
//
//  Created by Zack Brown on 06/09/2023.
//

extension Grid {
    
    public struct Vertex: Equatable {
        
        public let position: Coordinate
        
        public init(_ position: Coordinate) {
         
            self.position = position
        }
    }
}

extension Grid.Vertex {
    
    //
    //  Directly connected adjacent vertices that share an edge.
    //
    //                  x-------x
    //                /   \   /   \
    //              x-------x-------x
    //                \   /   \   /
    //                  x-------x
    //
    
    public var adjacent: [Grid.Vertex] { [.init(position + (.unitX + -.unitZ)),
                                          .init(position + (.unitX + -.unitY)),
                                          .init(position + (-.unitY + .unitZ)),
                                          .init(position + (-.unitX + .unitZ)),
                                          .init(position + (-.unitX + .unitY)),
                                          .init(position + (.unitY + -.unitZ))] }
    
    //
    //  Directly connected adjacent triangles that share an vertex.
    //
    //                  ---------
    //                / x \ x / x \
    //               ------- -------
    //                \ x / x \ x /
    //                  ---------
    //
    
    public var triangles: [Grid.Triangle] { [.init(position + -(.unitY + .unitZ)),
                                             .init(position + -.unitY),
                                             .init(position + -(.unitX + .unitY)),
                                             .init(position + -.unitX),
                                             .init(position + -(.unitX + .unitZ)),
                                             .init(position + -.unitZ)] }
}
