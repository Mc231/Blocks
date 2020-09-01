//
//  GameFlowOutput.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 4/30/19.
//  Copyright © 2019 QuasarClaster. All rights reserved.
//

import Foundation

protocol GameFlowOutput: class {
	func gameOver(currentScore: Score)
	func GameFlowManager(_ manager: GameFlowInput, didChange score: GameScore)
	func GameFlowManager(_ manager: GameFlowInput, didUpdate field: [CellData])
	func GameFlowManager(_ manager: GameFlowInput, didUpdate tetramonios: [Tetramonio])
}
