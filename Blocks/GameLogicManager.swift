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
	func updateField(with draggedCells: [CellData])
    func startGame(completion: (_ tetramonios: [Tetramonio], _ field: [CellData], _ currentScore: Int32,
		_ bestScore: Int32) -> Void)
    func restartGame(callback: @escaping (Int32, Int32, [CellData]) -> Void)
}

protocol GameLogicManagerOutput: class {
    func gameOver(currentScore: Int32)
    func gameLogicManager(_ manager: GameLogicManagerInput, didChange score: Int32, and bestScore: Int32)
    func gameLogicManager(_ manager: GameLogicManagerInput, didUpdate field: [CellData])
    func gameLogicManager(_ manager: GameLogicManagerInput, didUpdate tetramonios: [Tetramonio])
}

/// This class represents base game logic
class GameLogicManager {

    // MARK: - Fileprivate Properties

    fileprivate weak var interractor: GameLogicManagerOutput?
    fileprivate var tetramoniosManager: TetramonioProtocol?
    fileprivate var tetramonioCoreDataManager: TetreamonioCoreDataManagerInput?

    fileprivate var field = [CellData]() {
        didSet {
            tetramonioCoreDataManager?.store(fieldCells: field)
        }
    }
    // Tetramonio cells that user tap
    fileprivate var currentTetramonio = [CellData]()
    fileprivate var tetramonios = [Tetramonio]() {
        didSet {
            tetramonioCoreDataManager?.store(current: tetramonios)
        }
    }

    // MARK: - Inizialization
	// swiftlint:disable vertical_parameter_alignment
    init(interractor: GameLogicManagerOutput?,
		 tetramoniosManager: TetramonioProtocol,
		 tetramonioCoreDataManager: TetreamonioCoreDataManagerInput) {
        self.interractor = interractor
        self.tetramoniosManager = tetramoniosManager
        self.tetramonioCoreDataManager = tetramonioCoreDataManager
    }

    // MARK: - Fileprivate methods

    fileprivate func checkCurrentTetramonio() {
		
		let isFullTetramonio = currentTetramonio.count == Constatns.Tetramonio.numberOfCellsInTetramonio
		
        if isFullTetramonio {
            let tetramonio = checkTetramonio(from: currentTetramonio, with: tetramonios)
			updateFieldWithTetramonio(tetramonio)
			
            guard let tetramonioGenerateType = tetramonios.firstIndex(where: {$0.type == tetramonio?.type})
                .flatMap({GenerationType(rawValue: $0)}) else {
                    return
            }

            generateTetramoniosFor(tetramonioGenerateType)
			storeTetramonioScore()
        } else {
          markTetramonioAsPartlySelected()
        }
    }
	
	fileprivate func storeTetramonioScore() {
		tetramonioCoreDataManager?
			.increaseAndStoreScore(Constatns.Score.scorePerTetramonio, completion: { [weak self] (score, bestScore) in
				guard let strongSelf = self else {
					return
				}
				strongSelf.interractor?.gameLogicManager(strongSelf, didChange: score, and: bestScore)
			})
	}
	
	fileprivate func updateFieldWithTetramonio(_ tetramonio: Tetramonio?) {
		var cellsToUpdate: [CellData] = []
		currentTetramonio.forEach({ (cellData) in
			guard let cellIndex = field.firstIndex(where: {$0.xPosition == cellData.xPosition}) else {
				fatalError("Index could not be nil")
			}
			
			if tetramonio != nil {
				field[cellIndex].chageState(newState: .placed)
				cellsToUpdate.append(field[cellIndex])
			} else {
				field[cellIndex].chageState(newState: .empty)
				cellsToUpdate.append(field[cellIndex])
			}
		})
		
		currentTetramonio.removeAll()
		
		if !cellsToUpdate.isEmpty {
			interractor?.gameLogicManager(self, didUpdate: cellsToUpdate)
		}
	}
	
	fileprivate func markTetramonioAsPartlySelected() {
		var cellsToUpdate: [CellData] = []
		
		currentTetramonio.forEach({ (cellData) in
			guard let cellIndex = field.firstIndex(where: {$0.xPosition == cellData.xPosition}) else {
				fatalError("Index could not be nil")
			}
			
			let cell = field[cellIndex]
			if cell.state  == .empty {
				field[cellIndex].chageState(newState: .selected)
				cellsToUpdate.append(field[cellIndex])
			}
		})
		
		if !cellsToUpdate.isEmpty {
			interractor?.gameLogicManager(self, didUpdate: cellsToUpdate)
		}
	}

	// TODO: - Make one callback
    fileprivate func checkCroosLines() {
        checkForCroosLine(type: .horizontal, at: field) { [weak self] (updatedField, updatedCells) in
            guard let strongSelf = self else { return }
            strongSelf.field = updatedField
            strongSelf.interractor?.gameLogicManager(strongSelf, didUpdate: updatedCells)
        }

        checkForCroosLine(type: .vertical, at: field) { [weak self] (updatedField, updatedCells) in
            guard let strongSelf = self else { return }
            strongSelf.field = updatedField
            strongSelf.interractor?.gameLogicManager(strongSelf, didUpdate: updatedCells)
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
	
	// TODO: - Refactore make all equatable
	fileprivate func removeAllSelectedCells() {
		currentTetramonio.removeAll()
		let cells = field.filter({$0.state == .selected}).reduce(into: [CellData]()) { (result, cell) in
			if let index = self.field.firstIndex(where: {$0.xPosition == cell.xPosition}) {
				self.field[index].chageState(newState: .empty)
				result.append(field[index])
			}
		}
		
		interractor?.gameLogicManager(self, didUpdate: cells)
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
        if !currentTetramonio.contains(where: {$0.xPosition == handledData.xPosition }) && handledData.state == .empty {
            currentTetramonio.append(handledData)
            checkCurrentTetramonio()
            checkCroosLines()
            checkGameOver()
        }
    }
	
	func updateField(with draggedCells: [CellData]) {
		// TODO: - Seperate to constant
		if draggedCells.count != 4 {
			return
		}
		removeAllSelectedCells()
		currentTetramonio.append(contentsOf: draggedCells)
		checkCurrentTetramonio()
		checkCroosLines()
		checkGameOver()
	}

    func startGame(completion: ([Tetramonio], [CellData], Int32, Int32) -> Void) {

        var tetramonios = [Tetramonio]()
        if let storedTetramonios = tetramonioCoreDataManager?.tetramoniosIndexes,
            !storedTetramonios.isEmpty,
            let unwraprdTetramonios = tetramoniosManager?.getTetramoniosFrom(storedTetramonios) {
            tetramonios = unwraprdTetramonios
            tetramoniosManager?.currentTetramonios = tetramonios
            self.tetramonios = tetramonios
        } else {
            tetramonios = generateTetramoniosFor(.gameStart)
        }

        guard let field = tetramonioCoreDataManager?.field,
            let score = tetramonioCoreDataManager?.gameScore else {
                fatalError("Score or field cell can not be nil can not be nil")
        }

        let storedTetramonio = field.filter({$0.state == .selected})

        if !storedTetramonio.isEmpty {
            currentTetramonio = storedTetramonio
        }

        self.field = field
        completion(tetramonios, field, score.0, score.1)
    }

    func restartGame(callback: @escaping (Int32, Int32, [CellData]) -> Void) {
        generateTetramoniosFor(.gameStart)
		
        tetramonioCoreDataManager?.restartGame(completion: { [weak self] (gameScore, field) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.field = field
            callback(gameScore.0, gameScore.1, field)
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
