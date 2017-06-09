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
    func updateField(with handledCell: CellData)
    func startGame(completion: (_ tetramonios: [Tetramonio], _ field: [CellData], _ currentScore: Int32, _ bestScore: Int32) -> Void)
    func restartGame(callback: @escaping (Int32, Int32, [CellData]) -> ())
}

protocol GameLogicManagerProtocol: class {
    func appendCellToCurrentTetramonio(cellData: CellData)
}

protocol GameLogicManagerOutput: class {
    func gameOver(currentScore: Int32)
    func gameLogicManager(_ manager: GameLogicManagerInput, didChange score: Int32, and bestScore: Int32)
    func gameLogicManager(_ manager: GameLogicManagerInput, didUpdate field: [CellData])
    func gameLogicManager(_ manager: GameLogicManagerInput, didUpdate tetramonios: [Tetramonio])
}

class GameLogicManager: GameLogicManagerProtocol {
    
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
        }
    }
    
    func appendCellToCurrentTetramonio(cellData: CellData) {
        
    }
}

// MARK: - TeramonioChecker

extension GameLogicManager: TetramonioChecker {
    
}

// MARK: - GameOverChecker

extension GameLogicManager: GameOverChecker {
    
}

// MARK: - FieldCrossLineChecker

extension GameLogicManager: FieldCrossLineChecker {
    
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
    
    func updateField(with handledData: CellData) {
        if !currentTetramonio.contains(where: {$0.x == handledData.x }) && handledData.state == .empty {
            // Removing selected cell from currnet tetramonio if it is there
            for fieldCell in field {
                for cellInTeramonio in currentTetramonio {
                    if fieldCell.x == cellInTeramonio.x {
                        if fieldCell.state == .placed && cellInTeramonio.state == .empty {
                            if  let index = currentTetramonio.index(where: {$0.x == fieldCell.x}) {
                                currentTetramonio.remove(at: index)
                            }
                        }
                    }
                }
            }
            
            currentTetramonio.append(handledData)
            
            if currentTetramonio.count == Constatns.Tetramonio.numberOfCellsInTetramonio {
                
                let tetramonio = checkTetramonio(from: currentTetramonio, with: tetramonios)
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
                tetramonioCoreDataManager?.increaseAndStoreScore(for: Constatns.Score.scorePerTetramonio, completion: { [weak self] (currentScore, bestScore) in
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
            
            checkForCroosLine(type: .horizontal, at: field) { [weak self] (updatedField) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.field = updatedField
                strongSelf.interractor?.gameLogicManager(strongSelf, didUpdate: updatedField)
            }
            
            checkForCroosLine(type: .vertical, at: field) { [weak self] (updatedField) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.field = updatedField
                strongSelf.interractor?.gameLogicManager(strongSelf, didUpdate: updatedField)
            }
            
            if checkGameOver(for: tetramonios, at: field, with: self) {
                guard let score = tetramonioCoreDataManager?.getCurrentScore() else {
                    fatalError("Manager can not be nil")
                }
                interractor?.gameOver(currentScore: score)
            }
        }
        interractor?.gameLogicManager(self, didUpdate: field)
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
