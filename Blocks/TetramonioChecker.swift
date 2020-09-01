//
//  CheckTetramonioManager.swift
//  Blocks
//
//  Created by Volodya on 4/24/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

protocol TetramonioChecker {
    func checkTetramonio(from cellData: [CellData], with tetramonios: [Tetramonio]) -> Tetramonio?
}

// MARK: - Default Implementation

extension TetramonioChecker {
    func checkTetramonio(from cellData: [CellData], with tetramonios: [Tetramonio]) -> Tetramonio? {
        let orderedCellData = cellData.sorted(by: {$0.xPosition < $1.xPosition})

        let firstCell  = orderedCellData[0].xPosition
        let secondCell = orderedCellData[1].xPosition
        let thirdCell  = orderedCellData[2].xPosition
        let fourthCell = orderedCellData[3].xPosition

        for currentTetramonio in tetramonios {

            let firstConstant = currentTetramonio.tetramonioIndexes[0]
            let secondConstant = currentTetramonio.tetramonioIndexes[1]
            let thirdConstant = currentTetramonio.tetramonioIndexes[2]

            if currentTetramonio.id == .iH || currentTetramonio.id == .iV {
                if (secondCell == firstCell + firstConstant)
                    && (thirdCell == secondCell + secondConstant)
                    &&  (fourthCell == thirdCell + thirdConstant) {
                    return currentTetramonio
                }
            } else {
                if (secondCell == firstCell + firstConstant)
                    && (thirdCell == firstCell + secondConstant)
                    &&  (fourthCell == firstCell + thirdConstant) {
                    return currentTetramonio
                }
            }
        }

        return nil
    }
}
