//
//  GameInfoPresenter.swift
//  Blocks
//
//  Created by Volodya on 2/16/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

protocol GamePresenterInput: GameViewOutput, GameInteractorOutput {
    
}

class GamePresenter: GamePresenterInput {
    
    weak var view: GameViewInput?
    var interractor: GameInteractorInput?
    
    func generateTetramoniosForGameStart() {
        interractor?.generateTetramonios(generationType: .gameStart)
    }
    
    func provideTetramonios(_ tetramonios: [Tetramonio]) {
        view?.display(tetramonios: tetramonios)
    }
    
    func createField() {
        interractor?.generateField()
    }
    
    func provideField(_ field: [CellData]) {
        view?.display(field: field)
    }
    
    func provideMaxScore(_ score: Int) {
        view?.display(max: score)
    }
    
    func provideCurrentScore(_ score: Int) {
        view?.display(current: score)
    }
    
    func restartGame() {
        interractor?.restartGame()
    }
    
    func getMaxScore() {
        interractor?.getMaxScore()
    }
    
    func getCurrentScore() {
        interractor?.getCurrentScore()
    }
    
    func provideCurrentTetramonios(_ tetramonios: ([Tetramonio]) -> ()) {
        interractor?.getCurrentTetramonios(tetramonios)
    }
    
    func handleTouchedCell(with data: CellData) {
        interractor?.handleTouchedCellWithData(data)
    }
    
    func updateCells(_ updatedData: [CellData]) {
        view?.update(cellData: updatedData)
    }
}
