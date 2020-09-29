//
//  TetramonioMatcherTests.swift
//  BlocksTests
//
//  Created by Volodymyr Shyrochuk on 29.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import XCTest
@testable import Blocks

// MARK: - Mock

fileprivate class MockTetramonioMatcher: TetramonioMatcher { }

class TetramonioMatcherTests: XCTestCase {

    private var sut: TetramonioMatcher!
    
    override func setUp() {
        super.setUp()
        sut = MockTetramonioMatcher()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testMatcherDoesNotMatchTetramonio() {
        // Given
        let cells: [FieldCell] = [
            .init(state: .empty),
            .init(state: .empty),
            .init(state: .empty),
            .init(state: .empty)
        ]
        let tetramonio = Tetramonio(id: .j270,
                                    tetramonioIndexes: [8,2,3],
                                    gameOverIndexes: [],
                                    displayTetramonioIndexes: [])
        // When
        let result = sut.matchTetramonio(from: cells, with: [tetramonio])
        // Then
        XCTAssertNil(result)
    }
    
    func testMatcherMatchIH() {
        // Given
        let cells: [FieldCell] = [
            .init(xPosition: 1, yPosition: 1, state: .empty),
            .init(xPosition: 2, yPosition: 1, state: .empty),
            .init(xPosition: 3, yPosition: 1, state: .empty),
            .init(xPosition: 4, yPosition: 1, state: .empty)
        ]
        let tetramonio = Tetramonio(id: .iH,
                                    tetramonioIndexes: [1,1,1],
                                    gameOverIndexes: [],
                                    displayTetramonioIndexes: [])
        // When
        let result = sut.matchTetramonio(from: cells, with: [tetramonio])
        // Then
        XCTAssertEqual(result, tetramonio)
    }
    
    func testMatcherMatchIV() {
        // Given
        let cells: [FieldCell] = [
            .init(xPosition: 1,  yPosition: 1,  state: .empty),
            .init(xPosition: 11, yPosition: 1,  state: .empty),
            .init(xPosition: 21, yPosition: 1,  state: .empty),
            .init(xPosition: 31, yPosition: 1,  state: .empty)
        ]
        let tetramonio = Tetramonio(id: .iV,
                                    tetramonioIndexes: [10,10,10],
                                    gameOverIndexes: [],
                                    displayTetramonioIndexes: [])
        // When
        let result = sut.matchTetramonio(from: cells, with: [tetramonio])
        // Then
        XCTAssertEqual(result, tetramonio)
    }
    
    func testMatcherMatchJ() {
        // Given
        let cells: [FieldCell] = [
            .init(xPosition: 56,  yPosition: 6,  state: .empty),
            .init(xPosition: 65,  yPosition: 5,  state: .empty),
            .init(xPosition: 66,  yPosition: 6,  state: .empty),
            .init(xPosition: 76, yPosition:  6,  state: .empty)
        ]
        let tetramonio = Tetramonio(id: .t270,
                                    tetramonioIndexes: [9,10,20],
                                    gameOverIndexes: [],
                                    displayTetramonioIndexes: [])
        // When
        let result = sut.matchTetramonio(from: cells, with: [tetramonio])
        // Then
        XCTAssertEqual(result, tetramonio)
    }
}
