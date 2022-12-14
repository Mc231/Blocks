//
//  GameInfoPresenter.swift
//  Blocks
//
//  Created by Volodya on 2/16/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

class GamePresenter {
    weak var view: GameViewInput?
    var interractor: GameInteractorInput?
}

// MARK: - GameViewOutput

extension GamePresenter: GameViewOutput {
    
    func startGame() {
        interractor?.startGame()
    }

    func restartGame() {
        interractor?.restartGame()
    }

    func handleTouchedCell(with data: FieldCell) {
        interractor?.handleTouchedCell(data)
    }
    
    func handleDraggedCell(with data: [FieldCell]) {
        interractor?.handleDraggedCells(with: data)
    }
    
    func invalidateSelectedCells() {
        interractor?.invalidateSelectedCells()
    }
}

// MARK: - GameInteractorOutput

extension GamePresenter: GameInteractorOutput {
    
    func gameOver(score: Int32) {
        view?.showGameOverAlert(currentScore: score)
    }

    func provideTetramonios(_ tetramonios: [Tetramonio]) {
        view?.display(tetramonios: tetramonios)
    }

    func provideField(_ field: [FieldCell]) {
        view?.display(field: field)
    }

    func provideScore(score: GameScore) {
        view?.displayScore(score: score)
    }
}
