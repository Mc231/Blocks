//
//  GameInfoAssambler.swift
//  Blocks
//
//  Created by Volodya on 2/16/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

class GameAssambler {
    
    private init () {}
    
    static let sharedInstance = GameAssambler()
    
    func configureGameInfoModule(view: GameViewController) {
        let presenter = GamePresenter()
        presenter.view = view
        let interractor = GameInteractor()
        interractor.presenter = presenter
        let tetramonioDataProvider = TetremonioDataProvider()
        let tetramonioManager = TetramonioManager(tetramonioDataProvider: tetramonioDataProvider)
        let gameLogic = GameLogicManager()
        let scoreManager = ScoreManager()
        view.presenter = presenter
        presenter.interractor = interractor
        interractor.gameLogic = gameLogic
        interractor.scoreManager = scoreManager
        gameLogic.interractor = interractor
        gameLogic.tetramoniomManager = tetramonioManager
    }
}
