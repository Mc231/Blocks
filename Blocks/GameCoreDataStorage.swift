//
//  TetramonioCoreDataManager.swift
//  Blocks
//
//  Created by Volodya on 6/5/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

/// This class responsable for storing & fetching game state from Core Data
class GameCoreDataStorage: GameStorage {

	// MARK: - Constatns
	
	private static let numOfGeneratedTetramonios = 2
	
    // MARK: - Properties

    private let coreDataManager: CoreDataManagerProtocol

    lazy private var game: Game? = {
        return self.coreDataManager.findFirstOrCreate(Game.self, predicate: nil)
    }()

    private var storedCells: [Cell] {
        let xSortDesciptor = NSSortDescriptor(key: "xPosition", ascending: true)
        return coreDataManager.fetch(Cell.self, predicate: nil, sortDescriptors: [xSortDesciptor])
    }
	
	var gameScore: GameScore {
        return GameScore(current: currentScore, best: bestScore)
	}

    var currentScore: Score {
        return game!.score
    }

    var bestScore: Score {
        return game!.bestScore
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

    // MARK: - Inizialization
	
    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
    }
	
	@discardableResult
    func store(current tetramonios: [Tetramonio]) -> Bool {
		if tetramonios.count != Self.numOfGeneratedTetramonios {
			print("Attempt to store invalid number of tetramonios")
			return false
		}

        game?.firstTetramonio = tetramonios.first!.id.rawValue
        game?.secondTetramonio = tetramonios.last!.id.rawValue
        coreDataManager.save(game)
		return true
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
	
	func storeUpdatedCells(_ updatedCells: [FieldCell]) {
		for updatedCell in updatedCells {
			let storedCell = storedCells.first(where: {$0.xPosition == updatedCell.xPosition})
			storedCell?.state = updatedCell.state.rawValue
			coreDataManager.save(storedCell)
		}
		// Ensure theat everything saved
		coreDataManager.save(game)
	}

    func increaseAndStoreScore(by score: Score) -> GameScore {
        let newScore = self.currentScore + score
        var bestScore = self.bestScore
        if bestScore < newScore {
            bestScore = newScore
            game?.bestScore = bestScore
        }
        game?.score = newScore
        coreDataManager.save(game)
        let score = GameScore(current: newScore, best: bestScore)
        return score
    }

    func restartGame() -> RestartGameConfig {
        storedCells.forEach { (cell) in
            cell.state = 0
            coreDataManager.save(cell)
        }
        game?.score = 0
        coreDataManager.save(game)
        let field = storedCells.map({FieldCell(from: $0)})
        let score = GameScore(current: currentScore, best: bestScore)
		let config = RestartGameConfig(field: field, score: score)
        return config
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
                let cell = coreDataManager.create(Cell.self)
                cell?.xPosition = x
                cell?.yPosition = y
                cell?.state = FieldCell.State.empty.rawValue
                game?.addToCells(cell!)
                coreDataManager.save(cell)
        }
        coreDataManager.save(game)
		return storedCells.compactMap({FieldCell(from: $0)})
    }
}
