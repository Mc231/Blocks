//
//  GameInfoPresenter.swift
//  Blocks
//
//  Created by Volodya on 2/16/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

class GamePresenter: GamePresenterInput {
	
    weak var view: GameViewInput?
    var interractor: GameInteractorInput?

    func startGame() {
        interractor?.startGame()
    }

    func restartGame() {
        interractor?.restartGame()
    }

    func handleTouchedCell(with data: CellData) {
        interractor?.handleTouchedCellWithData(data)
    }
	
	func handleDraggedCell(with data: [CellData]) {
		interractor?.handleDraggedCell(with: data)
	}

    func gameOver(currentScore: Int32) {
        view?.showGameOverAlert(currentScore: currentScore)
    }

    func provideTetramonios(_ tetramonios: [Tetramonio]) {
        view?.display(tetramonios: tetramonios)
    }

    func provideField(_ field: [CellData]) {
        view?.display(field: field)
    }

	func provideScore(gameScore: GameScore) {
		view?.displayScore(score: gameScore)
    }
}
