//
//  GameFlowInput.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 4/30/19.
//  Copyright © 2019 QuasarClaster. All rights reserved.
//

import Foundation

protocol GameFlowInput {
	func generateTetramoniosOf(_ type: GenerationType) -> [Tetramonio]
	func updateField(with handledCell: FieldCell)
	func updateField(with draggedCells: [FieldCell])
	func startGame(completion: (StartGameConfig) -> Swift.Void)
	func restartGame(callback: @escaping (GameScore, [FieldCell]) -> Void)
}
