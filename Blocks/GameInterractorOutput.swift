//
//  GameInterractorOutput.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 4/30/19.
//  Copyright © 2019 QuasarClaster. All rights reserved.
//

import Foundation

protocol GameInteractorOutput: class {
	var interractor: GameInteractorInput? { get set }
	func provideTetramonios(_ tetramonios: [Tetramonio])
	func provideField(_ field: [CellData])
	func provideScore(gameScore: GameScore)
	func gameOver(currentScore: Int32)
}
