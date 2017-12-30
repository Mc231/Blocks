//
//  FieldCroosLineChecker.swift
//  Blocks
//
//  Created by Volodya on 6/9/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

enum CroosLineType {
    case horizontal
    case vertical
}

protocol FieldCrossLineChecker {
    func checkForCroosLine(type: CroosLineType, at field: [CellData], completion: ([CellData]) -> Void)
}

// MARK: - Default implementation

extension FieldCrossLineChecker {
    
    // MARK: - Private methods
    
    private func getRows(of type: CroosLineType, from placedCells: [CellData]) -> [[CellData]] {
        var cellsData = [[CellData]]()
        var cellCounter = 1
        var currentRow = [CellData]()
        
        for cell in 1..<placedCells.count {
            let firstCellData  = placedCells[cell-1]
            let secondCellData = placedCells[cell]
            let condition = type == .vertical ? secondCellData.yPosition == firstCellData.yPosition : secondCellData.xPosition - firstCellData.xPosition == 1
            
            if condition {
                // WARNING: - Add set here
                if !currentRow.contains(where: { $0.xPosition == firstCellData.xPosition }) {
                    currentRow.append(firstCellData)
                }else if !currentRow.contains(where: { $0.xPosition == secondCellData.xPosition }) {
                    currentRow.append(secondCellData)
                }
                cellCounter += 1
                
                if cellCounter == Constatns.Field.numberOfCellsInRow {
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
        
        return cellsData
    }
    
    // TODO: - Refactore this
    func checkForCroosLine(type: CroosLineType, at field: [CellData], completion: ([CellData]) -> Void) {
        var field = field
        
        let allPlacedCells = field.filter( {$0.state == .placed})
        let placedCells = type == .vertical ? allPlacedCells.sorted(by: {$0.yPosition < $1.yPosition}) : allPlacedCells
        
        if placedCells.isEmpty {
            return
        }
        
        let cellsData = getRows(of: type, from: placedCells)
        
        for row in cellsData {
            for cell in row {
                guard let cellIndex = field.index(where: {$0.xPosition == cell.xPosition}) else {
                    fatalError("Index could not be nil")
                }
                
                field[cellIndex].chageState(newState: .empty)
                
                if type == .horizontal {
                    
                    var upperCellIndex = cellIndex - Constatns.Field.numberOfCellsInRow
                    var  previousIndex = 0
                    while upperCellIndex > 0 {
                        if field[upperCellIndex].isCellPlaced {
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
        completion(field)
    }
}
