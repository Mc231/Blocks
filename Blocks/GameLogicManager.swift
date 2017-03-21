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
    
    // MARK: - Prioperties

    private var field = [CellData]()
    private var currentTetramonio = [CellData]() {
        didSet {
            if currentTetramonio.count == 4 {
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
    
    private func checkTetramonio() {
        // Add logic gor check figure
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
