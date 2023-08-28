//
//  GridTests.swift
//
//  Created by Zack Brown on 23/08/2023.
//

import XCTest
@testable import Bivouac

final class BivouacTests: XCTestCase {
    
    let triangle = Grid.Triangle(.zero)
    
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
    
    func testAdjacent() throws {
        
        let adjacent = triangle.adjacent
        
        let coordinates = [Coordinate(triangle.delta, 0, 0),
                           Coordinate(0, triangle.delta, 0),
                           Coordinate(0, 0, triangle.delta)]
        
        XCTAssertEqual(adjacent.count, coordinates.count)
        
        for coordinate in coordinates {
            
            XCTAssert(adjacent.contains(coordinate))
        }
    }
    
    func testDiagonal() throws {
        
        let diagonals = triangle.diagonals
        
        let coordinates = [Coordinate(-triangle.delta, triangle.delta, triangle.delta),
                           Coordinate(triangle.delta, -triangle.delta, triangle.delta),
                           Coordinate(triangle.delta, triangle.delta, -triangle.delta)]
        
        XCTAssertEqual(diagonals.count, coordinates.count)
        
        for coordinate in coordinates {
            
            XCTAssert(diagonals.contains(coordinate))
        }
    }
    
    func testTouching() throws {
        
        let touching = triangle.touching
        
        let coordinates = [Coordinate(triangle.delta, -triangle.delta, 0),
                           Coordinate(triangle.delta, 0, -triangle.delta),
                           Coordinate(0, triangle.delta, -triangle.delta),
                           Coordinate(-triangle.delta, triangle.delta, 0),
                           Coordinate(-triangle.delta, 0, triangle.delta),
                           Coordinate(0, -triangle.delta, triangle.delta)]
        
        XCTAssertEqual(touching.count, coordinates.count)
        
        for coordinate in coordinates {
            
            XCTAssert(touching.contains(coordinate))
        }
    }
}
