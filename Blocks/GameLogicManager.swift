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
    func updateTetramonios(_ tetramonios: [Tetramonio])
    func createField() -> [CellData]
    func restartGame(callback: (_ field: [CellData]) -> ())
}

protocol GameLogicManagerProtocol: class {
    func appendCellToCurrentTetramonio(cellData: CellData)
    func checkForLines(verticalLines: Bool)
    func checkGameOver() -> Bool
}

protocol GameLogicManagerOutput: class {
    func gameLogicManager(_ gameLogicManager: GameLogicManagerInput, matchesTetramonio: Tetramonio?, matchIndex: Int)
    func gameLogicManager(_ gameLogicManager: GameLogicManagerInput, gameOver: Bool)
    func gameLogicManager(_ gameLogicManager: GameLogicManagerInput, didChange score: Int)
    func gameLogicManager(_ gameLogicManager: GameLogicManagerInput, didUpdate field: [CellData])
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
    fileprivate let checkTetramonioManager = CheckTetramonioManager()
    private let scorePerTetramonio = 4
    
    
    func appendCellToCurrentTetramonio(cellData: CellData) {
        currentTetramonio.append(cellData)
        
        if currentTetramonio.count == numberOfCellsInTetramonio {
            
            let tetramonio = checkTetramonioManager.checkTetramonio(with: currentTetramonio)
            
            for cellData in currentTetramonio {
                guard let cellIndex = field.index(where: {$0.x == cellData.x}) else {
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
            
            interractor?.gameLogicManager(self, matchesTetramonio: tetramonio, matchIndex: checkIndex)
            interractor?.gameLogicManager(self, didChange: scorePerTetramonio)
        }else{
            for cellData in currentTetramonio {
                
                guard let cellIndex = field.index(where: {$0.x == cellData.x}) else {
                    fatalError("Index could not be nil")
                }
                
                let cell = field[cellIndex]
                if cell.state  == .empty {
                    field[cellIndex].chageState(newState: .selected)
                }
            }
        }
        
        checkForLines()
        checkForLines(verticalLines: true)
        
        if checkGameOver() {
            interractor?.gameLogicManager(self, gameOver: true)
        }
    }
    
    func checkForLines(verticalLines: Bool = false) {
        
        let allPlacedCells = field.filter( {$0.state == .placed})
        let placedCells = verticalLines ? allPlacedCells.sorted(by: {$0.y < $1.y}) : allPlacedCells
        
        if placedCells.count == 0 {
            return
        }
        
        var cellsData = [[CellData]]()
        let numberOfCellsInRow = 8
        var cellCounter = 1
        var currentRow = [CellData]()
        debugPrint("all cells \(placedCells)")
        for cell in 1..<placedCells.count {
            let firstCellData  = placedCells[cell-1]
            let secondCellData = placedCells[cell]
            let condition = verticalLines ? secondCellData.y == firstCellData.y : secondCellData.x - firstCellData.x == 1
            
            if condition {
                // WARNING: - Add set here
                if !currentRow.contains(where: { $0.x == firstCellData.x }) {
                    currentRow.append(firstCellData)
                }else if !currentRow.contains(where: { $0.x == secondCellData.x }) {
                    currentRow.append(secondCellData)
                }
                cellCounter += 1
                
                if cellCounter == numberOfCellsInRow {
                    currentRow.append(secondCellData)
                    cellsData.append(currentRow)
                    currentRow.removeAll()
                    cellCounter = 1
                }
            }else{
                currentRow.removeAll()
                cellCounter = 1
            }
        }
        
        for row in cellsData {
            for cell in row {
                guard let cellIndex = field.index(where: {$0.x == cell.x}) else {
                    fatalError("Index could not be nil")
                }
         
                field[cellIndex].chageState(newState: .empty)
                
                if !verticalLines {
                
                    var upperCellIndex = cellIndex - numberOfCellsInRow
                    var  previousIndex = 0
                    while upperCellIndex > 0 {
                        if field[upperCellIndex].isCellPlaced() {
                            field[upperCellIndex].chageState(newState: .empty)
                            if previousIndex != 0 {
                                field[previousIndex].chageState(newState: .placed)
                            }
                        }
                        previousIndex = upperCellIndex
                        upperCellIndex -= 8
                    }
                }
            }
            interractor?.gameLogicManager(self, didUpdate: field)
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
                    let possibleTetramonio = checkTetramonioManager.checkTetramonio(with: possibleTetramonioArray)
                    
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
        if !currentTetramonio.contains(where: {$0.x == tetramonioData.x }) && tetramonioData.state == .empty {
            appendCellToCurrentTetramonio(cellData: tetramonioData)
        }
        callback(field)
    }
    
    func updateTetramonios(_ tetramonios: [Tetramonio]) {
        self.tetramonios = tetramonios
        self.checkTetramonioManager.updateTetramonios(tetramonios)
    }
    
    func createField() -> [CellData] {
        
        var result = [CellData]()
        var x = 0
        var y = 0
        for _ in 0..<numberOfCells {
            x += 1
            if (x % 10 == 9) {
                x = x+2
            }
            
            y = x % 10
            
            let cellData = CellData(x: x, y: y, state: .empty)
            result.append(cellData)
        }
        field = result
        return result
    }
    
    func restartGame(callback: ([CellData]) -> ()) {
        field.removeAll()
        callback(createField())
    }
}
