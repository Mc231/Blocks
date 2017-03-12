//
//  GameInfoInteractor.swift
//  Blocks
//
//  Created by Volodya on 2/9/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

protocol GameInteractorInput: class {
    func generateTetramoniosFromManager()
    func restartGame()
    func getCurrentScore()
    func getMaxScore()
    func getCurrentTetramonios(_ tetramonios: ([Tetramonio]) -> ())
    func handleTouchedCellWithData(_ cellData: CellData)
    func setCurrentTetramonios(_ tetramonios: [Tetramonio])
}

protocol GameInteractorOutput: class {
    func provideTetramonios(_ tetramonios: [Tetramonio])
    func provideMaxScore(_ score: Int)
    func provideCurrentScore(_ score: Int)
    func updateCells(_ updatedData: [CellData])
}

class GameInteractor: GameInteractorInput {
    
    weak var presenter: GameInteractorOutput!
    
    var gameLogic: GameLogicInput?
    var tetramoniomManager: TetramonioManager?
    var scoreManager: ScoreManagerProtocol?
    
    func generateTetramoniosFromManager() {
         let tetramonios = tetramoniomManager?.generateTetramonios()
         presenter?.provideTetramonios(tetramonios)
    }
    
    func restartGame() {
        generateTetramoniosFromManager()
        presenter?.provideCurrentScore(0)
        // Change score to null
    }
    
    func getCurrentScore() {
        // Get score from user defaults or core data
        presenter?.provideCurrentScore(0)
    }
    
    func getMaxScore() {
           // Get score from user defaults or core data
        presenter?.provideMaxScore(0)
    }
    
    func getCurrentTetramonios(_ tetramonios: ([Tetramonio]) -> ()) {
        tetramoniomManager?.getTetramonios(tetramonios)
    }
    
    func handleTouchedCellWithData(_ cellData: CellData) {
        gameLogic?.handleCurrentTetramonioData(tetramonioData: cellData) { updatedCellData in
            presenter?.updateCells(updatedCellData)
        }
    }
    
    func setCurrentTetramonios(_ tetramonios: [Tetramonio]) {
        gameLogic?.setCurrentTetramonios(tetramonios)
    }
}
