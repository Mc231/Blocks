//
//  GameStorage.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 16.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import Foundation

protocol GameStorage: AnyObject {
	@discardableResult
    func store(current tetramonios: [Tetramonio]) -> Bool
	func storeField(_ field: [FieldCell])
	func storeUpdatedCells(_ updatedCells: [FieldCell])
    func increaseAndStoreScore(by score: Score) -> GameScore
    func restartGame() -> RestartGameConfig
    func createField() -> [FieldCell]
	
	/// Game Score
	var gameScore: GameScore { get }

    /// Current game score
    var currentScore: Score { get }

    /// Best game score
    var bestScore: Score { get }

    /// Current field
    var field: [FieldCell] { get }

    /// Current tetramonios
    var tetramoniosIndexes: [TetramonioIndex] { get }
}
