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
		var restartGameConfig: (score: GameScore, fieldCells: [FieldCell])!
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
        
        func startGame(completion: (StartGameConfig) -> Void) {
            completion(startGameConfig)
        }
        
		func restartGame(callback: @escaping (GameScore, [FieldCell]) -> Void) {
			callback(restartGameConfig.score, restartGameConfig.fieldCells)
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
        let promise = expectation(description: "Waiting for game start")
		let startGameConfig = StartGameConfig(tetramonios: [], fieldCells: [], score: .init(current: 1, best: 1))
		gameFlow.startGameConfig = startGameConfig
        XCTAssertTrue(presenter.providedTetramonios.isEmpty)
        XCTAssertTrue(presenter.providedFieldCells.isEmpty)
        XCTAssertNil(presenter.providedScore)
        // When
        sut.startGame()
        gameFlow.startGame { (config) in
			XCTAssertEqual(self.presenter.providedTetramonios, config.tetramonios)
			XCTAssertEqual(self.presenter.providedFieldCells, config.fieldCells)
			XCTAssertEqual(self.presenter.providedScore, config.score)
			promise.fulfill()
        }
        // Then
        wait(for: [promise], timeout: 1.0)
    }
    
    func testRestartGame() {
        // Given
        let promise = expectation(description: "Waiting for game restart")
		let restartGameConfig = (score: GameScore(current: 1, best: 1	), fieldCells: [FieldCell]())
		gameFlow.restartGameConfig = restartGameConfig
        XCTAssertTrue(presenter.providedFieldCells.isEmpty)
        XCTAssertNil(presenter.providedScore)
        // When
        sut.restartGame()
        gameFlow.restartGame { (score, fieldCells) in
			XCTAssertEqual(self.presenter.providedFieldCells, fieldCells)
			XCTAssertEqual(self.presenter.providedScore, score)
			promise.fulfill()
        }
        // Then
        wait(for: [promise], timeout: 1.0)
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
