//
//  GameLogicManager.swift
//  Blocks
//
//  Created by Volodya on 2/3/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

protocol GameLogicManagerInput {
    func updateField(with tetramonioData: CellData, callback: (_ updatedData: [CellData]) -> Void)
    func setCurrentTetramonios(_ tetramonios: [Tetramonio])
    func createField() -> [CellData]
}

protocol GameLogicManagerProtocol: class {
    func checkTetramonio(with cellData: [CellData]) -> Tetramonio?
    func appendCellToCurrentTetramonio(cellData: CellData)
    func checkGameOver() -> Bool
}

protocol GameLogicManagerOutput: class {
    func gameLogicManager(_ gameLogicManager: GameLogicManagerInput, matchesTetramonio: Tetramonio?, matchIndex: Int)
    func gameLogicManager(_ gameLogicManager: GameLogicManagerInput, gameOver: Bool)
}

class GameLogicManager: GameLogicManagerProtocol {
    
    // MARK: - Constants
    
    fileprivate let numberOfCells = 64
    fileprivate let numberOfCellsInTetramonio = 4
    
    // MARK: - Prioperties
    
    weak var interractor: GameLogicManagerOutput?
    fileprivate var field = [CellData]()
    fileprivate var currentTetramonio = [CellData]()
    fileprivate var tetramonios = [Tetramonio]()
    
    func checkTetramonio(with cellData: [CellData]) -> Tetramonio? {

        let orderedCellData = cellData.sorted(by: {$0.id < $1.id})
        
        let firstCell  = orderedCellData[0].id
        let secondCell = orderedCellData[1].id
        let thirdCell  = orderedCellData[2].id
        let fourthCell = orderedCellData[3].id
        
        for currentTetramonio in tetramonios {
            
            let firstConstant = currentTetramonio.indexes[0]
            let secondConstant = currentTetramonio.indexes[1]
            let thirdConstant = currentTetramonio.indexes[2]
            
            if currentTetramonio.id == .Ih || currentTetramonio.id == .Iv {
                if (secondCell == firstCell + firstConstant)
                    && (thirdCell == secondCell + secondConstant)
                    &&  (fourthCell == thirdCell + thirdConstant) {
                    return currentTetramonio
                }
            }else{
                if (secondCell == firstCell + firstConstant)
                    && (thirdCell == firstCell + secondConstant)
                    &&  (fourthCell == firstCell + thirdConstant) {
                    return currentTetramonio
                }
            }
        }
        
        return nil
    }
    
    func appendCellToCurrentTetramonio(cellData: CellData) {
        currentTetramonio.append(cellData)
        
        if currentTetramonio.count == numberOfCellsInTetramonio {
            
            let tetramonio = checkTetramonio(with: currentTetramonio)
            
            for cellData in currentTetramonio {
                guard let cellIndex = field.index(where: {$0.id == cellData.id}) else {
                    fatalError("Index could not be nil")
                }
                
                if tetramonio != nil {
                    field[cellIndex].chageState(newState: .placed)
                }else{
                    field[cellIndex].chageState(newState: .empty)
                }
            }
            
            currentTetramonio.removeAll()
            
            guard let checkIndex = tetramonios.index(where: {$0.id == tetramonio?.id}) else{
                return
            }
            
            interractor?.gameLogicManager(self, matchesTetramonio: tetramonio, matchIndex: checkIndex )
        }else{
            for cellData in currentTetramonio {
                
                guard let cellIndex = field.index(where: {$0.id == cellData.id}) else {
                    fatalError("Index could not be nil")
                }
                
                let cell = field[cellIndex]
                if cell.state  == .empty {
                    field[cellIndex].chageState(newState: .selected)
                }
            }
        }
        
        if checkGameOver() {
            interractor?.gameLogicManager(self, gameOver: true)
        }
    }
    
    func checkGameOver() -> Bool {
        
        for tetramonio in tetramonios {
            let firstGameOverIndex = tetramonio.gameOverIndexes[0]
            let secondGameOverIndex = tetramonio.gameOverIndexes[1]
            let thirdGameOverIndex = tetramonio.gameOverIndexes[2]
            
            for (index,_) in field.enumerated() {
                let firstIndex  = index + firstGameOverIndex
                let secondIndex = index + secondGameOverIndex
                let thirdIndex  = index + thirdGameOverIndex
                
                if firstIndex < numberOfCells && secondIndex < numberOfCells && thirdIndex < numberOfCells && field[index].state != .placed {
                    let firstCell = field[index]
                    let secondCell = field[firstIndex]
                    let thirdCell = field[secondIndex]
                    let fourthCell = field[thirdIndex]
                    let possibleTetramonioArray = [firstCell, secondCell, thirdCell, fourthCell]
                    let possibleTetramonio = checkTetramonio(with: possibleTetramonioArray)
                    
                    if !firstCell.isCellPlaced()
                        && !secondCell.isCellPlaced()
                        && !thirdCell.isCellPlaced()
                        && !fourthCell.isCellPlaced()
                        && possibleTetramonio?.id.rawValue == tetramonio.id.rawValue {
                        return false
                    }
                }
            }
        }
        
        return true
    }
}

// MARK: - GameLogicInput

extension GameLogicManager: GameLogicManagerInput {

    func updateField(with tetramonioData: CellData, callback: (_ updatedData: [CellData]) -> ()) {
        if !currentTetramonio.contains(where: {$0.id == tetramonioData.id }) && tetramonioData.state == .empty {
            appendCellToCurrentTetramonio(cellData: tetramonioData)
        }
        callback(field)
    }
    
    func setCurrentTetramonios(_ tetramonios: [Tetramonio]) {
        self.tetramonios = tetramonios
    }
    
    func createField() -> [CellData] {
        
        var result = [CellData]()
        var cellId = 0
        for _ in 0..<numberOfCells {
            cellId += 1
            if (cellId % 10 == 9) {
                cellId = cellId+2
            }
            let cellData = CellData(id: cellId, state: .empty)
            result.append(cellData)
        }
        field = result
        return result
    }
}
