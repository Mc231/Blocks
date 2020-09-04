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
	func gameFlow(_ manager: GameFlowInput, didChange score: GameScore)
	func gameFlow(_ manager: GameFlowInput, didUpdate field: [FieldCell])
	func gameFlow(_ manager: GameFlowInput, didUpdate tetramonios: [Tetramonio])
}
