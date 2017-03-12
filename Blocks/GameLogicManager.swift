//
//  GameLogicManager.swift
//  Blocks
//
//  Created by Volodya on 2/3/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

protocol GameLogicInput {
    func handleCurrentTetramonioData(tetramonioData: CellData, callback: (_ cellData: [CellData]) -> Void)
    func setCurrentTetramonios(_ tetramonios: [Tetramonio])
//    func checkLine()
//    func checkTetramonio()
//    func checkHorizontalLines()
//    func checkVerticalLines()
//    func checkGameOver()
}

final class GameLogicManager: GameLogicInput {
    
    private var allCellsOnField = [CellData]()
    private var currentTetramonio = [CellData]()
    private var tetramonios = [Tetramonio]()
    
    func handleCurrentTetramonioData(tetramonioData: CellData, callback: (_ cellData: [CellData]) -> ()) {
        if currentTetramonio.count != 4 {
            currentTetramonio.append(tetramonioData)
        }else{
           callback([tetramonioData])
        }
    }
    
    func setCurrentTetramonios(_ tetramonios: [Tetramonio]) {
        self.tetramonios = tetramonios
    }
}
