//
//  GameOverManager.swift
//  Blocks
//
//  Created by Volodya on 6/9/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

protocol GameOverChecker {
    associatedtype AsociatedChecker = TetramonioChecker
    func checkGameOver(for tetramonios: [Tetramonio], at field: [CellData], with checker: AsociatedChecker) -> Bool
}

// MARK: - Default Implementation

extension GameOverChecker {
    func checkGameOver(for tetramonios: [Tetramonio], at field: [CellData], with checker: TetramonioMatcher) -> Bool {

        for tetramonio in tetramonios {
            let firstGameOverIndex = tetramonio.gameOverIndexes[0]
            let secondGameOverIndex = tetramonio.gameOverIndexes[1]
            let thirdGameOverIndex = tetramonio.gameOverIndexes[2]

            for index in field.indices {
                let firstIndex  = index + firstGameOverIndex
                let secondIndex = index + secondGameOverIndex
                let thirdIndex  = index + thirdGameOverIndex
                let cellsOnField = Constatns.Field.numberOfCellsOnField

                if firstIndex < cellsOnField  &&
					secondIndex < cellsOnField &&
					thirdIndex < cellsOnField &&
					field[index].state != .placed {

                    let firstCell = field[index]
                    let secondCell = field[firstIndex]
                    let thirdCell = field[secondIndex]
                    let fourthCell = field[thirdIndex]
                    let possibleTetramonioArray = [firstCell, secondCell, thirdCell, fourthCell]

                    let possibleTetramonio = checker.matchTetramonio(from: possibleTetramonioArray, with: tetramonios)

                    if !firstCell.isPlaced
                        && !secondCell.isPlaced
                        && !thirdCell.isPlaced
                        && !fourthCell.isPlaced
                        && possibleTetramonio?.id.rawValue == tetramonio.id.rawValue {
                        return false
                    }
                }
            }
        }
        return true
    }
}
