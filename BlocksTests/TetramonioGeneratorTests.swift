//
//  TetramonioHelperTests.swift
//  Blocks
//
//  Created by Volodya on 3/24/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import XCTest
@testable import Blocks

private extension TetramonioGeneratorTests {
	
	class MockTeramonioLoader: TetramonioLoadable {
		
		var teramonios: [Tetramonio] = []
		
		func load() throws -> [Tetramonio] {
			return teramonios
		}
	}
}

private extension Tetramonio {
	static var mocked: [Tetramonio] {
		return Type.allCases.map({Tetramonio(id: $0,
											 tetramonioIndexes: [],
											 gameOverIndexes: [],
											 displayTetramonioIndexes: [])})
	}
}

class TetramonioGeneratorTests: XCTestCase {
	
	private var sut: TetramonioGeneratable!
	private let loader = MockTeramonioLoader()
	
	override func setUp() {
		super.setUp()
		loader.teramonios = Tetramonio.mocked
		sut = try! TetramonioGenerator(loader: loader)
	}
	
	override func tearDown() {
		sut = nil
		loader.teramonios.removeAll()
		super.tearDown()
	}

    func testGenerateTetramoniosForGameStart() {
		// Given
		let generationType: GenerationType = .gameStart
		// When
		let result = sut.generateTetramonios(generationType)
		// Then
        XCTAssertTrue(result.count == 2)
        XCTAssertNotEqual(result.first, result.last)
    }
	
    func testGenerateTetramoniosForFirstTetramonio() {
		// Given
		let tetramonios = sut.generateTetramonios(.gameStart)
		let generationType: GenerationType = .firtTetramonio
		// When
		let result = sut.generateTetramonios(generationType)
		// Then
        XCTAssertTrue(result.count == 2)
        XCTAssertNotEqual(tetramonios, result)
    }

    func testGenerateTetramoniosForLastTetramonio() {
		// Given
		let tetramonios = sut.generateTetramonios(.gameStart)
		let generationType: GenerationType = .secondTetramonio
		// When
		let result = sut.generateTetramonios(generationType)
		// Then
        XCTAssertTrue(result.count == 2)
        XCTAssertNotEqual(tetramonios, result)
    }
	
	func testGetTetramonioFromIdsReturnsResult() {
		// Given
		let ids: [Int16] = [2,3,5]
		// When
		let result = sut.getTetramoniosFromIds(ids)
		// Then
		XCTAssertEqual(ids, result.map({$0.id.rawValue}))
	}
	
	func testGetTetramonioFromIdsReturnsEmptyArray() {
		// Given
		let ids: [Int16] = [99,39,59]
		// When
		let result = sut.getTetramoniosFromIds(ids)
		// Then
		XCTAssertTrue(result.isEmpty)
	}
}
