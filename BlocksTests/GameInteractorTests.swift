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
        var providedField: [FieldCell] = []
        var providedScore: GameScore!
        var gameOverScore: Int32!
        
        func provideTetramonios(_ tetramonios: [Tetramonio]) {
            providedTetramonios = tetramonios
        }
        
        func provideField(_ field: [FieldCell]) {
            providedField = field
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
        var cellToUpdateField: FieldCell!
        var draggedCells: [FieldCell] = []
        var startGameConfig: StartGameConfig!
        var restartGameTuple: (GameScore, [FieldCell])!
        
        func generateTetramoniosOf(_ type: GenerationType) -> [Tetramonio] {
            generationType = type
            return generatedTeramoniosToReturn
        }
        
        func updateField(with handledCell: FieldCell) {
            cellToUpdateField = handledCell
        }
        
        func updateField(with draggedCells: [FieldCell]) {
            self.draggedCells = draggedCells
        }
        
        func startGame(completion: (StartGameConfig) -> Void) {
            completion(startGameConfig)
        }
        
        func restartGame(callback: @escaping (GameScore, [FieldCell]) -> Void) {
           // callback(restartGameTuple)
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
        let startGameConfig = (tetramonios: [], field: [], score: (current: 0, best: 1))
        XCTAssertTrue(presenter.providedTetramonios.isEmpty)
        XCTAssertTrue(presenter.providedField.isEmpty)
        XCTAssertNil(presenter.providedScore)
        // When
        sut.startGame()
        gameFlow.startGame { (config) in
            
        }
        // Then
        wait(for: [promise], timeout: 1.0)
    }
    
    func testRestartGame() {
        
    }
}
