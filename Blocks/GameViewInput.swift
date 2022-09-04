//
//  GameViewInput.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 4/30/19.
//  Copyright © 2019 QuasarClaster. All rights reserved.
//

import Foundation

protocol GameViewInput: AnyObject {
	var presenter: GameViewOutput? { get set }
	func display(tetramonios: [Tetramonio])
	func display(field withData: [FieldCell])
	func displayScore(score: GameScore)
	func showGameOverAlert(currentScore: Score)
}
