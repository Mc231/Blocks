//
//  GameLogicManager.swift
//  Blocks
//
//  Created by Volodya on 2/3/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

protocol GameLogicInput {
    func updateField(with tetramonioData: CellData, callback: (_ updatedData: [CellData]) -> Void)
    func setCurrentTetramonios(_ tetramonios: [Tetramonio])
    func createField() -> [CellData]
}

protocol GameLogicOutput {
    func checkGameOver()
}

final class GameLogicManager: GameLogicInput {
    
    // MARK: - Constants
    
    private let numberOfCells = 64
    private let numberOfCellsInTetramonio = 4
    
    // MARK: - Prioperties

    private var field = [CellData]()
    private var currentTetramonio = [CellData]() {
        didSet {
            if currentTetramonio.count == numberOfCellsInTetramonio {
               checkTetramonio()
            }else{
                appendCellToCurrentTetramonio()
            }
        }
    }
    private var tetramonios = [Tetramonio]()
    
    func updateField(with tetramonioData: CellData, callback: (_ updatedData: [CellData]) -> ()) {
        if !currentTetramonio.contains(where: {$0.id == tetramonioData.id }) && tetramonioData.state == .empty {
            currentTetramonio.append(tetramonioData)
            callback(field)
        }
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
    
    // MARK: - Private methods
    
    private func check(ordered tetramonio: [Tetramonio]) -> Tetramonio? {
        let firstCell = tetramonio[0].id
        let secondCell = tetramonio[1].id
        let thirdCell = tetramonio[2].id
        let fourthCell = tetramonio[4].id
        
        for currentTetramonio in tetramonios {
            let firstConstant = currentTetramonio.indexes[0]
            let secondConstant = currentTetramonio.indexes[1]
            let thirdConstant = currentTetramonio.indexes[2]
            
            if (secondCell == firstCell + firstConstant) && (thirdCell == firstCell + secondConstant) &&  (fourthCell == firstCell + thirdConstant) {
                return currentTetramonio
            }
        }
        return nil
    }
    
    private func checkTetramonio() {
        // Add logic gor check figure
       
        let orderedTetramonio = currentTetramonio.sorted(by: {$0.id < $1.id})
        debugPrint(orderedTetramonio)
        
        for cellData in currentTetramonio {
            guard let cellIndex = field.index(where: {$0.id == cellData.id}) else {
                fatalError("Index could not be nil")
            }
            field[cellIndex].chageState(newState: .placed)
        }
        currentTetramonio.removeAll()
    }
    
    private func appendCellToCurrentTetramonio() {
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
}
