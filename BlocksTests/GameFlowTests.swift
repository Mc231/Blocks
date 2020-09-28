//
//  GameFlowTests.swift
//  Blocks
//
//  Created by Volodya on 3/24/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import XCTest
@testable import Blocks

private extension Tetramonio {
	static func emptyOfType(_ type: Tetramonio.`Type`) -> Tetramonio {
		return Tetramonio(id: type,
						  tetramonioIndexes: [],
						  gameOverIndexes: [],
						  displayTetramonioIndexes: [])
	}
}

private extension GameFlowTests {
	
	class MockInteractor: GameFlowOutput {
		
		var gameOverScore: Score!
		var changedScore: GameScore!
		var updatedField: [FieldCell] = []
		var updatedTetramonios: [Tetramonio] = []
		
		func gameOver(currentScore: Score) {
			gameOverScore = currentScore
		}
		
		func gameFlow(_ manager: GameFlowInput, didChange score: GameScore) {
			changedScore = score
		}
		
		func gameFlow(_ manager: GameFlowInput, didUpdate field: [FieldCell]) {
			updatedField = field
		}
		
		func gameFlow(_ manager: GameFlowInput, didUpdate tetramonios: [Tetramonio]) {
			updatedTetramonios = tetramonios
		}
	}
	
	class MockTetramonioGenerator: TetramonioGeneratable {
		
		var generationType: GenerationType!
		var currentTetramonios: [Tetramonio] = []
		
		func generateTetramonios(of generationType: GenerationType) -> [Tetramonio] {
			self.generationType = generationType
			return currentTetramonios
		}
		
		func getTetramoniosFromIds(_ ids: [Int16]) -> [Tetramonio] {
			return currentTetramonios
		}
	}
	
	class MockStorage: GameStorage {
		
		var currentScore: Score = 1
        var gameScore: GameScore = .init(current: 1, best: 1)
        var field: [FieldCell] = []
		var bestScore: Score = 10
        var restartGameConfig: RestartGameConfig = .init(field: [], score: .init(current: 1, best: 1))
		var tetramoniosIndexes: [TetramonioIndex] = []
		
		var storedTetramonios: [Tetramonio] = []
		var storedField: [FieldCell] = []
		var updatedCells: [FieldCell] = []
		var increasedScore: GameScore!
		
		func store(current tetramonios: [Tetramonio]) -> Bool {
			storedTetramonios = tetramonios
			return true
		}
		
		func storeField(_ field: [FieldCell]) {
			storedField = field
		}
		
		func storeUpdatedCells(_ updatedCells: [FieldCell]) {
			self.updatedCells = updatedCells
		}
		
        func increaseAndStoreScore(by score: Score) -> GameScore {
			gameScore = GameScore(current: score, best: score + 1)
            return gameScore
		}
		
		func restartGame() -> RestartGameConfig {
            return restartGameConfig
		}
		
		func createField() -> [FieldCell] {
			return FieldCell.mockedField
		}
	}
}

class GameFlowTests: XCTestCase {
	
	private var sut: GameFlow!
	private let interactor = MockInteractor()
	private let tetramonioGenerator = MockTetramonioGenerator()
	private let storage = MockStorage()
	
	override func setUp() {
		sut = GameFlow(interactor: interactor,
					   tetramonioGenerator: tetramonioGenerator,
					   storage: storage)
		super.setUp()
	}
	
	override func tearDown() {
		sut = nil
		super.tearDown()
	}
	
	func testGenerateTetramoniosForGameStart() {
		// Given
		XCTAssertTrue(tetramonioGenerator.currentTetramonios.isEmpty)
		let tetramonios: [Tetramonio] = [.emptyOfType(.iH), .emptyOfType(.j180)]
		// When
		tetramonioGenerator.currentTetramonios = tetramonios
		sut.generateTetramoniosOf(.gameStart)
		// Then
		XCTAssertEqual(tetramonios, sut.tetramonios)
	}
	
	func testStartGameWhenStoredTetramonioIdsAreEmpty() {
		// Given
		let expectedGenerationType: GenerationType = .gameStart
		XCTAssertNil(tetramonioGenerator.generationType)
		// When
		let config = sut.startGame()
		// Then
		XCTAssertEqual(tetramonioGenerator.generationType, expectedGenerationType)
		XCTAssertEqual(tetramonioGenerator.currentTetramonios, config.tetramonios)
		XCTAssertEqual(storage.field, config.fieldCells)
		XCTAssertEqual(storage.gameScore, config.score)
	}
	
	func testStartGameWhenStoredTetramonioIdsAreNotEmpty() {
		// Given
		let indexes = [Tetramonio.emptyOfType(.iH), Tetramonio.emptyOfType(.j)]
			.map({$0.id.rawValue})
		storage.tetramoniosIndexes = indexes
		storage.field = [.init(state: .selected)]
		XCTAssertNil(tetramonioGenerator.generationType)
		// When
		let config = sut.startGame()
		// Then
		XCTAssertEqual(tetramonioGenerator.currentTetramonios, config.tetramonios)
		XCTAssertEqual(storage.field, config.fieldCells)
		XCTAssertEqual(storage.gameScore, config.score)
	}
	
	func testRestartGame() {
		// Given
		let expectedGenerationType: GenerationType = .gameStart
		XCTAssertNil(tetramonioGenerator.generationType)
		// When
		let restartGameConfig = sut.restartGame()
        // Then
        XCTAssertEqual(tetramonioGenerator.generationType, expectedGenerationType)
        XCTAssertTrue(restartGameConfig.field.isEmpty)
	}
	
	func testUpdateFieldWithCell() {
		// Given
		let expectedCell = FieldCell(xPosition: 1, yPosition: 1, state: .empty)
		XCTAssertTrue(sut.currentTetramonio.isEmpty)
		storage.field = FieldCell.mockedField
		_ = sut.startGame()
		// When
		sut.updateField(with: expectedCell)
		// Then
		XCTAssertTrue(sut.currentTetramonio.contains(expectedCell))
	}
	
	func testUpdateFieldWith3DraggedCells() {
		// Given
		let cells: [FieldCell] = [.init(xPosition: 0, yPosition: 0, state: .selected),
								  .init(xPosition: 1, yPosition: 1, state: .selected),
								  .init(xPosition: 2, yPosition: 2, state: .selected)
		]
		// When
		sut.updateField(with: cells)
		// Then
		XCTAssertTrue(sut.currentTetramonio.isEmpty)
	}
	
	func testUpdateFieldWith4DraggedCells() {
		// Given
		let cells: [FieldCell] = [.init(xPosition: 2, yPosition: 1, state: .empty),
								  .init(xPosition: 2, yPosition: 2, state: .empty),
								  .init(xPosition: 3, yPosition: 3, state: .empty),
								  .init(xPosition: 4, yPosition: 4, state: .empty)
		]
		storage.field = storage.createField()
		_ = sut.startGame()
		// When
		sut.updateField(with: cells)
		// Then
		XCTAssertTrue(sut.fieldCells.filter({$0.state == .selected}).isEmpty)
		XCTAssertTrue(sut.currentTetramonio.isEmpty)
	}
    
    func testUpdateFieldRemoveAllSelectedCells() {
        // Given
        let cells: [FieldCell] = [.init(xPosition: 2, yPosition: 1, state: .empty),
                                  .init(xPosition: 2, yPosition: 2, state: .empty),
                                  .init(xPosition: 3, yPosition: 3, state: .empty),
                                  .init(xPosition: 4, yPosition: 4, state: .empty)
        ]
        XCTAssertTrue(storage.field.isEmpty)
        XCTAssertTrue(interactor.updatedField.isEmpty)
        var field = FieldCell.mockedField
        field[0].chageState(newState: .selected)
        storage.field = field
        _ = sut.startGame()
        storage.storeUpdatedCells(cells)
        // When
        sut.updateField(with: cells)
        // Then
        XCTAssertTrue(sut.fieldCells.filter({$0.state == .selected}).isEmpty)
        XCTAssertFalse(interactor.updatedField.isEmpty)
        XCTAssertTrue(sut.currentTetramonio.isEmpty)
    }
    
    func testPlaceTetramonioUpdateStorageAndGenerateNewTetramonio() {
        // Given
        let cells: [FieldCell] = [.init(xPosition: 1, yPosition: 1, state: .selected),
                                  .init(xPosition: 2, yPosition: 2, state: .selected),
                                  .init(xPosition: 3, yPosition: 3, state: .selected),
                                  .init(xPosition: 4, yPosition: 4, state: .selected)
        ]
        XCTAssertTrue(storage.field.isEmpty)
        XCTAssertTrue(interactor.updatedField.isEmpty)
		XCTAssertTrue(interactor.updatedTetramonios.isEmpty)
		XCTAssertNil(interactor.changedScore)
        tetramonioGenerator.currentTetramonios = [.init(id: .iH, tetramonioIndexes: [1,1,1], gameOverIndexes: [1,2,3], displayTetramonioIndexes: []),
                                                  .init(id: .iV, tetramonioIndexes: [10,10,10], gameOverIndexes: [8,16,24], displayTetramonioIndexes: [])
        ]
		storage.field = storage.createField()
        _ = sut.startGame()
        storage.storeUpdatedCells(cells)
        // When
        sut.updateField(with: cells)
        // Then
        XCTAssertTrue(sut.fieldCells.filter({$0.state == .selected}).isEmpty)
		XCTAssertEqual(interactor.updatedTetramonios, tetramonioGenerator.currentTetramonios)
        XCTAssertFalse(interactor.updatedField.isEmpty)
		XCTAssertEqual(interactor.changedScore, storage.gameScore)
    }
	
	func testCheckCrossLine() {
		// Given
		let cells: [FieldCell] = [.init(xPosition: 5, yPosition: 5, state: .selected),
								  .init(xPosition: 4, yPosition: 6, state: .selected),
								  .init(xPosition: 2, yPosition: 7, state: .selected),
								  .init(xPosition: 3, yPosition: 8, state: .selected),
		]
		XCTAssertTrue(interactor.updatedField.isEmpty)
		XCTAssertTrue(storage.updatedCells.isEmpty)
		// When
		var field = FieldCell.mockedField
		field[0].chageState(newState: .placed)
		field[1].chageState(newState: .placed)
		field[2].chageState(newState: .placed)
		field[3].chageState(newState: .placed)
		field[4].chageState(newState: .placed)
		field[5].chageState(newState: .placed)
		field[6].chageState(newState: .placed)
		field[7].chageState(newState: .placed)
		storage.field = field
		_ = sut.startGame()
		// When
		sut.updateField(with: cells)
		// Then
		XCTAssertEqual(interactor.updatedField.count, cells.count)
		
	}
}
