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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
