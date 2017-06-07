//
//  GameInfoAssambler.swift
//  Blocks
//
//  Created by Volodya on 2/16/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

class GameAssambler {
    
    
    class func configureGameModule(in view: GameViewController) {
        let presenter = GamePresenter()
        presenter.view = view
        let interractor = GameInteractor()
        interractor.presenter = presenter
        let tetramonioDataProvider = TetremonioDataProvider()
        let tetramonioManager = TetramonioManager(tetramonioDataProvider: tetramonioDataProvider)
        let gameLogic = GameLogicManager()
        view.presenter = presenter
        presenter.interractor = interractor
        interractor.gameLogic = gameLogic
        let coreDataManager = CoreDataManager(modelName: "Blocks")
        gameLogic.interractor = interractor
        gameLogic.tetramoniosManager = tetramonioManager
        gameLogic.tetramonioCoreDataManager = TetreamonioCoreDataManager(coreDataManager: coreDataManager)
    }
}
