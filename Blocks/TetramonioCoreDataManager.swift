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
    func store(bestScore: Int)
    func store(currentScore: Int)
    
    func getCurrentScore() -> Int32
    func getMaxScore() -> Int32
    func getFieldCells() -> [CellData]
    func resetCells() -> [CellData]
    func getCurrentTetramonios() -> [Int16]?
}

class TetreamonioCoreDataManager {
    
    // MARK: - Properties

    fileprivate let coreDataManager: CoreDataManagerProtocol
    
    lazy var game: Game? = {
        return self.coreDataManager.findFirstOrCreate(Game.self, predicate: nil)
    }()
    
    
    // MARK: - Inizialization
    
    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
        // Ensure that game instance is created
    }
}

// MARK: - TetreamonioCoreDataManagerInput

extension TetreamonioCoreDataManager: TetreamonioCoreDataManagerInput {
    
    func getCurrentTetramonios() -> [Int16]? {
        guard let firstTetramonio =  game?.firstTetramonio,
            let lastTetramonio = game?.secondTetramonio, firstTetramonio != lastTetramonio else {
                return nil
        }
        return [firstTetramonio, lastTetramonio]
    }

    func getFieldCells() -> [CellData] {

        var result = [CellData]()
        // TODo: - fix this
        let xSortDesciptor = NSSortDescriptor(key: "x", ascending: true)
        let storedCells = coreDataManager.fetch(Cell.self, predicate: nil, sortDescriptors: [xSortDesciptor])
        
        if storedCells?.count == 0 {
            result = createField()
        }else{
            // TODO: - Fix force unwrap
            for cell in storedCells! {
                let cellData = CellData(from: cell)
                result.append(cellData)
            }
        }
        return result
    }
    
    func resetCells() -> [CellData] {
        let xSortDesciptor = NSSortDescriptor(key: "x", ascending: true)
        let storedCells = coreDataManager.fetch(Cell.self, predicate: nil, sortDescriptors: [xSortDesciptor])
        for cell in storedCells! {
            cell.state = 0
            coreDataManager.save(cell, completion: nil)
        }
        coreDataManager.save(game, completion: nil)
        
        // TODO: - Fix this fuck
    
        let storedCells2 = coreDataManager.fetch(Cell.self, predicate: nil, sortDescriptors: [xSortDesciptor])
            var result = [CellData]()
        for cell in storedCells2! {
            let cellData = CellData(from: cell)
            result.append(cellData)
        }
        
        return result
    }
    
    private func createField() -> [CellData] {
        var result = [CellData]()
        var x: Int16 = 0
        var y: Int16 = 0
        // TODO: - Add to constant
        for _ in 0..<GameLogicManager.numberOfCells {
            x += 1
            if (x % 10 == 9) {
                x = x+2
            }
            
            y = x % 10
            // TODO: - Fix force unwrap
            let cell = coreDataManager.create(Cell.self)
            cell?.x = x
            cell?.y = y
            cell?.state = 0
            game?.addToCells(cell!)
            coreDataManager.save(cell, completion: nil)
        }
        coreDataManager.save(game, completion: nil)
        
        // TODO: - Fix this fuck
        let xSortDesciptor = NSSortDescriptor(key: "x", ascending: true)
        let storedCells = coreDataManager.fetch(Cell.self, predicate: nil, sortDescriptors: [xSortDesciptor])
        
        for cell in storedCells! {
            let cellData = CellData(from: cell)
            result.append(cellData)
        }
      
        return result
    }

    func getMaxScore() -> Int32 {
        guard let bestScore = game?.bestScore else{
            return 0
        }
        
        return bestScore
    }

    func getCurrentScore() -> Int32 {
        guard let score = game?.score else {
            return 0
        }
        return score
    }

    func store(current tetramonios: [Tetramonio]) {
        // TODO: - Fix this
       game?.firstTetramonio = Int16((tetramonios.first?.id.rawValue)!)
       game?.secondTetramonio = Int16((tetramonios.last?.id.rawValue)!)
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
    
    func store(bestScore: Int) {
        // TODO: - Investigate this
        game?.bestScore = Int32(bestScore)
        coreDataManager.save(game, completion: nil)
    }
    
    func store(currentScore: Int) {
        game?.score = Int32(currentScore)
        coreDataManager.save(game, completion: nil)
    }
}
