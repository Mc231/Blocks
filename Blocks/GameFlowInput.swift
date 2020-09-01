//
//  GameFlowInput.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 4/30/19.
//  Copyright © 2019 QuasarClaster. All rights reserved.
//

import Foundation

protocol GameFlowInput {
	func generateTetramoniosFor(_ type: GenerationType) -> [Tetramonio]
	func updateField(with handledCell: CellData)
	func updateField(with draggedCells: [CellData])
	func startGame(completion: (StartGameConfig) -> Swift.Void)
	func restartGame(callback: @escaping (GameScore, [CellData]) -> Void)
}
