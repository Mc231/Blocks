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
        guard let tetramonios = tetramoniomManager?.generateTetramonios() else {
            fatalError("Generated tetramonios could not be nil")
        }
         gameLogic?.setCurrentTetramonios(tetramonios)
         presenter?.provideTetramonios(tetramonios)
    }
    
    func generateField() {
        guard let fieldData = gameLogic?.createField() else {
            fatalError("Field data could not be nil")
        }
        presenter.provideField(fieldData)
    }
    
    func restartGame() {
        generateTetramoniosFromManager()
        presenter?.provideCurrentScore(12)
        // Change score to null
    }
    
    func getCurrentScore() {
        // Get score from user defaults or core data
        presenter?.provideCurrentScore(231)
    }
    
    func getMaxScore() {
           // Get score from user defaults or core data
        presenter?.provideMaxScore(231)
    }
    
    func getCurrentTetramonios(_ tetramonios: ([Tetramonio]) -> ()) {
     //   tetramoniomManager?.getTetramonios(tetramonios)
    }
    
    func handleTouchedCellWithData(_ cellData: CellData) {
        gameLogic?.updateField(with: cellData) { updatedCellData in
        presenter?.updateCells(updatedCellData)
        }
    }
    
    func setCurrentTetramonios(_ tetramonios: [Tetramonio]) {
        gameLogic?.setCurrentTetramonios(tetramonios)
    }
}
