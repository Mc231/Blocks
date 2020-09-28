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
		let cells: [FieldCell] = [.init(xPosition: 1, yPosition: 1, state: .empty),
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

//   // let GameFlow = GameFlowManager()
//    let tetramonios = try! TetramonioLoader().load()
////   // let checkTetramonioManager = CheckTetramonioManager()
////    
////    lazy var field: [CellData] = {
////      //  let field = self.GameFlow.createField()
////        return field
////    }()
////    
//    func testGameFlowCreateField() {
//    //    XCTAssertEqual(field.count, 64)
//    }
//
//    func testBadTetramonio() {
//		XCTAssertFalse(checkTetramonio(4, firstIndex: 0, secondIndex: 1, thirdIndex: 2, fourthIndex: 3))
//    }
//
//    func testTetramonioIv() {
//		XCTAssertTrue(checkTetramonio(0, firstIndex: 0, secondIndex: 1, thirdIndex: 2, fourthIndex: 3))
//		XCTAssertTrue(checkTetramonioGameOverIndexes(0))
//    }
//
//    func testTetramonioIh() {
//		XCTAssertTrue(checkTetramonio(1, firstIndex: 0, secondIndex: 8, thirdIndex: 16, fourthIndex: 24))
//		XCTAssertTrue(checkTetramonioGameOverIndexes(1))
//    }
//
//    func testTetramonioO() {
//		XCTAssertTrue(checkTetramonio(2, firstIndex: 0, secondIndex: 1, thirdIndex: 8, fourthIndex: 9))
//		XCTAssertTrue(checkTetramonioGameOverIndexes(2))
//    }
//
//    func testTetramonioL90() {
//		XCTAssertTrue(checkTetramonio(3, firstIndex: 0, secondIndex: 8, thirdIndex: 16, fourthIndex: 17))
//		XCTAssertTrue(checkTetramonioGameOverIndexes(3))
//    }
//
//    func testTetramonioJ90() {
//		XCTAssertTrue(checkTetramonio(4, firstIndex: 0, secondIndex: 1, thirdIndex: 8, fourthIndex: 16))
//		XCTAssertTrue(checkTetramonioGameOverIndexes(4))
//    }
//
//    func testTetramonioL180() {
//		XCTAssertTrue(checkTetramonio(5, firstIndex: 0, secondIndex: 1, thirdIndex: 2, fourthIndex: 8))
//		XCTAssertTrue(checkTetramonioGameOverIndexes(5))
//    }
//
//    func testTetramonioJ() {
//		XCTAssertTrue(checkTetramonio(6, firstIndex: 0, secondIndex: 8, thirdIndex: 9, fourthIndex: 10))
//		XCTAssertTrue(checkTetramonioGameOverIndexes(6))
//    }
//
//    func testTetramonioJ270() {
//		XCTAssertTrue(checkTetramonio(7, firstIndex: 1, secondIndex: 9, thirdIndex: 16, fourthIndex: 17))
//		XCTAssertTrue(checkTetramonioGameOverIndexes(7))
//    }
//
//    func testTetramonioL270() {
//		XCTAssertTrue(checkTetramonio(8, firstIndex: 0, secondIndex: 1, thirdIndex: 9, fourthIndex: 17))
//		XCTAssertTrue(checkTetramonioGameOverIndexes(8))
//    }
//
//    func testTetramonioJ180() {
//		XCTAssertTrue(checkTetramonio(9, firstIndex: 0, secondIndex: 1, thirdIndex: 2, fourthIndex: 10))
//		XCTAssertTrue(checkTetramonioGameOverIndexes(9))
//    }
//
//    func testTetramonioL() {
//		XCTAssertTrue(checkTetramonio(10, firstIndex: 2, secondIndex: 8, thirdIndex: 9, fourthIndex: 10))
//		XCTAssertTrue(checkTetramonioGameOverIndexes(10))
//    }
//
//    func testTetramonioS() {
//		XCTAssertTrue(checkTetramonio(11, firstIndex: 8, secondIndex: 9, thirdIndex: 1, fourthIndex: 2))
//		XCTAssertTrue(checkTetramonioGameOverIndexes(11))
//    }
//
//    func testTetramonioS90() {
//		XCTAssertTrue(checkTetramonio(12, firstIndex: 0, secondIndex: 8, thirdIndex: 9, fourthIndex: 17))
//		XCTAssertTrue(checkTetramonioGameOverIndexes(12))
//    }
//
//    func testTetramonioZ() {
//		XCTAssertTrue(checkTetramonio(13, firstIndex: 0, secondIndex: 1, thirdIndex: 9, fourthIndex: 10))
//		XCTAssertTrue(checkTetramonioGameOverIndexes(13))
//    }
//
//    func testTetramonioZ90() {
//		XCTAssertTrue(checkTetramonio(14, firstIndex: 1, secondIndex: 8, thirdIndex: 9, fourthIndex: 16))
//		XCTAssertTrue(checkTetramonioGameOverIndexes(14))
//    }
//
//    func testTetramonioT180() {
//		XCTAssertTrue(checkTetramonio(15, firstIndex: 0, secondIndex: 1, thirdIndex: 2, fourthIndex: 9))
//		XCTAssertTrue(checkTetramonioGameOverIndexes(15))
//    }
//
//    func testTetramonioT() {
//		XCTAssertTrue(checkTetramonio(16, firstIndex: 1, secondIndex: 8, thirdIndex: 9, fourthIndex: 10))
//		XCTAssertTrue(checkTetramonioGameOverIndexes(16))
//    }
//
//    func testTetramonioT90() {
//		XCTAssertTrue(checkTetramonio(17, firstIndex: 0, secondIndex: 8, thirdIndex: 9, fourthIndex: 16))
//		XCTAssertTrue(checkTetramonioGameOverIndexes(17))
//    }
//
//    func testTetramonioT270() {
//		XCTAssertTrue(checkTetramonio(18, firstIndex: 8, secondIndex: 1, thirdIndex: 9, fourthIndex: 17))
//		XCTAssertTrue(checkTetramonioGameOverIndexes(18))
//    }

    // MARK: - Private methods
	// swiftlint:disable vertical_parameter_alignment
//    func checkTetramonio(_ identifer: Int,
//						 firstIndex: Int,
//						 secondIndex: Int,
//						 thirdIndex: Int,
//						 fourthIndex: Int) -> Bool {
//        GameFlow.updateTetramonios([tetramonios[id]])
//        checkTetramonioManager.updateTetramonios([tetramonios[id]])
//        let currentTetramonio = [field[firstIndex], field[secondIndex], field[thirdIndex], field[fourthIndex]]
//        return checkTetramonioManager.checkTetramonio(with: currentTetramonio)?.id == tetramonios[id].id
      //  return true
    //}

  //  func checkTetramonioGameOverIndexes(_ identifier: Int) -> Bool {
//        GameFlow.updateTetramonios([tetramonios[id]])
//        checkTetramonioManager.updateTetramonios([tetramonios[id]])
//        let gameOverIndexes = tetramonios[id].gameOverIndexes
//        let firstCell  = field[28]
//        let secondCell = field[28 + gameOverIndexes[0]]
//        let thirdCell  = field[28 + gameOverIndexes[1]]
//        let fourthCell = field[28 + gameOverIndexes[2]]
//        let possibleTetramonio = [firstCell, secondCell, thirdCell, fourthCell]

       // return checkTetramonioManager.checkTetramonio(with: possibleTetramonio)?.id == tetramonios[id].id
//        return false
//    }
}
