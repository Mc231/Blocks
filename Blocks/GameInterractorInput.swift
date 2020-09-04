//
//  GameInterractorInput.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 4/30/19.
//  Copyright © 2019 QuasarClaster. All rights reserved.
//

import Foundation

protocol GameInteractorInput: class {
	var presenter: GameInteractorOutput? { get set }
	func startGame()
	func restartGame()
	func handleTouchedCellWithData(_ cellData: FieldCell)
	func handleDraggedCell(with data: [FieldCell])
}
