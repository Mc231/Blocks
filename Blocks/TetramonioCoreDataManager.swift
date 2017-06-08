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
    func increaseAndStoreScore(for quantity: Int, completion: @escaping (Int32, Int32) -> ())
    func getCurrentScore() -> Int32
    func getBestScore() -> Int32
    func getFieldCells() -> [CellData]
    func restartGame(completion: (Int32, Int32, [CellData]) -> ())
    func getCurrentTetramonios() -> [Int16]?
    func createField() -> [CellData]
}

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
    
    func increaseAndStoreScore(for quantity: Int, completion: @escaping (Int32, Int32) -> ()) {
        let newScore = getCurrentScore() + quantity
        var bestScore = getBestScore()
        
        if bestScore < newScore {
            bestScore = newScore
            game?.bestScore = bestScore
        }
        game?.score = newScore
        
        coreDataManager.save(game)
        completion(newScore, bestScore)
    }
    
    func getCurrentScore() -> Int32 {
        guard let score = game?.score else {
            return 0
        }
        return score
    }
    
    func getBestScore() -> Int32 {
        guard let bestScore = game?.bestScore else{
            return 0
        }
        
        return bestScore
    }
    
    func getFieldCells() -> [CellData] {
        
        var result = [CellData]()
        
        if storedCells.isEmpty {
            result = createField()
        }else{
            for cell in storedCells {
                let cellData = CellData(from: cell)
                result.append(cellData)
            }
        }
        return result
    }
    
    func restartGame(completion: (Int32, Int32, [CellData]) -> ()) {
        
        for cell in storedCells {
            cell.state = 0
            coreDataManager.save(cell)
        }
        
        game?.score = 0
        coreDataManager.save(game)
        var field = [CellData]()
        
        for cell in storedCells {
            let cellData = CellData(from: cell)
            field.append(cellData)
        }
        
        guard let game = game else {
            fatalError("Game instance can not be nil")
        }
        
        completion(game.score, game.bestScore, field)
    }
    
    func getCurrentTetramonios() -> [Int16]? {
        guard let firstTetramonio =  game?.firstTetramonio,
            let lastTetramonio = game?.secondTetramonio, firstTetramonio != lastTetramonio else {
                return nil
        }
        return [firstTetramonio, lastTetramonio]
    }
    
    func createField() -> [CellData] {
        var result = [CellData]()
        var x: Int16 = 0
        var y: Int16 = 0
        for _ in 0..<GameLogicManager.numberOfCells {
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
        
        for cell in storedCells {
            let cellData = CellData(from: cell)
            result.append(cellData)
        }
      
        return result
    }
}
