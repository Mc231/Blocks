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
	
    func startGame() {
        gameFlow?.startGame(completion: { [weak self] (tetramonios, cellData, score) in
            self?.presenter?.provideTetramonios(tetramonios)
            self?.presenter?.provideField(cellData)
            self?.presenter?.provideScore(gameScore: score)
        })
    }

    func restartGame() {
        gameFlow?.restartGame(callback: { [weak self] (score, field) in
            self?.presenter?.provideScore(gameScore: score)
            self?.presenter?.provideField(field)
        })
    }

    func handleTouchedCellWithData(_ cellData: CellData) {
        gameFlow?.updateField(with: cellData)
    }
	
	func handleDraggedCell(with data: [CellData]) {
		gameFlow?.updateField(with: data)
	}
}

// MARK: - GameFlowOutputDelegate 

extension GameInteractor: GameFlowOutput {

    func gameOver(currentScore: Score) {
        debugPrint("Game Over")
        presenter?.gameOver(currentScore: currentScore)
    }

    func gameFlow(_ manager: GameFlowInput, didChange score: GameScore) {
        presenter?.provideScore(gameScore: score)
    }

    func gameFlow(_ GameFlowManager: GameFlowInput, didUpdate field: [CellData]) {
        presenter?.provideField(field)
    }

    func gameFlow(_ manager: GameFlowInput, didUpdate tetramonios: [Tetramonio]) {
        presenter?.provideTetramonios(tetramonios)
    }
}
