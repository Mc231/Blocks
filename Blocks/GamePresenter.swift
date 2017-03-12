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

class GameInfoPresenter: GamePresenterInput {
    
    weak var view: GameViewInput?
    var interractor: GameInfoInteractorInput?
    
    func generateTetramonios() {
        interractor?.generateTetramoniosFromManager()
    }
    
    func provideTetramonios(_ tetramonios: [Tetramonio]) {
        view?.displayTetramonios(tetramonios)
    }
    
    func provideMaxScore(_ score: Int) {
        view?.displayMaxScore(score)
    }
    
    func provideCurrentScore(_ score: Int) {
        view?.displayCurrentScore(score)
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
}
