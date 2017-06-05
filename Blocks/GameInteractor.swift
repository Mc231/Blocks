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
    func provideMaxScore(_ score: String)
    func provideCurrentScore(_ score: String)
}

class GameInteractor {
    
    // MARK: - Properties
    
    weak var presenter: GameInteractorOutput?
    var gameLogic: GameLogicManagerInput?
    var scoreManager: ScoreManagerProtocol?
}

// MARK: - GameInteractorInput

extension GameInteractor: GameInteractorInput {
    
    func startGame() {
        gameLogic?.startGame(completion: { (tetramonios, cellData, bestScore, currentScore) in
            presenter?.provideTetramonios(tetramonios)
            presenter?.provideField(cellData)
          //  presenter?.provideMaxScore(<#T##score: String##String#>)
           // presenter?.provideCurrentScore(<#T##score: String##String#>)
        })
    }
    
    func restartGame() {
        presenter?.provideCurrentScore((scoreManager?.resetCurrentScore())!)
        gameLogic?.restartGame(callback: { (field) in
            presenter?.provideField(field)
        })
        // Change score to null
    }
    
    func handleTouchedCellWithData(_ cellData: CellData) {
        gameLogic?.updateField(with: cellData) { updatedCellData in
        presenter?.provideField(updatedCellData)
        }
    }
}

// MARK: - GameLogicOutputDelegate 

extension GameInteractor: GameLogicManagerOutput {
    
    func gameOver() {
        debugPrint("Game is Over Vovan")
    }
    
    func gameLogicManager(_ gameLogicManager: GameLogicManagerInput, didChange score: Int) {
        // WARNING: - Refactore this 
            scoreManager?.setScore(score, callback: { (score, best, status) in
                if status {
                  presenter?.provideMaxScore(best)
                  presenter?.provideCurrentScore(score)
                }
            })
    }
    
    func gameLogicManager(_ gameLogicManager: GameLogicManagerInput, didUpdate field: [CellData]) {
        presenter?.provideField(field)
    }
    
    func gameLogicManager(_ manager: GameLogicManagerInput, didUpdate tetramonios: [Tetramonio]) {
        presenter?.provideTetramonios(tetramonios)
    }
}
