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
    func startGame(completion: (StartGameConfig) -> Swift.Void)
    func restartGame(callback: @escaping (GameScore, [CellData]) -> Void)
}

protocol GameLogicManagerOutput: class {
    func gameOver(currentScore: Score)
    func gameLogicManager(_ manager: GameLogicManagerInput, didChange score: GameScore)
    func gameLogicManager(_ manager: GameLogicManagerInput, didUpdate field: [CellData])
    func gameLogicManager(_ manager: GameLogicManagerInput, didUpdate tetramonios: [Tetramonio])
}

/// This class represents base game logic
class GameLogicManager {

    // MARK: - Fileprivate Properties

    fileprivate weak var interractor: GameLogicManagerOutput?
    fileprivate var tetramoniosManager: TetramonioProtocol?
    fileprivate var gameDbStore: GameDbStoreInput?

    fileprivate var field = [CellData]() {
        didSet {
            gameDbStore?.storeField(field)
        }
    }
    // Tetramonio cells that user tap on field
    fileprivate var currentTetramonio = [CellData]()
    fileprivate var tetramonios = [Tetramonio]() {
        didSet {
            gameDbStore?.store(current: tetramonios)
        }
    }

    // MARK: - Inizialization
	// swiftlint:disable vertical_parameter_alignment
    init(interractor: GameLogicManagerOutput?,
		 tetramoniosManager: TetramonioProtocol,
		 tetramonioCoreDataManager: GameDbStoreInput) {
        self.interractor = interractor
        self.tetramoniosManager = tetramoniosManager
        self.gameDbStore = tetramonioCoreDataManager
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
		gameDbStore?
			.increaseAndStoreScore(Constatns.Score.scorePerTetramonio,
								   completion: { [weak self] score in
									guard let strongSelf = self else { return }
				
									strongSelf.interractor?.gameLogicManager(strongSelf, didChange: score)
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
			self.gameDbStore?.storeUpdatedCells(updatedRows)
			self.interractor?.gameLogicManager(self, didUpdate: updatedRows)
		}
    }

    fileprivate func checkGameOver() {
        if checkGameOver(for: tetramonios, at: field, with: self) {
            guard let score = gameDbStore?.currentScore else {
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
        if let storedTetramonios = gameDbStore?.tetramoniosIndexes,
            !storedTetramonios.isEmpty,
            let unwraprdTetramonios = tetramoniosManager?.getTetramoniosFrom(storedTetramonios) {
            tetramonios = unwraprdTetramonios
            tetramoniosManager?.currentTetramonios = tetramonios
            self.tetramonios = tetramonios
        } else {
            tetramonios = generateTetramoniosFor(.gameStart)
        }

        guard let field = gameDbStore?.field,
            let score = gameDbStore?.gameScore else {
                fatalError("Score or field cell can not be nil can not be nil")
        }

        let storedTetramonio = field.filter({$0.state == .selected})

        if !storedTetramonio.isEmpty {
            currentTetramonio = storedTetramonio
        }

        self.field = field
		completion((tetramonios, field, score))
    }

    func restartGame(callback: @escaping (GameScore, [CellData]) -> Void) {
        generateTetramoniosFor(.gameStart)
		
        gameDbStore?.restartGame(completion: { [weak self] (gameScore, field) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.field = field
			let gameScore = (gameScore.current, gameScore.best)
            callback(gameScore, field)
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
