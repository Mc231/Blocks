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
        coreDataManager.save(game, completion: nil)
    }
    
    func store(fieldCells: [CellData]) {
        if let cells = coreDataManager.fetch(Cell.self, predicate: nil, sortDescriptors: nil), !cells.isEmpty {
            for fieldCell in fieldCells {
                guard let cell = coreDataManager.findFirstOrCreate(Cell.self, predicate: NSPredicate(format: "x == %d", fieldCell.x)) else {
                    fatalError("Cell data is corrupted")
                }
                cell.state = fieldCell.state.rawValue
                coreDataManager.save(cell, completion: nil)
            }
        }
        // Ensure theat everything saved
        coreDataManager.save(game, completion: nil)
    }
    
    func increaseAndStoreScore(for quantity: Int, completion: @escaping (Int32, Int32) -> ()) {
        let newScore = getCurrentScore() + quantity
        var bestScore = getBestScore()
        
        if bestScore < newScore {
            bestScore = newScore
            game?.bestScore = bestScore
        }
        game?.score = newScore
        
        coreDataManager.save(game) { (result, error) in
            if error == nil && result == true {
                completion(newScore, bestScore)
            }else{
                debugPrint("Failed to update score")
            }
        }
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
            coreDataManager.save(cell, completion: nil)
        }
        
        game?.score = 0
        coreDataManager.save(game, completion: nil)
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
            coreDataManager.save(cell, completion: nil)
        }
        coreDataManager.save(game, completion: nil)
        
        for cell in storedCells {
            let cellData = CellData(from: cell)
            result.append(cellData)
        }
      
        return result
    }
}
