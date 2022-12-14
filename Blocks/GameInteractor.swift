//
//  GameInfoInteractor.swift
//  Blocks
//
//  Created by Volodya on 2/9/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

class GameInteractor {

    // MARK: - Properties

    weak var presenter: GameInteractorOutput?
    var gameFlow: GameFlowInput?
}

// MARK: - GameInteractorInput

extension GameInteractor: GameInteractorInput {
    
    func invalidateSelectedCells() {
        gameFlow?.invalidateSelectedCells()
    }
	
    func startGame() {
        if let config = gameFlow?.startGame() {
            presenter?.provideTetramonios(config.tetramonios)
            presenter?.provideField(config.fieldCells)
            presenter?.provideScore(score: config.score)
        }
    }

    func restartGame() {
        if let restartGameConfig = gameFlow?.restartGame() {
            presenter?.provideScore(score: restartGameConfig.score)
            presenter?.provideField(restartGameConfig.field)
        }
    }

    func handleTouchedCell(_ cellData: FieldCell) {
        gameFlow?.updateField(with: cellData)
    }
	
	func handleDraggedCells(with data: [FieldCell]) {
		gameFlow?.updateField(with: data)
	}
}

// MARK: - GameFlowOutputDelegate 

extension GameInteractor: GameFlowOutput {

    func gameOver(currentScore: Score) {
        presenter?.gameOver(score: currentScore)
    }

    func gameFlow(_ manager: GameFlowInput, didChange score: GameScore) {
        presenter?.provideScore(score: score)
    }

    func gameFlow(_ GameFlowManager: GameFlowInput, didUpdate field: [FieldCell]) {
        presenter?.provideField(field)
    }

    func gameFlow(_ manager: GameFlowInput, didUpdate tetramonios: [Tetramonio]) {
        presenter?.provideTetramonios(tetramonios)
    }
}
