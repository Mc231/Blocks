//
//  GameInfoInteractor.swift
//  Blocks
//
//  Created by Volodya on 2/9/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

protocol GameInteractorInput: class {
	var presenter: GameInteractorOutput? { get set }
    func startGame()
    func restartGame()
    func handleTouchedCellWithData(_ cellData: CellData)
	func handleDraggedCell(with data: [CellData])
}

protocol GameInteractorOutput: class {
	var interractor: GameInteractorInput? { get set }
    func provideTetramonios(_ tetramonios: [Tetramonio])
    func provideField(_ field: [CellData])
	func provideScore(gameScore: GameScore)
    func gameOver(currentScore: Int32)
}

class GameInteractor {

    // MARK: - Properties

    weak var presenter: GameInteractorOutput?
    var gameLogic: GameLogicManagerInput?
}

// MARK: - GameInteractorInput

extension GameInteractor: GameInteractorInput {
	
    func startGame() {
        gameLogic?.startGame(completion: { [weak self] (tetramonios, cellData, score) in

            guard let strongSelf = self else {
                return
            }
            strongSelf.presenter?.provideTetramonios(tetramonios)
            strongSelf.presenter?.provideField(cellData)
            strongSelf.presenter?.provideScore(gameScore: score)
        })
    }

    func restartGame() {
        gameLogic?.restartGame(callback: { [weak self] (score, field) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.presenter?.provideScore(gameScore: score)
            strongSelf.presenter?.provideField(field)
        })
    }

    func handleTouchedCellWithData(_ cellData: CellData) {
        gameLogic?.updateField(with: cellData)
    }
	
	func handleDraggedCell(with data: [CellData]) {
		gameLogic?.updateField(with: data)
	}
}

// MARK: - GameLogicOutputDelegate 

extension GameInteractor: GameLogicManagerOutput {

    func gameOver(currentScore: Score) {
        debugPrint("Game Over")
        presenter?.gameOver(currentScore: currentScore)
    }

    func gameLogicManager(_ manager: GameLogicManagerInput, didChange score: GameScore) {
        presenter?.provideScore(gameScore: score)
    }

    func gameLogicManager(_ gameLogicManager: GameLogicManagerInput, didUpdate field: [CellData]) {
        presenter?.provideField(field)
    }

    func gameLogicManager(_ manager: GameLogicManagerInput, didUpdate tetramonios: [Tetramonio]) {
        presenter?.provideTetramonios(tetramonios)
    }
}
