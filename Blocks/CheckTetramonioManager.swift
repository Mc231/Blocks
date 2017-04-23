//
//  CheckTetramonioManager.swift
//  Blocks
//
//  Created by Volodya on 4/24/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

class CheckTetramonioManager {
    
    // MARK: - Properties
    
    private var tetramonios: [Tetramonio]
    
    // MARK: - Inizialization
    
    init(tetramonios: [Tetramonio] = [Tetramonio]()) {
        self.tetramonios = tetramonios
    }
    
    // MARK: - Public methods
    
    func updateTetramonios(_ tetramonios: [Tetramonio]) {
        self.tetramonios = tetramonios
    }
    
    func checkTetramonio(with cellData: [CellData]) -> Tetramonio? {
        
        let orderedCellData = cellData.sorted(by: {$0.x < $1.x})
        
        let firstCell  = orderedCellData[0].x
        let secondCell = orderedCellData[1].x
        let thirdCell  = orderedCellData[2].x
        let fourthCell = orderedCellData[3].x
        
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
}
