//
//  GameAssemblerTests.swift
//  BlocksTests
//
//  Created by Volodymyr Shyrochuk on 30.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import XCTest
@testable import Blocks

// MARK: - Stubs

fileprivate class StubView: GameViewInput {
    var presenter: GameViewOutput?
    func display(tetramonios: [Tetramonio]) { }
    func display(field withData: [FieldCell]) { }
    func displayScore(score: GameScore) { }
    func showGameOverAlert(currentScore: Score) { }
}

fileprivate class StubPresenter: GameViewOutput, GameInteractorOutput {
    var view: GameViewInput?
    var interractor: GameInteractorInput?
    func startGame() { }
    func restartGame() { }
    func handleTouchedCell(with data: FieldCell) { }
    func handleDraggedCell(with data: [FieldCell]) { }
    func provideTetramonios(_ tetramonios: [Tetramonio]) { }
    func provideField(_ field: [FieldCell]) { }
    func provideScore(score: GameScore) { }
    func gameOver(score: Int32) { }
    func invalidateSelectedCells() { }
}

fileprivate class StubInteractor: GameInteractorInput, GameFlowOutput {
    var presenter: GameInteractorOutput?
    var gameFlow: GameFlowInput?
    func startGame() { }
    func restartGame() { }
    func handleTouchedCell(_ cellData: FieldCell) { }
    func handleDraggedCells(with data: [FieldCell]) { }
    func gameOver(currentScore: Score) { }
    func gameFlow(_ manager: GameFlowInput, didChange score: GameScore) { }
    func gameFlow(_ manager: GameFlowInput, didUpdate field: [FieldCell]) { }
    func gameFlow(_ manager: GameFlowInput, didUpdate tetramonios: [Tetramonio]) { }
    func invalidateSelectedCells() { }
}

class GameAssemblerTests: XCTestCase {

    func testAssembleDoesnotThrowError() {
        XCTAssertNoThrow(try GameAssembler())
    }
    
    func testAssembleModule() throws {
        // Given
        let view = StubView()
        let presenter = StubPresenter()
        let interactor = StubInteractor()
        // When
        let module = try GameAssembler(view: view, presenter: presenter, interactor: interactor, modelName: "")
        try module.assemble()
        // Then
        XCTAssertNotNil(presenter.view)
        XCTAssertNotNil(interactor.presenter)
        XCTAssertNotNil(view.presenter)
        XCTAssertNotNil(presenter.interractor)
        XCTAssertNotNil(interactor.gameFlow)
    }
}
