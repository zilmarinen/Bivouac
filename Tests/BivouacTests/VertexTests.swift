//
//  VertexTests.swift
//
//  Created by Zack Brown on 06/09/2023.
//

import XCTest
@testable import Bivouac

final class VertexTests: XCTestCase {
    
    func testVertexAdjacent() throws {
        
        let vertex = Grid.Vertex(.init(-2, -2, 5))
        
        let vertices = [Grid.Vertex(.init(-1, -2, 4)),
                        Grid.Vertex(.init(-1, -3, 5)),
                        Grid.Vertex(.init(-2, -3, 6)),
                        Grid.Vertex(.init(-3, -2, 6)),
                        Grid.Vertex(.init(-3, -1, 5)),
                        Grid.Vertex(.init(-2, -1, 4))]
        
        XCTAssertEqual(vertex.adjacent, vertices)
    }
    
    func testVertexTriangles() throws {
        
        let vertex = Grid.Vertex(.init(-2, 5, -2))
        
        let triangles = [Grid.Triangle(.init(-2, 4, -3)),
                         Grid.Triangle(.init(-2, 4, -2)),
                         Grid.Triangle(.init(-3, 4, -2)),
                         Grid.Triangle(.init(-3, 5, -2)),
                         Grid.Triangle(.init(-3, 5, -3)),
                         Grid.Triangle(.init(-2, 5, -3))]
        
        XCTAssertEqual(vertex.triangles, triangles)
    }
}
