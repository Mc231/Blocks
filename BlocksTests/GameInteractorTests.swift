//
//  GameInteractorTests.swift
//  BlocksTests
//
//  Created by Volodymyr Shyrochuk on 04.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import XCTest
@testable import Blocks

private extension GameInteractorTests {
    
    class MockPresenter: GameInteractorOutput {
        var interractor: GameInteractorInput?
        var providedTetramonios: [Tetramonio] = []
        var providedFieldCells: [FieldCell] = []
        var providedScore: GameScore!
        var gameOverScore: Int32!
        
        func provideTetramonios(_ tetramonios: [Tetramonio]) {
            providedTetramonios = tetramonios
        }
        
        func provideField(_ field: [FieldCell]) {
            providedFieldCells = field
        }
        
        func provideScore(score: GameScore) {
            providedScore = score
        }
        
        func gameOver(score: Int32) {
            gameOverScore = score
        }
    }
    
    class MockGameFlow: GameFlowInput {
        
        var generationType: GenerationType!
        var generatedTeramoniosToReturn: [Tetramonio] = []
        var touchedCell: FieldCell!
        var draggedCells: [FieldCell] = []
        var startGameConfig: StartGameConfig!
		var restartGameConfig: RestartGameConfig!
        
        func generateTetramoniosOf(_ type: GenerationType) -> [Tetramonio] {
            generationType = type
            return generatedTeramoniosToReturn
        }
        
        func updateField(with handledCell: FieldCell) {
            touchedCell = handledCell
        }
        
        func updateField(with draggedCells: [FieldCell]) {
            self.draggedCells = draggedCells
        }
        
        func startGame() -> StartGameConfig {
            return startGameConfig
        }
        
		func restartGame() -> RestartGameConfig {
			return restartGameConfig
        }
    }
}

class GameInteractorTests: XCTestCase {
    
    private var sut: GameInteractor!
    private var presenter = MockPresenter()
    private var gameFlow = MockGameFlow()

    override func setUp() {
        super.setUp()
        sut = GameInteractor()
        sut.presenter = presenter
        sut.gameFlow = gameFlow
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testStartGame() {
        // Given
		let expectedConfig = StartGameConfig(tetramonios: [], fieldCells: [], score: .init(current: 1, best: 1))
		gameFlow.startGameConfig = expectedConfig
        XCTAssertTrue(presenter.providedTetramonios.isEmpty)
        XCTAssertTrue(presenter.providedFieldCells.isEmpty)
        XCTAssertNil(presenter.providedScore)
        // When
        sut.startGame()
		let config = gameFlow.startGame()
		// Then
		XCTAssertEqual(expectedConfig, config)
		XCTAssertEqual(presenter.providedTetramonios, config.tetramonios)
		XCTAssertEqual(presenter.providedFieldCells, config.fieldCells)
		XCTAssertEqual(presenter.providedScore, config.score)
    }
    
    func testRestartGame() {
        // Given
        let expectedConfig = RestartGameConfig(field: [], score: .init(current: 1, best: 1))
		gameFlow.restartGameConfig = expectedConfig
        XCTAssertTrue(presenter.providedFieldCells.isEmpty)
        XCTAssertNil(presenter.providedScore)
        // When
        sut.restartGame()
        // Then
        XCTAssertEqual(presenter.providedFieldCells, expectedConfig.field)
        XCTAssertEqual(presenter.providedScore, expectedConfig.score)
    }
	
    func testHandleTouchedCell() {
		// Given
		let cell = FieldCell(state: .empty)
		XCTAssertNil(gameFlow.touchedCell)
		// When
		sut.handleTouchedCell(cell)
		// Then
		XCTAssertEqual(gameFlow.touchedCell, cell)
    }
	
	func testHandleDraggedCells() {
		// Given
		let cells: [FieldCell] = []
		XCTAssertTrue(gameFlow.draggedCells.isEmpty)
		// When
		sut.handleDraggedCells(with: cells)
		// Then
		XCTAssertEqual(gameFlow.draggedCells, cells)
	}
	
    func testGameOver() {
		// Given
		let expectedScore: Score = 1
		XCTAssertNil(presenter.gameOverScore)
		// When
		sut.gameOver(currentScore: expectedScore)
		// Then
		XCTAssertEqual(presenter.gameOverScore, expectedScore)
    }

    func testGameFlowDidChangeScore() {
		// Given
		let expectedScore = GameScore(current: 1, best: 0)
		XCTAssertNil(presenter.providedScore)
		// When
		sut.gameFlow(gameFlow, didChange: expectedScore)
		// Then
		XCTAssertEqual(presenter.providedScore, expectedScore)
    }

    func testGameGameFlowDidUpdateField() {
		// Given
		let expectedFieldCells: [FieldCell] = []
		XCTAssertTrue(presenter.providedFieldCells.isEmpty)
		// When
		sut.gameFlow(gameFlow, didUpdate: expectedFieldCells)
		// Then
		XCTAssertEqual(presenter.providedFieldCells, expectedFieldCells)
    }

    func testGameFlowDidUpdateTetramonios() {
		// Given
		let expectedTetramonios: [Tetramonio] = []
		XCTAssertTrue(presenter.providedTetramonios.isEmpty)
		// When
		sut.gameFlow(gameFlow, didUpdate: expectedTetramonios)
		// Then
		XCTAssertEqual(presenter.providedTetramonios, expectedTetramonios)
    }
}
