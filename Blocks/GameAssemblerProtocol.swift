//
//  GameAssemblerProtocol.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 30.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import Foundation

protocol GameAssemblerProtocol {
    var coreDataManager: CoreDataManagerProtocol { get }
    var tetramonioGenerator: TetramonioGeneratable { get }
    var gameStorage: GameStorage { get }
    var gameFlow: GameFlowInput { get }
    var view: GameViewInput { get }
    var presenter: GameViewOutput & GameInteractorOutput { get }
    var interactor: GameInteractorInput & GameFlowOutput { get }
}
