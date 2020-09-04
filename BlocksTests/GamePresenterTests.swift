//
//  GamePresenterTests.swift
//  BlocksTests
//
//  Created by Volodymyr Shyrochuk on 03.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import XCTest
@testable import Blocks


extension GamePresenterTests {
	class MockView: GameViewInput {
		
		var presenter: GameViewOutput?
		var displayedTetramonios: [Tetramonio] = []
		var displayedCellData: [FieldCell] = []
		var displayedGameScore: GameScore!
		var scoreToShowInAlert: Score!
		
		func display(tetramonios: [Tetramonio]) {
			displayedTetramonios = tetramonios
		}
		
		func display(field withData: [FieldCell]) {
			displayedCellData = withData
		}
		
		func displayScore(score: GameScore) {
			displayedGameScore = score
		}
		
		func showGameOverAlert(currentScore: Score) {
			scoreToShowInAlert = currentScore
		}
	}
	
	class MockInteractor: GameInteractorInput {
		
		var presenter: GameInteractorOutput?
		
		var startGameCalled = false
		var restartGameCalled = false
		var handledCellData: FieldCell!
		var handledDraggedCell: [FieldCell] = []
		
		func startGame() {
			startGameCalled.toggle()
		}
		
		func restartGame() {
			restartGameCalled.toggle()
		}
		
		func handleTouchedCellWithData(_ cellData: FieldCell) {
			handledCellData = cellData
		}
		
		func handleDraggedCell(with data: [FieldCell]) {
			handledDraggedCell = data
		}
	}
}

class GamePresenterTests: XCTestCase {
	
	private var sut: GamePresenter!
	private let view = MockView()
	private let interactor = MockInteractor()
	
	override func setUp() {
		super.setUp()
		sut = GamePresenter()
		sut.view = view
		sut.interractor = interactor
	}
	
	override func tearDown() {
		sut = nil
		super.tearDown()
	}
	
    func testStartGame() {
		// Given
		XCTAssertFalse(interactor.startGameCalled)
		// When
		sut.startGame()
		// Then
		XCTAssertTrue(interactor.startGameCalled)
    }

    func testRestartGame() {
		// Given
		XCTAssertFalse(interactor.restartGameCalled)
		// When
		sut.restartGame()
		// Then
		XCTAssertTrue(interactor.restartGameCalled)
    }

    func testHandleTouchedCell() {
		// Given
		XCTAssertNil(interactor.handledCellData)
		let cellData = FieldCell(state: .placed)
		// When
		sut.handleTouchedCell(with: cellData)
		// Then
		XCTAssertEqual(cellData, interactor.handledCellData)
    }
	
	func testHandleDraggedCell() {
		// Given
		XCTAssertTrue(interactor.handledDraggedCell.isEmpty)
		let cellData = [FieldCell(state: .placed)]
		// When
		sut.handleDraggedCell(with: cellData)
		// Then
		XCTAssertEqual(cellData, interactor.handledDraggedCell)
	}

    func testGameOver() {
		// Given
		XCTAssertNil(view.scoreToShowInAlert)
		let score: Int32 = 16
		// When
		sut.gameOver(score: score)
		// Then
        XCTAssertEqual(view.scoreToShowInAlert, score)
    }

    func testProvideTetramonios() {
		// Given
		XCTAssertTrue(view.displayedTetramonios.isEmpty)
		let expectedTetramonios: [Tetramonio] = [
			Tetramonio(id: .iH,
					   tetramonioIndexes: [],
					   gameOverIndexes: [],
					   displayTetramonioIndexes: []),
			Tetramonio(id: .iV,
					   tetramonioIndexes: [],
					   gameOverIndexes: [],
					   displayTetramonioIndexes: [])]
		// When
		sut.provideTetramonios(expectedTetramonios)
		// Then
		XCTAssertEqual(view.displayedTetramonios, expectedTetramonios)
    }

    func testProvideField() {
		// Given
		XCTAssertTrue(view.displayedCellData.isEmpty)
		let expectedField: [FieldCell] = [
			FieldCell(state: .empty)]
		// When
		sut.provideField(expectedField)
		// Then
		XCTAssertEqual(view.displayedCellData, expectedField)
    }

	func testProvideScore() {
		// Given
		XCTAssertNil(view.displayedGameScore)
		let score = GameScore(current: 32, best: 32)
		// When
		sut.provideScore(score: score)
		// Then
		XCTAssertEqual(view.displayedGameScore.current, score.current)
		XCTAssertEqual(view.displayedGameScore.best, score.best)
    }
}