//
//  GameViewOutput.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 4/30/19.
//  Copyright © 2019 QuasarClaster. All rights reserved.
//

import Foundation

protocol GameViewOutput {
	var view: GameViewInput? { get set }
	func startGame()
	func restartGame()
    func invalidateSelectedCells()
	func handleTouchedCell(with data: FieldCell)
	func handleDraggedCell(with data: [FieldCell])
}
