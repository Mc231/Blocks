//
//  GameLogicManager.swift
//  Blocks
//
//  Created by Volodya on 2/3/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

protocol GameLogicManagerInput {
    func generateTetramoniosFor(_ type: GenerationType) -> [Tetramonio]
    func updateField(with tetramonioData: CellData, callback: (_ updatedData: [CellData]) -> Void)
    func startGame(completion: (_ tetramonios: [Tetramonio], _ field: [CellData], _ currentScore: Int32, _ bestScore: Int32) -> Void)
    func restartGame(callback: @escaping (Int32, Int32, [CellData]) -> ())
}

protocol GameLogicManagerProtocol: class {
    func appendCellToCurrentTetramonio(cellData: CellData)
    func checkForLines(verticalLines: Bool)
    func checkGameOver() -> Bool
}

protocol GameLogicManagerOutput: class {
    func gameOver(currentScore: Int32)
    func gameLogicManager(_ manager: GameLogicManagerInput, didChange score: Int32, and bestScore: Int32)
    func gameLogicManager(_ manager: GameLogicManagerInput, didUpdate field: [CellData])
    func gameLogicManager(_ manager: GameLogicManagerInput, didUpdate tetramonios: [Tetramonio])
}

class GameLogicManager: GameLogicManagerProtocol {
    
    // MARK: - Constants
    
    static let numberOfCells = 64
    fileprivate let numberOfCellsInTetramonio = 4
    
    // MARK: - Prioperties
    
    weak var interractor: GameLogicManagerOutput?
    var tetramoniosManager: TetramonioManager?
    var tetramonioCoreDataManager: TetreamonioCoreDataManagerInput?
    fileprivate var field = [CellData](){
        didSet{
            tetramonioCoreDataManager?.store(fieldCells: field)
        }
    }
    fileprivate var currentTetramonio = [CellData]()
    fileprivate var tetramonios = [Tetramonio](){
        didSet{
            tetramonioCoreDataManager?.store(current: tetramonios)
            self.checkTetramonioManager.updateTetramonios(tetramonios)
        }
    }
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
            
            guard let checkIndex = tetramonios.index(where: {$0.id == tetramonio?.id}),
                  let generationType = GenerationType(rawValue: checkIndex) else {
                return
            }
            
            generateTetramoniosFor(generationType)
            tetramonioCoreDataManager?.increaseAndStoreScore(for: scorePerTetramonio, completion: { [weak self] (currentScore, bestScore) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.interractor?.gameLogicManager(strongSelf, didChange: currentScore, and: bestScore)
            })
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
            guard let score = tetramonioCoreDataManager?.getCurrentScore() else {
                fatalError("Manager can not be nil")
            }
            interractor?.gameOver(currentScore: score)
        }
    }
    
    func checkForLines(verticalLines: Bool = false) {
        
        let allPlacedCells = field.filter( {$0.state == .placed})
        let placedCells = verticalLines ? allPlacedCells.sorted(by: {$0.y < $1.y}) : allPlacedCells
        
        if placedCells.isEmpty {
            return
        }
        
        var cellsData = [[CellData]]()
        let numberOfCellsInRow = 8
        var cellCounter = 1
        var currentRow = [CellData]()
        
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
        }
        interractor?.gameLogicManager(self, didUpdate: field)
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
                
                if firstIndex < GameLogicManager.numberOfCells && secondIndex < GameLogicManager.numberOfCells && thirdIndex < GameLogicManager.numberOfCells && field[index].state != .placed {
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
    
    @discardableResult
    func generateTetramoniosFor(_ type: GenerationType) -> [Tetramonio] {
        guard let tetramonios = tetramoniosManager?.generateTetramonios(type) else {
            fatalError("Generated tetramonios could not be nil")
        }
     
        interractor?.gameLogicManager(self, didUpdate: tetramonios)
        self.tetramonios = tetramonios
        return tetramonios
    }

    func updateField(with tetramonioData: CellData, callback: (_ updatedData: [CellData]) -> ()) {
        if !currentTetramonio.contains(where: {$0.x == tetramonioData.x }) && tetramonioData.state == .empty {
            appendCellToCurrentTetramonio(cellData: tetramonioData)
        }
        callback(field)
    }
    
    func startGame(completion: ([Tetramonio], [CellData], Int32, Int32) -> Void) {
        
        var tetramonios = [Tetramonio]()
        if let storedTetramonios = tetramonioCoreDataManager?.getCurrentTetramonios(),
            let unwraprdTetramonios = tetramoniosManager?.getTetramoniosFrom(indexes: storedTetramonios) {
            tetramonios = unwraprdTetramonios
            tetramoniosManager?.currentTetramonios = tetramonios
            self.tetramonios = tetramonios
        }else{
            tetramonios = generateTetramoniosFor(.gameStart)
        }
        
        guard let cellData = tetramonioCoreDataManager?.getFieldCells(),
            let currentScore = tetramonioCoreDataManager?.getCurrentScore(),
            let bestScore = tetramonioCoreDataManager?.getBestScore() else {
                fatalError("Score or field cell can not be nil can not be nil")
        }
        
        let storedTetramonio = cellData.filter({$0.state == .selected})
        
        if !storedTetramonio.isEmpty {
            currentTetramonio = storedTetramonio
        }
        
        field = cellData
        completion(tetramonios, cellData, currentScore, bestScore)
    }
    
    func restartGame(callback: @escaping (Int32, Int32, [CellData]) -> ()) {
        generateTetramoniosFor(.gameStart)
        tetramonioCoreDataManager?.restartGame(completion: { [weak self] (score, bestScore, field) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.field = field
            callback(score, bestScore, field)
        })
    }
}
