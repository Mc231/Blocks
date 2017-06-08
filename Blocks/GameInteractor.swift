//
//  GameInfoInteractor.swift
//  Blocks
//
//  Created by Volodya on 2/9/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

protocol GameInteractorInput: class {
    func startGame()
    func restartGame()
    func handleTouchedCellWithData(_ cellData: CellData)
}

protocol GameInteractorOutput: class {
    func provideTetramonios(_ tetramonios: [Tetramonio])
    func provideField(_ field: [CellData])
    func provideScore(current: Int32, best: Int32)
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
        gameLogic?.startGame(completion: { [weak self] (tetramonios, cellData, currentScore, bestScore) in
            
            guard let strongSelf = self else {
                return
            }
            strongSelf.presenter?.provideTetramonios(tetramonios)
            strongSelf.presenter?.provideField(cellData)
            strongSelf.presenter?.provideScore(current: currentScore, best: bestScore)
        })
    }
    
    func restartGame() {
        gameLogic?.restartGame(callback: { [weak self] (score, bestScore, field) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.presenter?.provideScore(current: score, best: bestScore)
            strongSelf.presenter?.provideField(field)
        })
    }
    
    func handleTouchedCellWithData(_ cellData: CellData) {
        gameLogic?.updateField(with: cellData) { updatedCellData in
        presenter?.provideField(updatedCellData)
        }
    }
}

// MARK: - GameLogicOutputDelegate 

extension GameInteractor: GameLogicManagerOutput {
    
    func gameOver(currentScore: Int32) {
        debugPrint("Game Over")
        presenter?.gameOver(currentScore: currentScore)
    }
    
    func gameLogicManager(_ manager: GameLogicManagerInput, didChange score: Int32, and bestScore: Int32) {
        presenter?.provideScore(current: score, best: bestScore)
    }
    
    func gameLogicManager(_ gameLogicManager: GameLogicManagerInput, didUpdate field: [CellData]) {
        presenter?.provideField(field)
    }
    
    func gameLogicManager(_ manager: GameLogicManagerInput, didUpdate tetramonios: [Tetramonio]) {
        presenter?.provideTetramonios(tetramonios)
    }
}
