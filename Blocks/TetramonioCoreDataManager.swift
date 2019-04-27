//
//  TetramonioCoreDataManager.swift
//  Blocks
//
//  Created by Volodya on 6/5/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

typealias Score = Int32
typealias TetramonioIndex = Int16
typealias GameScore = (Score, Score)

protocol TetreamonioCoreDataManagerInput: class {
    func store(current tetramonios: [Tetramonio])
    func store(fieldCells: [CellData])
    func increaseAndStoreScore(_ score: Score, completion: @escaping (GameScore) -> Void)
    func restartGame(completion: (GameScore, [CellData]) -> Void)
    func createField() -> [CellData]
	
	/// Game Score
	var gameScore: GameScore { get }

    /// Current game score
    var currentScore: Score { get }

    /// Best game score
    var bestScore: Score { get }

    /// Current field
    var field: [CellData] { get }

    /// Current tetramonios
    var tetramoniosIndexes: [TetramonioIndex] { get }
}

/// This class responsable for storing fetching tetramonio from CoreData
class TetreamonioCoreDataManager {

    // MARK: - Properties

    fileprivate let coreDataManager: CoreDataManagerProtocol

    lazy fileprivate var game: Game? = {
        return self.coreDataManager.findFirstOrCreate(Game.self, predicate: nil)
    }()

    fileprivate var storedCells: [Cell] {
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

// MARK: - TetreamonioCoreDataManagerInput

extension TetreamonioCoreDataManager: TetreamonioCoreDataManagerInput {

    func store(current tetramonios: [Tetramonio]) {
        guard let firstTetramonio = tetramonios.first?.type.rawValue,
            let lastTetramono = tetramonios.last?.type.rawValue else {
                fatalError("You nedd to pass 2 teramonios")
        }

        game?.firstTetramonio = firstTetramonio
        game?.secondTetramonio = lastTetramono
        coreDataManager.save(game)
    }

    func store(fieldCells: [CellData]) {
        for (index, storedCell) in storedCells.enumerated() {
            let fieldCell = fieldCells[index]
            if storedCell.state != fieldCell.state.rawValue {
               storedCell.state = fieldCell.state.rawValue
               self.coreDataManager.save(storedCell)
            }
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

    func restartGame(completion: (GameScore, [CellData]) -> Void) {
        storedCells.forEach { (cell) in
            cell.state = 0
            coreDataManager.save(cell)
        }
        game?.score = 0
        coreDataManager.save(game)
        let field = storedCells.map({CellData(from: $0)})
        guard let game = game else {
            fatalError("Game instance can not be nil")
        }
        completion((game.score, game.bestScore), field)
    }

    func createField() -> [CellData] {

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

		return storedCells.compactMap({CellData(from: $0)})
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

    var field: [CellData] {
        return storedCells.isEmpty ? createField() : storedCells.map({CellData(from: $0)})
    }

    var tetramoniosIndexes: [TetramonioIndex] {
        guard let firstTetramonio =  game?.firstTetramonio,
            let lastTetramonio = game?.secondTetramonio, firstTetramonio != lastTetramonio else {
                return [Int16]()
        }
        return [firstTetramonio, lastTetramonio]
    }
}
