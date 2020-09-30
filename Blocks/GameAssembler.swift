//
//  GameInfoAssambler.swift
//  Blocks
//
//  Created by Volodya on 2/16/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

class GameAssembler: GameAssemblerProtocol {
    
    var coreDataManager: CoreDataManagerProtocol
    var tetramonioGenerator: TetramonioGeneratable
    var view: GameViewInput
    var presenter: GameInteractorOutput & GameViewOutput
    var interactor: GameFlowOutput & GameInteractorInput
    
    var gameStorage: GameStorage {
        return GameCoreDataStorage(coreDataManager: coreDataManager)
    }
    
    var gameFlow: GameFlowInput {
        return GameFlow(interactor: interactor,
                        tetramonioGenerator: tetramonioGenerator,
                        storage: gameStorage)
    }
    
    init(view: GameViewInput = GameViewController.load(),
         presenter: GamePresenter = GamePresenter(),
         interactor: GameInteractor = GameInteractor(),
         modelName: String = "Blocks") throws {
        self.view = view
        self.presenter = presenter
        self.interactor = interactor
        self.coreDataManager = CoreDataManager(modelName: modelName)
        let loader = TetramonioLoader()
        self.tetramonioGenerator = try TetramonioGenerator(loader: loader)
    }
    
    func assemble() throws {
        presenter.view = view
        interactor.presenter = presenter
        view.presenter = presenter
        presenter.interractor = interactor
        interactor.gameFlow = gameFlow
    }
}
