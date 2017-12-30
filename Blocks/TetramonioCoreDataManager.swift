//
//  TetramonioCoreDataManager.swift
//  Blocks
//
//  Created by Volodya on 6/5/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

protocol TetreamonioCoreDataManagerInput: class {
    func store(current tetramonios: [Tetramonio])
    func store(fieldCells: [CellData])
    func increaseAndStoreScore(for quantity: Int32, completion: @escaping (Int32, Int32) -> ())
    func restartGame(completion: (Int32, Int32, [CellData]) -> ())
    func createField() -> [CellData]
    
    /// Current game score
    var currentScore: Int32 { get }
    
    /// Best game score
    var bestScore: Int32 { get }
    
    /// Current field
    var field: [CellData] { get }
    
    /// Current tetramonios
    var tetramoniosIndexes: [Int16] { get }
}

/// This class responsable for storing fetching tetramonio from CoreData
class TetreamonioCoreDataManager {
    
    // MARK: - Properties

    fileprivate let coreDataManager: CoreDataManagerProtocol
    
    lazy fileprivate var game: Game? = {
        return self.coreDataManager.findFirstOrCreate(Game.self, predicate: nil)
    }()
    
    fileprivate var storedCells: [Cell] {
        let xSortDesciptor = NSSortDescriptor(key: "x", ascending: true)
        guard let fetchedCells = coreDataManager.fetch(Cell.self, predicate: nil, sortDescriptors: [xSortDesciptor]) else {
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
        guard let firstTetramonio = tetramonios.first?.id.rawValue,
            let lastTetramono = tetramonios.last?.id.rawValue else {
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
    
    func increaseAndStoreScore(for quantity: Int32, completion: @escaping (Int32, Int32) -> ()) {
        let newScore = self.currentScore + quantity
        var bestScore = self.bestScore
        
        if bestScore < newScore {
            bestScore = newScore
            game?.bestScore = bestScore
        }
        game?.score = newScore
        
        coreDataManager.save(game)
        completion(newScore, bestScore)
    }
    
    func restartGame(completion: (Int32, Int32, [CellData]) -> ()) {
        
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
        
        completion(game.score, game.bestScore, field)
    }
    
    func createField() -> [CellData] {

        var x: Int16 = 0
        var y: Int16 = 0
        
        (0..<Constatns.Field.numberOfCellsOnField)
            .enumerated()
            .forEach { (loopData) in
                x += 1
                if (x % 10 == 9) {
                    x = x+2
                }
                y = x % 10
                
                guard let cell = coreDataManager.create(Cell.self) else {
                    fatalError("Failed to create cell")
                }
                cell.x = x
                cell.y = y
                cell.state = 0
                game?.addToCells(cell)
                coreDataManager.save(cell)
        }
      
        coreDataManager.save(game)
        
        return storedCells.flatMap({CellData(from: $0)})
    }
    
    var currentScore: Int32 {
        return game?.score ?? 0
    }
    
    var bestScore: Int32 {
        return game?.bestScore ?? 0
    }
    
    var field: [CellData] {
        return storedCells.isEmpty ? createField() : storedCells.map({CellData(from: $0)})
    }
    
    var tetramoniosIndexes: [Int16] {
        guard let firstTetramonio =  game?.firstTetramonio,
            let lastTetramonio = game?.secondTetramonio, firstTetramonio != lastTetramonio else {
                return [Int16]()
        }
        return [firstTetramonio, lastTetramonio]
    }
}
