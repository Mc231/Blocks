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
        let manager = TetramonioManager()
        view.presenter = presenter
        presenter.interractor = interractor
        interractor.tetramoniomManager = manager
    }
}
