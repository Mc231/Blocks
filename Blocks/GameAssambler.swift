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

        let interractor = GameInteractor()
        interractor.presenter = presenter

        let tetramonioLoader = TetramonioLoader()
		// TODO: - Remove force unwrup
        let tetramonioGenerator = try! TetramonioGenerator(loader: tetramonioLoader)
        let coreDataManager = CoreDataManager(modelName: kDbName)
        let dbStore = GameDbStore(coreDataManager: coreDataManager)
        let gameFlow = GameFlow(interractor: interractor,
								tetramonioGenerator: tetramonioGenerator,
								tetramonioCoreDataManager: dbStore)
        view.presenter = presenter
        presenter.interractor = interractor
        interractor.gameFlow = gameFlow

    }
}
