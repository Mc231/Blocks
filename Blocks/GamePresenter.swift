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
    
    func startGame() {
        interractor?.startGame()
    }
    
    func restartGame() {
        interractor?.restartGame()
    }
    
    func handleTouchedCell(with data: CellData) {
        interractor?.handleTouchedCellWithData(data)
    }
    
    func provideTetramonios(_ tetramonios: [Tetramonio]) {
        view?.display(tetramonios: tetramonios)
    }
    
    func provideField(_ field: [CellData]) {
        view?.display(field: field)
    }
    
    func provideMaxScore(_ score: String) {
        view?.display(max: score)
    }
    
    func provideCurrentScore(_ score: String) {
        view?.display(current: score)
    }
}
