//
//  FieldCroosLineChecker.swift
//  Blocks
//
//  Created by Volodya on 6/9/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

protocol FieldCrossLineChecker {
    func checkForCroosLine(at field: inout [CellData], completion: ([CellData], [CellData]) -> Void)
}

// MARK: - Default implementation

extension FieldCrossLineChecker {

    // MARK: - Private methods

	private func getRows(from placedCells: [CellData], isVertical: Bool) -> [CellData] {
        var result = [CellData]()
        var cellCounter = 1
        var currentRow = [CellData]()

        for cell in 1..<placedCells.count {
            let firstCellData  = placedCells[cell-1]
            let secondCellData = placedCells[cell]
            let condition = isVertical
				? secondCellData.yPosition == firstCellData.yPosition
				: secondCellData.xPosition - firstCellData.xPosition == 1

            if condition {
                if !currentRow.contains(firstCellData) {
                    currentRow.append(firstCellData)
                } else if !currentRow.contains(secondCellData) {
                    currentRow.append(secondCellData)
                }
                cellCounter += 1

                if cellCounter == Constatns.Field.numberOfCellsInRow {
                    currentRow.append(secondCellData)
                    result.append(contentsOf: currentRow)
                    currentRow.removeAll()
                    cellCounter = 1
                }
            } else {
                currentRow.removeAll()
                cellCounter = 1
            }
        }

        return result
    }

    func checkForCroosLine(at field: inout [CellData], completion: ([CellData], [CellData]) -> Void) {

        let horizontalCells = field.filter({$0.state == .placed})
		let verticalCells = horizontalCells.sorted(by: {$0.yPosition < $1.yPosition})
		
		let horizontalRows: [CellData] = !horizontalCells.isEmpty
			? getRows(from: horizontalCells, isVertical: false) : []
		
		let verticalRows: [CellData] = !verticalCells.isEmpty
			? getRows(from: verticalCells, isVertical: true) : []
		
		if horizontalRows.isEmpty && verticalRows.isEmpty {
			return
		}
		
		let result = Set(horizontalRows + verticalRows).reduce(into: [CellData]()) { (result, cell) in
			guard let cellIndex = field.firstIndex(of: cell) else {
				fatalError("Index could not be nil")
			}
			field[cellIndex].chageState(newState: .empty)
			result.append(field[cellIndex])
		}

		completion(field, result)
    }
}
