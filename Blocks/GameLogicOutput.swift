//
//  GameLogicOutput.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 4/30/19.
//  Copyright © 2019 QuasarClaster. All rights reserved.
//

import Foundation

protocol GameLogicOutput: class {
	func gameOver(currentScore: Score)
	func gameLogicManager(_ manager: GameLogicInput, didChange score: GameScore)
	func gameLogicManager(_ manager: GameLogicInput, didUpdate field: [CellData])
	func gameLogicManager(_ manager: GameLogicInput, didUpdate tetramonios: [Tetramonio])
}
