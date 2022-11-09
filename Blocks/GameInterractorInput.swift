//
//  GameInterractorInput.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 4/30/19.
//  Copyright © 2019 QuasarClaster. All rights reserved.
//

import Foundation

protocol GameInteractorInput: AnyObject {
	var presenter: GameInteractorOutput? { get set }
    var gameFlow: GameFlowInput? { get set }
	func startGame()
	func restartGame()
	func handleTouchedCell(_ cellData: FieldCell)
	func handleDraggedCells(with data: [FieldCell])
    func invalidateSelectedCells()
}
