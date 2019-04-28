//
//  GameLogicManager.swift
//  Blocks
//
//  Created by Volodya on 2/3/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

typealias StartGameConfig = ([Tetramonio], [CellData], GameScore)

protocol GameLogicManagerInput {
    func generateTetramoniosFor(_ type: GenerationType) -> [Tetramonio]
    func updateField(with handledCell: CellData)
	func updateField(with draggedCells: [CellData])
    func startGame(completion: (StartGameConfig) -> Swift.Void)
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
			
			if tetramonio != nil {
				guard let tetramonioGenerateType = tetramonios.firstIndex(of: tetramonio!)
					.flatMap({GenerationType(rawValue: $0)}) else {
						return
				}
				
				generateTetramoniosFor(tetramonioGenerateType)
				storeTetramonioScore()
			}
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
			guard let cellIndex = field.firstIndex(of: cellData) else {
				fatalError("Index could not be nil")
			}
			let state: CellData.State = tetramonio != nil ? .placed : .empty
			field[cellIndex].chageState(newState: state)
			cellsToUpdate.append(field[cellIndex])
		})
		
		currentTetramonio.removeAll()
		
		if !cellsToUpdate.isEmpty {
			interractor?.gameLogicManager(self, didUpdate: cellsToUpdate)
		}
	}
	
	fileprivate func markTetramonioAsPartlySelected() {
		var cellsToUpdate: [CellData] = []
		
		currentTetramonio.forEach({ (cellData) in
			guard let cellIndex = field.firstIndex(of: cellData) else {
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

    fileprivate func checkCroosLines() {
		checkForCroosLine(at: field) { [unowned self] (field, updatedRows) in
			self.field = field
			self.interractor?.gameLogicManager(self, didUpdate: updatedRows)
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
	
	fileprivate func removeAllSelectedCells() {
		currentTetramonio.removeAll()
		let cells = field.filter({$0.state == .selected}).reduce(into: [CellData]()) { [unowned self] (result, cell) in
			if let index = field.firstIndex(of: cell) {
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
		if draggedCells.count != Constatns.Tetramonio.numberOfCellsInTetramonio {
			return
		}
		removeAllSelectedCells()
		currentTetramonio.append(contentsOf: draggedCells)
		checkCurrentTetramonio()
		checkCroosLines()
		checkGameOver()
	}
	

    func startGame(completion: (StartGameConfig) -> Swift.Void) {

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
		completion((tetramonios, field, score))
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
