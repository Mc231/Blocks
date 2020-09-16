//
//  GameInfoAssambler.swift
//  Blocks
//
//  Created by Volodya on 2/16/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

class GameAssambler {
	
	// MARK: - Constants

	private static let kDbName = "Blocks"

	// MARK: - Class methods

    class func assamble(in view: GameViewController) {

        let presenter = GamePresenter()
        presenter.view = view

        let interactor = GameInteractor()
        interactor.presenter = presenter

        let tetramonioLoader = TetramonioLoader()
		// TODO: - Remove force unwrup
        let tetramonioGenerator = try! TetramonioGenerator(loader: tetramonioLoader)
        let coreDataManager = CoreDataManager(modelName: kDbName)
        let dbStorage = GameCoreDataStorage(coreDataManager: coreDataManager)
        let gameFlow = GameFlow(interactor: interactor,
								tetramonioGenerator: tetramonioGenerator,
								storage: dbStorage)
        view.presenter = presenter
        presenter.interractor = interactor
        interactor.gameFlow = gameFlow

    }
}
