//
//  TetramonioCoreDataManager.swift
//  Blocks
//
//  Created by Volodya on 6/5/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

protocol GameStorage: class {
    func store(current tetramonios: [Tetramonio])
	func storeField(_ field: [FieldCell])
	func storeUpdatedCells(_ updatedCells: [FieldCell])
    func increaseAndStoreScore(_ score: Score, completion: @escaping (GameScore) -> Void)
    func restartGame(completion: (GameScore, [FieldCell]) -> Void)
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

/// This class responsable for storing & fetching game state from Core Data
class GameDbStore {

    // MARK: - Properties

    private let coreDataManager: CoreDataManagerProtocol

    lazy private var game: Game? = {
        return self.coreDataManager.findFirstOrCreate(Game.self, predicate: nil)
    }()

    private var storedCells: [Cell] {
        let xSortDesciptor = NSSortDescriptor(key: "xPosition", ascending: true)
        guard let fetchedCells
            = coreDataManager.fetch(Cell.self, predicate: nil, sortDescriptors: [xSortDesciptor]) else {
            return [Cell]()
        }
        return fetchedCells
    }

    // MARK: - Inizialization
    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
    }
}

// MARK: - GameDbStoreInput

extension GameDbStore: GameStorage {

    func store(current tetramonios: [Tetramonio]) {
        guard let firstTetramonio = tetramonios.first?.id.rawValue,
            let lastTetramono = tetramonios.last?.id.rawValue else {
                fatalError("You nedd to pass 2 teramonios")
        }

        game?.firstTetramonio = firstTetramonio
        game?.secondTetramonio = lastTetramono
        coreDataManager.save(game)
    }

    func storeField(_ field: [FieldCell]) {
        for (index, storedCell) in storedCells.enumerated() {
            let fieldCell = field[index]
            if storedCell.state != fieldCell.state.rawValue {
               storedCell.state = fieldCell.state.rawValue
               coreDataManager.save(storedCell)
            }
        }

        // Ensure theat everything saved
        coreDataManager.save(game)
    }
	
	// TODO: - Refactore & implement this
	func storeUpdatedCells(_ updatedCells: [FieldCell]) {
		for updatedCell in updatedCells {
			guard let storedCell = storedCells.first(where: {$0.xPosition == updatedCell.xPosition}) else {
				fatalError("Cell can not be nil")
			}
			storedCell.state = updatedCell.state.rawValue
			coreDataManager.save(storedCell)
		}
		
		// Ensure theat everything saved
		coreDataManager.save(game)
	}

    func increaseAndStoreScore(_ score: Score, completion: @escaping (GameScore) -> Void) {
        let newScore = self.currentScore + score
        var bestScore = self.bestScore
        if bestScore < newScore {
            bestScore = newScore
            game?.bestScore = bestScore
        }
        game?.score = newScore

        coreDataManager.save(game)
		let score = (newScore, bestScore)
        completion(score)
    }

    func restartGame(completion: (GameScore, [FieldCell]) -> Void) {
        storedCells.forEach { (cell) in
            cell.state = 0
            coreDataManager.save(cell)
        }
        game?.score = 0
        coreDataManager.save(game)
        let field = storedCells.map({FieldCell(from: $0)})
        guard let game = game else {
            fatalError("Game instance can not be nil")
        }
        completion((game.score, game.bestScore), field)
    }

    func createField() -> [FieldCell] {

        var x: Int16 = 0
        var y: Int16 = 0
        (0..<Constatns.Field.numberOfCellsOnField)
            .enumerated()
            .forEach { (_) in
                x += 1
                if x % 10 == 9 {
                    x += 2
                }
                y = x % 10

                guard let cell = coreDataManager.create(Cell.self) else {
                    fatalError("Failed to create cell")
                }
                cell.xPosition = x
                cell.yPosition = y
                cell.state = 0
                game?.addToCells(cell)
                coreDataManager.save(cell)
        }

        coreDataManager.save(game)

		return storedCells.compactMap({FieldCell(from: $0)})
    }
	
	var gameScore: GameScore {
		return (currentScore, bestScore)
	}

    var currentScore: Score {
        return game?.score ?? 0
    }

    var bestScore: Score {
        return game?.bestScore ?? 0
    }

    var field: [FieldCell] {
        return storedCells.isEmpty ? createField() : storedCells.map({FieldCell(from: $0)})
    }

    var tetramoniosIndexes: [TetramonioIndex] {
        guard let firstTetramonio =  game?.firstTetramonio,
            let lastTetramonio = game?.secondTetramonio, firstTetramonio != lastTetramonio else {
                return [Int16]()
        }
        return [firstTetramonio, lastTetramonio]
    }
}
