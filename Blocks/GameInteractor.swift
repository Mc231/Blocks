//
//  GameInfoInteractor.swift
//  Blocks
//
//  Created by Volodya on 2/9/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

protocol GameInteractorInput: class {
    func generateTetramoniosFor(_ type: GenerationType)
    func generateField()
    func restartGame()
    func getCurrentScore()
    func getMaxScore()
    func getCurrentTetramonios(_ tetramonios: ([Tetramonio]) -> ())
    func handleTouchedCellWithData(_ cellData: CellData)
    func setCurrentTetramonios(_ tetramonios: [Tetramonio])
}

protocol GameInteractorOutput: class {
    func provideTetramonios(_ tetramonios: [Tetramonio])
    func provideField(_ field: [CellData])
    func provideMaxScore(_ score: String)
    func provideCurrentScore(_ score: String)
    func updateCells(_ updatedData: [CellData])
}

class GameInteractor {
    
    // MARK: - Properties
    
    weak var presenter: GameInteractorOutput?
    var gameLogic: GameLogicManagerInput?
    var tetramoniomManager: TetramonioManager?
    var scoreManager: ScoreManagerProtocol?
}

// MARK: - GameInteractorInput

extension GameInteractor: GameInteractorInput {
    
    func generateTetramoniosFor(_ type: GenerationType) {
        guard let tetramonios = tetramoniomManager?.generateTetramonios(type) else {
            fatalError("Generated tetramonios could not be nil")
        }
        gameLogic?.updateTetramonios(tetramonios)
        presenter?.provideTetramonios(tetramonios)
    }
    
    func generateField() {
        guard let fieldData = gameLogic?.createField() else {
            fatalError("Field data could not be nil")
        }
        presenter?.provideField(fieldData)
    }
    
    func restartGame() {
        generateTetramoniosFor(.gameStart)
        presenter?.provideCurrentScore((scoreManager?.resetCurrentScore())!)
        gameLogic?.restartGame(callback: { (field) in
            presenter?.provideField(field)
        })
        // Change score to null
    }
    
    func getCurrentScore() {
        // Get score from user defaults or core data
        presenter?.provideCurrentScore((scoreManager?.getCurrentScore())!)
    }
    
    func getMaxScore() {
        // Get score from user defaults or core data
        presenter?.provideMaxScore((scoreManager?.getBestScore())!)
    }
    
    func getCurrentTetramonios(_ tetramonios: ([Tetramonio]) -> ()) {
        tetramoniomManager?.getTetramonios(tetramonios)
    }
    
    func handleTouchedCellWithData(_ cellData: CellData) {
        gameLogic?.updateField(with: cellData) { updatedCellData in
        presenter?.updateCells(updatedCellData)
        }
    }
    
    func setCurrentTetramonios(_ tetramonios: [Tetramonio]) {
        gameLogic?.updateTetramonios(tetramonios)
    }
}

// MARK: - GameLogicOutputDelegate 

extension GameInteractor: GameLogicManagerOutput {
  
    func gameLogicManager(_ gameLogicManager: GameLogicManagerInput, matchesTetramonio: Tetramonio?, matchIndex: Int) {
        guard let generationType = GenerationType(rawValue: matchIndex) else {
            fatalError("Generation type could not be nil")
        }
        generateTetramoniosFor(generationType)
    }
    
    func gameLogicManager(_ gameLogicManager: GameLogicManagerInput, gameOver: Bool) {
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
}
