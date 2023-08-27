//
//  GridTests.swift
//
//  Created by Zack Brown on 23/08/2023.
//

import XCTest
@testable import Bivouac

final class BivouacTests: XCTestCase {
    
    let triangle = Grid.Triangle(coordinate: .zero)
    
    func testUnitTriangleIsPointy() throws {
        
        XCTAssertTrue(triangle.isPointy)
    }
    
    func testTriangulation() throws {
        
        let tileTriangulation = triangle.triangulation(for: .tile)
        let chunkTriangulation = triangle.triangulation(for: .chunk)
        let regionTriangulation = triangle.triangulation(for: .region)
        
        XCTAssertEqual(tileTriangulation.triangles.count, 1)
        XCTAssertEqual(chunkTriangulation.triangles.count, 49)
        XCTAssertEqual(regionTriangulation.triangles.count, 784)
    }
    
    func testSieve() throws {
        
        let tileSieve = triangle.sieve(for: .tile)
        let chunkSieve = triangle.sieve(for: .chunk)
        let regionSieve = triangle.sieve(for: .region)
        
        XCTAssertEqual(tileSieve.coordinates.count, 3)
        XCTAssertEqual(chunkSieve.coordinates.count, 36)
        XCTAssertEqual(regionSieve.coordinates.count, 435)
    }
}
