//
//  CheckTetramonioManager.swift
//  Blocks
//
//  Created by Volodya on 4/24/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

protocol TetramonioMatcher {
    func matchTetramonio(from cellData: [FieldCell], with tetramonios: [Tetramonio]) -> Tetramonio?
}

// MARK: - Default Implementation

extension TetramonioMatcher {
    func matchTetramonio(from cellData: [FieldCell], with tetramonios: [Tetramonio]) -> Tetramonio? {
        let orderedCellData = cellData.sorted(by: {$0.xPosition < $1.xPosition})

        let firstCell  = orderedCellData[0].xPosition
        let secondCell = orderedCellData[1].xPosition
        let thirdCell  = orderedCellData[2].xPosition
        let fourthCell = orderedCellData[3].xPosition

        for tetramonio in tetramonios {
            let firstConstant = tetramonio.tetramonioIndexes[0]
            let secondConstant = tetramonio.tetramonioIndexes[1]
            let thirdConstant = tetramonio.tetramonioIndexes[2]

            if tetramonio.id == .iH || tetramonio.id == .iV {
                if (secondCell == firstCell + firstConstant)
                    && (thirdCell == secondCell + secondConstant)
                    &&  (fourthCell == thirdCell + thirdConstant) {
                    return tetramonio
                }
            } else {
                if (secondCell == firstCell + firstConstant)
                    && (thirdCell == firstCell + secondConstant)
                    &&  (fourthCell == firstCell + thirdConstant) {
                    return tetramonio
                }
            }
        }
        return nil
    }
}
