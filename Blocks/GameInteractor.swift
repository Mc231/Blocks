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
    var GameFlow: GameFlowInput?
}

// MARK: - GameInteractorInput

extension GameInteractor: GameInteractorInput {
	
    func startGame() {
        GameFlow?.startGame(completion: { [weak self] (tetramonios, cellData, score) in

            guard let strongSelf = self else {
                return
            }
            strongSelf.presenter?.provideTetramonios(tetramonios)
            strongSelf.presenter?.provideField(cellData)
            strongSelf.presenter?.provideScore(gameScore: score)
        })
    }

    func restartGame() {
        GameFlow?.restartGame(callback: { [weak self] (score, field) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.presenter?.provideScore(gameScore: score)
            strongSelf.presenter?.provideField(field)
        })
    }

    func handleTouchedCellWithData(_ cellData: CellData) {
        GameFlow?.updateField(with: cellData)
    }
	
	func handleDraggedCell(with data: [CellData]) {
		GameFlow?.updateField(with: data)
	}
}

// MARK: - GameFlowOutputDelegate 

extension GameInteractor: GameFlowOutput {

    func gameOver(currentScore: Score) {
        debugPrint("Game Over")
        presenter?.gameOver(currentScore: currentScore)
    }

    func GameFlowManager(_ manager: GameFlowInput, didChange score: GameScore) {
        presenter?.provideScore(gameScore: score)
    }

    func GameFlowManager(_ GameFlowManager: GameFlowInput, didUpdate field: [CellData]) {
        presenter?.provideField(field)
    }

    func GameFlowManager(_ manager: GameFlowInput, didUpdate tetramonios: [Tetramonio]) {
        presenter?.provideTetramonios(tetramonios)
    }
}
