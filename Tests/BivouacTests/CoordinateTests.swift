//
//  CoordinateTests.swift
//
//  Created by Zack Brown on 11/09/2023.
//

import Euclid
import XCTest
@testable import Bivouac

final class CoordinateTests: XCTestCase {
    
    let zero = Grid.Triangle(.zero)
    let x = Grid.Triangle(-.unitX)
    let y = Grid.Triangle(-.unitY)
    let z = Grid.Triangle(-.unitZ)
    
    func testCoordinateRegionToTile() throws {
        
        let regions = [zero,
                       x,
                       y,
                       z].map { $0.position.convert(from: .region,
                                                    to: .tile) }
        
        let coordinates = [Coordinate(0, 0, 0),
                           Coordinate(-19, 9, 9),
                           Coordinate(9, -19, 9),
                           Coordinate(9, 9, -19)]
        
        XCTAssertEqual(regions, coordinates)
    }
    
    func testCoordinateRegionToChunk() throws {
        
        let regions = [zero,
                       x,
                       y,
                       z].map { $0.position.convert(from: .region,
                                                    to: .chunk) }
        
        let coordinates = [Coordinate(0, 0, 0),
                           Coordinate(-3, 1, 1),
                           Coordinate(1, -3, 1),
                           Coordinate(1, 1, -3)]
        
        XCTAssertEqual(regions, coordinates)
    }
    
    func testCoordinateChunkToRegion() throws {
        
        let regions = [Coordinate(0, 0, 0),
                       x.position,
                       y.position,
                       z.position,
                       Coordinate(-3, 1, 1),
                       Coordinate(1, -3, 1),
                       Coordinate(1, 1, -3)].map { $0.convert(from: .chunk,
                                                              to: .region) }
        
        let coordinates = [zero,
                           zero,
                           zero,
                           zero,
                           x,
                           y,
                           z].map { $0.position }
        
        XCTAssertEqual(regions, coordinates)
        
        XCTAssertEqual(Coordinate.zero, Coordinate(2, -1, -1).convert(from: .chunk, to: .region))
        XCTAssertEqual(Coordinate.zero, Coordinate(-1, 2, -1).convert(from: .chunk, to: .region))
        XCTAssertEqual(Coordinate.zero, Coordinate(-1, -1, 2).convert(from: .chunk, to: .region))
        
        XCTAssertEqual(Coordinate.zero, Coordinate(-2, -2, 4).convert(from: .chunk, to: .region))
        XCTAssertEqual(Coordinate.zero, Coordinate(-2, 4, -2).convert(from: .chunk, to: .region))
        XCTAssertEqual(Coordinate.zero, Coordinate(4, -2, -2).convert(from: .chunk, to: .region))
    }
    
    func testCoordinateChunkToTile() throws {
        
        let chunks = [zero,
                      x,
                      y,
                      z].map { $0.position.convert(from: .chunk,
                                                   to: .tile) }
        
        let coordinates = [Coordinate(0, 0, 0),
                           Coordinate(-5, 2, 2),
                           Coordinate(2, -5, 2),
                           Coordinate(2, 2, -5)]
        
        XCTAssertEqual(chunks, coordinates)
    }
    
    func testCoordinateTileToChunk() throws {
        
        let tiles = [Coordinate(0, 0, 0),
                     x.position,
                     y.position,
                     z.position,
                     Coordinate(-5, 2, 2),
                     Coordinate(2, -5, 2),
                     Coordinate(2, 2, -5)].map { $0.convert(from: .tile,
                                                            to: .chunk) }
        
        let coordinates = [zero,
                           zero,
                           zero,
                           zero,
                           x,
                           y,
                           z].map { $0.position }
        
        XCTAssertEqual(tiles, coordinates)
        
        XCTAssertEqual(Coordinate.zero, Coordinate(2, -1, -1).convert(from: .tile, to: .chunk))
        XCTAssertEqual(Coordinate.zero, Coordinate(-1, 2, -1).convert(from: .tile, to: .chunk))
        XCTAssertEqual(Coordinate.zero, Coordinate(-1, -1, 2).convert(from: .tile, to: .chunk))
        
        XCTAssertEqual(Coordinate.zero, Coordinate(-2, -2, 4).convert(from: .tile, to: .chunk))
        XCTAssertEqual(Coordinate.zero, Coordinate(-2, 4, -2).convert(from: .tile, to: .chunk))
        XCTAssertEqual(Coordinate.zero, Coordinate(4, -2, -2).convert(from: .tile, to: .chunk))
    }
    
    func testCoordinateTileToRegion() throws {
        
        let tiles = [Coordinate(0, 0, 0),
                     x.position,
                     y.position,
                     z.position,
                     Coordinate(-19, 9, 9),
                     Coordinate(9, -19, 9),
                     Coordinate(9, 9, -19)].map { $0.convert(from: .tile,
                                                             to: .region) }
        
        let coordinates = [zero,
                           zero,
                           zero,
                           zero,
                           x,
                           y,
                           z].map { $0.position }
        
        XCTAssertEqual(tiles, coordinates)
    }
    
    // MARK: Coordinate to Vector
    
    func testTileCoordinateToVector() throws {
        
        XCTAssertTrue(testCoordinateToVector(at: .tile))
    }
    
    func testChunkCoordinateToVector() throws {
        
        XCTAssertTrue(testCoordinateToVector(at: .chunk))
    }
    
    func testRegionCoordinateToVector() throws {
        
        XCTAssertTrue(testCoordinateToVector(at: .region))
    }
    
    // MARK: Vector to Coordinate
    
    func testTileVectorToCoordinate() throws {
        
        XCTAssertTrue(testVectorToCoordinate(at: .tile))
    }
    
    func testChunkVectorToCoordinate() throws {
        
        XCTAssertTrue(testVectorToCoordinate(at: .chunk))
    }
    
    func testRegionVectorToCoordinate() throws {
        
        XCTAssertTrue(testVectorToCoordinate(at: .region))
    }
    
    // MARK: Vertices
    
    func testTileVertices() throws {
        
        XCTAssertTrue(testVertices(at: .tile))
    }
    
    func testChunkVertices() throws {
        
        XCTAssertTrue(testVertices(at: .chunk))
    }
    
    func testRegionVertices() throws {
        
        XCTAssertTrue(testVertices(at: .region))
    }
}

extension CoordinateTests {
    
    private func testVertices(at scale: Grid.Scale) -> Bool {
        
        let edgeLength = Double(scale.rawValue)
        let halfEdgeLength = edgeLength / 2.0
        let sqrt3d6 = .sqrt3d6 * edgeLength
        let sqrt3d3 = .sqrt3d3 * edgeLength
        
        let v0 = Vector(0.0, 0.0, sqrt3d6 * 2.0)
        let v1 = Vector(halfEdgeLength, 0.0, -sqrt3d6)
        let v2 = Vector(-halfEdgeLength, 0.0, -sqrt3d6)
        
        let v3 = Vector(0.0, 0.0, -sqrt3d3 * 2.0)
        let v4 = Vector(-edgeLength, 0.0, sqrt3d3)
        let v5 = Vector(edgeLength, 0.0, sqrt3d3)
        
        let px = Vector(0.0, 0.0, -sqrt3d3)
        let py = Vector(-halfEdgeLength, 0.0, sqrt3d6)
        let pz = Vector(halfEdgeLength, 0.0, sqrt3d6)
        
        guard zero.position.convert(to: scale).isEqual(to: .zero),
              zero.vertex(.v0).convert(to: scale).isEqual(to: v0),
              zero.vertex(.v1).convert(to: scale).isEqual(to: v1),
              zero.vertex(.v2).convert(to: scale).isEqual(to: v2),
              
              x.position.convert(to: scale).isEqual(to: px),
              x.vertex(.v0).convert(to: scale).isEqual(to: v3),
              x.vertex(.v1).convert(to: scale).isEqual(to: v2),
              x.vertex(.v2).convert(to: scale).isEqual(to: v1),
        
              y.position.convert(to: scale).isEqual(to: py),
              y.vertex(.v0).convert(to: scale).isEqual(to: v2),
              y.vertex(.v1).convert(to: scale).isEqual(to: v4),
              y.vertex(.v2).convert(to: scale).isEqual(to: v0),
        
              z.position.convert(to: scale).isEqual(to: pz),
              z.vertex(.v0).convert(to: scale).isEqual(to: v1),
              z.vertex(.v1).convert(to: scale).isEqual(to: v0),
              z.vertex(.v2).convert(to: scale).isEqual(to: v5) else { return false }
        
        return true
    }
    
    private func testCoordinateToVector(at scale: Grid.Scale) -> Bool {
        
        let edgeLength = Double(scale.rawValue)
        
        let c0 = Coordinate(-2, -2, 4)
        let c1 = Coordinate(-2, 4, -2)
        let c2 = Coordinate(4, -2, -2)
        
        let c3 = Coordinate(-3, -3, 6)
        let c4 = Coordinate(-3, 6, -3)
        let c5 = Coordinate(6, -3, -3)
        
        let v0 = Vector(-edgeLength * 3.0, 0.0, -.sqrt3 * edgeLength)
        let v1 = Vector(edgeLength * 3.0, 0.0, -.sqrt3 * edgeLength)
        let v2 = Vector(0.0, 0.0, .sqrt3 * edgeLength * 2.0)
        let v3 = Vector(-edgeLength * 4.5, 0.0, -.sqrt3 * edgeLength * 1.5)
        let v4 = Vector(edgeLength * 4.5, 0.0, -.sqrt3 * edgeLength * 1.5)
        let v5 = Vector(0.0, 0.0, .sqrt3 * edgeLength * 3.0)
        
        guard c0.convert(to: scale).isEqual(to: v0),
              c1.convert(to: scale).isEqual(to: v1),
              c2.convert(to: scale).isEqual(to: v2),
        
              c3.convert(to: scale).isEqual(to: v3),
              c4.convert(to: scale).isEqual(to: v4),
              c5.convert(to: scale).isEqual(to: v5) else { return false }
        
        return true
    }
    
    private func testVectorToCoordinate(at scale: Grid.Scale) -> Bool {
        
        let edgeLength = Double(scale.rawValue)
        
        let c0 = Coordinate(-2, -2, 4)
        let c1 = Coordinate(-2, 4, -2)
        let c2 = Coordinate(4, -2, -2)
        
        let c3 = Coordinate(-3, -3, 6)
        let c4 = Coordinate(-3, 6, -3)
        let c5 = Coordinate(6, -3, -3)
        
        let v0 = Vector(-edgeLength * 3.0, 0.0, -.sqrt3 * edgeLength)
        let v1 = Vector(edgeLength * 3.0, 0.0, -.sqrt3 * edgeLength)
        let v2 = Vector(0.0, 0.0, .sqrt3 * edgeLength * 2.0)
        let v3 = Vector(-edgeLength * 4.5, 0.0, -.sqrt3 * edgeLength * 1.5)
        let v4 = Vector(edgeLength * 4.5, 0.0, -.sqrt3 * edgeLength * 1.5)
        let v5 = Vector(0.0, 0.0, .sqrt3 * edgeLength * 3.0)
        
        guard v0.convert(to: scale) == c0,
              v1.convert(to: scale) == c1,
              v2.convert(to: scale) == c2,
        
              v3.convert(to: scale) == c3,
              v4.convert(to: scale) == c4,
              v5.convert(to: scale) == c5 else { return false }
        
        return true
    }
}
