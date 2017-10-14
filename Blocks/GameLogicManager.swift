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

protocol GameLogicManagerOutput: class {
    func gameOver(currentScore: Int32)
    func gameLogicManager(_ manager: GameLogicManagerInput, didChange score: Int32, and bestScore: Int32)
    func gameLogicManager(_ manager: GameLogicManagerInput, didUpdate field: [CellData])
    func gameLogicManager(_ manager: GameLogicManagerInput, didUpdate tetramonios: [Tetramonio])
}

class GameLogicManager {
    
    
    // MARK: - Fileprivate Properties
    
    fileprivate weak var interractor: GameLogicManagerOutput?
    fileprivate var tetramoniosManager: TetramonioProtocol?
    fileprivate var tetramonioCoreDataManager: TetreamonioCoreDataManagerInput?
    
    fileprivate var field = [CellData](){
        didSet{
            tetramonioCoreDataManager?.store(fieldCells: field)
        }
    }
    // Tetramonio cells that user tap
    fileprivate var currentTetramonio = [CellData]()
    fileprivate var tetramonios = [Tetramonio](){
        didSet{
            tetramonioCoreDataManager?.store(current: tetramonios)
        }
    }
    
    // MARK: - Inizialization
    
    init(interractor: GameLogicManagerOutput?, tetramoniosManager: TetramonioProtocol, tetramonioCoreDataManager: TetreamonioCoreDataManagerInput) {
        self.interractor = interractor
        self.tetramoniosManager = tetramoniosManager
        self.tetramonioCoreDataManager = tetramonioCoreDataManager
    }
    
    // MARK: - Fileprivate methods
    
    fileprivate func removePlacedCellIfNeeded() {
        // Removing selected cell from currnet tetramonio if it is there
        field.forEach { (fieldCell) in
            currentTetramonio.forEach({ (cellInTeramonio) in
                if fieldCell.x == cellInTeramonio.x {
                    if fieldCell.state == .placed && cellInTeramonio.state == .empty {
                        if  let index = currentTetramonio.index(where: {$0.x == fieldCell.x}) {
                            currentTetramonio.remove(at: index)
                        }
                    }
                }
            })
        }
    }
    
    fileprivate func checkCurrentTetramonio() {
        if currentTetramonio.count == Constatns.Tetramonio.numberOfCellsInTetramonio {
            
            let tetramonio = checkTetramonio(from: currentTetramonio, with: tetramonios)
            
            
            
            currentTetramonio.forEach({ (cellData) in
                guard let cellIndex = field.index(where: {$0.x == cellData.x}) else {
                    fatalError("Index could not be nil")
                }
                
                if tetramonio != nil {
                    field[cellIndex].chageState(newState: .placed)
                }else{
                    field[cellIndex].chageState(newState: .empty)
                }
            })
            
            currentTetramonio.removeAll()
            
            guard let tetramonioGenerateType = tetramonios.index(where: {$0.id == tetramonio?.id})
                .flatMap({GenerationType(rawValue: $0)}) else {
                    return
            }
            
            
            generateTetramoniosFor(tetramonioGenerateType)
            
            tetramonioCoreDataManager?.increaseAndStoreScore(for: Constatns.Score.scorePerTetramonio, completion: { [weak self] (currentScore, bestScore) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.interractor?.gameLogicManager(strongSelf, didChange: currentScore, and: bestScore)
            })
        }else{
            currentTetramonio.forEach({ (cellData) in
                guard let cellIndex = field.index(where: {$0.x == cellData.x}) else {
                    fatalError("Index could not be nil")
                }
                
                let cell = field[cellIndex]
                if cell.state  == .empty {
                    field[cellIndex].chageState(newState: .selected)
                }
            })
        }
    }
    
    fileprivate func checkCroosLines() {
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
    }
    
    fileprivate func checkGameOver() {
        if checkGameOver(for: tetramonios, at: field, with: self) {
            guard let score = tetramonioCoreDataManager?.currentScore else {
                fatalError("Manager can not be nil")
            }
            interractor?.gameOver(currentScore: score)
        }
    }
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
            removePlacedCellIfNeeded()
            currentTetramonio.append(handledData)
            checkCurrentTetramonio()
            checkCroosLines()
            checkGameOver()
        }
        
        interractor?.gameLogicManager(self, didUpdate: field)
    }
    
    func startGame(completion: ([Tetramonio], [CellData], Int32, Int32) -> Void) {
        
        var tetramonios = [Tetramonio]()
        if let storedTetramonios = tetramonioCoreDataManager?.tetramoniosIndexes,
            let unwraprdTetramonios = tetramoniosManager?.getTetramoniosFrom(indexes: storedTetramonios) {
            tetramonios = unwraprdTetramonios
            tetramoniosManager?.currentTetramonios = tetramonios
            self.tetramonios = tetramonios
        }else{
            tetramonios = generateTetramoniosFor(.gameStart)
        }
        
        guard let field = tetramonioCoreDataManager?.field,
            let currentScore = tetramonioCoreDataManager?.currentScore,
            let bestScore = tetramonioCoreDataManager?.bestScore else {
                fatalError("Score or field cell can not be nil can not be nil")
        }
        
        let storedTetramonio = field.filter({$0.state == .selected})
        
        if !storedTetramonio.isEmpty {
            currentTetramonio = storedTetramonio
        }
        
        self.field = field
        completion(tetramonios, field, currentScore, bestScore)
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

// MARK: - TeramonioChecker

extension GameLogicManager: TetramonioChecker {
    
}

// MARK: - GameOverChecker

extension GameLogicManager: GameOverChecker {
    
}

// MARK: - FieldCrossLineChecker

extension GameLogicManager: FieldCrossLineChecker {
    
}
