//
//  GameFlowManager.swift
//  Blocks
//
//  Created by Volodya on 2/3/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

/// This class represents base game logic
class GameFlow {

    // MARK: - private Properties

    private weak var interractor: GameFlowOutput?
    private var tetramonioGenerator: TetramonioGeneratable?
    private var gameDbStore: GameStorage?

    private var fieldCells = [FieldCell]() {
        didSet {
            gameDbStore?.storeField(fieldCells)
        }
    }
    // Tetramonio cells that user tap on field
    private var currentTetramonio = [FieldCell]()
    private var tetramonios = [Tetramonio]() {
        didSet {
            gameDbStore?.store(current: tetramonios)
        }
    }

    // MARK: - Inizialization
	// swiftlint:disable vertical_parameter_alignment
    init(interractor: GameFlowOutput?,
		 tetramonioGenerator: TetramonioGeneratable,
		 tetramonioCoreDataManager: GameStorage) {
        self.interractor = interractor
        self.tetramonioGenerator = tetramonioGenerator
        self.gameDbStore = tetramonioCoreDataManager
    }

    // MARK: - private methods

    private func checkCurrentTetramonio() {
		
		let isFullTetramonio = currentTetramonio.count == Constatns.Tetramonio.numberOfCellsInTetramonio
		
        if isFullTetramonio {
            let tetramonio = matchTetramonio(from: currentTetramonio, with: tetramonios)
			updateFieldWithTetramonio(tetramonio)
			
			if tetramonio != nil {
				guard let tetramonioGenerateType = tetramonios.firstIndex(of: tetramonio!)
					.flatMap({GenerationType(rawValue: $0)}) else {
						return
				}
				
				generateTetramoniosOf(tetramonioGenerateType)
				storeTetramonioScore()
			}
        } else {
          markTetramonioAsPartlySelected()
        }
    }
	
	private func storeTetramonioScore() {
		gameDbStore?
			.increaseAndStoreScore(Constatns.Score.scorePerTetramonio,
								   completion: { [weak self] score in
									guard let strongSelf = self else { return }
				
									strongSelf.interractor?.gameFlow(strongSelf, didChange: score)
			})
	}
	
	private func updateFieldWithTetramonio(_ tetramonio: Tetramonio?) {
		var cellsToUpdate: [FieldCell] = []
		currentTetramonio.forEach({ (cellData) in
			guard let cellIndex = fieldCells.firstIndex(of: cellData) else {
				fatalError("Index could not be nil")
			}
			let state: FieldCell.State = tetramonio != nil ? .placed : .empty
			fieldCells[cellIndex].chageState(newState: state)
			cellsToUpdate.append(fieldCells[cellIndex])
		})
		
		currentTetramonio.removeAll()
		
		if !cellsToUpdate.isEmpty {
			interractor?.gameFlow(self, didUpdate: cellsToUpdate)
		}
	}
	
	private func markTetramonioAsPartlySelected() {
		var cellsToUpdate: [FieldCell] = []
		
		currentTetramonio.forEach({ (cellData) in
			guard let cellIndex = fieldCells.firstIndex(of: cellData) else {
				fatalError("Index could not be nil")
			}
			
			let cell = fieldCells[cellIndex]
			if cell.isEmpty {
				fieldCells[cellIndex].chageState(newState: .selected)
				cellsToUpdate.append(fieldCells[cellIndex])
			}
		})
		
		if !cellsToUpdate.isEmpty {
			interractor?.gameFlow(self, didUpdate: cellsToUpdate)
		}
	}

    private func checkCroosLines() {
		checkForCroosLine(at: &fieldCells) { [unowned self] (updatedRows) in
			self.gameDbStore?.storeUpdatedCells(updatedRows)
			self.interractor?.gameFlow(self, didUpdate: updatedRows)
		}
    }

    private func checkGameOver() {
        if checkGameOver(for: tetramonios, at: fieldCells, with: self) {
            guard let score = gameDbStore?.currentScore else {
                fatalError("Manager can not be nil")
            }
            interractor?.gameOver(currentScore: score)
        }
    }
	
	private func removeAllSelectedCells() {
		currentTetramonio.removeAll()
		let cells = fieldCells.filter({$0.isSelected}).reduce(into: [FieldCell]()) { [unowned self] (result, cell) in
			if let index = fieldCells.firstIndex(of: cell) {
				self.fieldCells[index].chageState(newState: .empty)
				result.append(fieldCells[index])
			}
		}
		gameDbStore?.storeUpdatedCells(cells)
		interractor?.gameFlow(self, didUpdate: cells)
	}
	
	private func processGameFlow(cellData: [FieldCell]) {
		currentTetramonio.append(contentsOf: cellData)
		checkCurrentTetramonio()
		checkCroosLines()
		checkGameOver()
	}
}

// MARK: - GameFlowInput

extension GameFlow: GameFlowInput {

    @discardableResult
    func generateTetramoniosOf(_ type: GenerationType) -> [Tetramonio] {
        guard let tetramonios = tetramonioGenerator?.generateTetramonios(of: type) else {
            fatalError("Generated tetramonios could not be nil")
        }

        interractor?.gameFlow(self, didUpdate: tetramonios)
        self.tetramonios = tetramonios
        return tetramonios
    }

    func updateField(with updatedCell: FieldCell) {
        if !currentTetramonio.contains(updatedCell) && updatedCell.isEmpty {
			processGameFlow(cellData: [updatedCell])
        }
    }
	
	func updateField(with draggedCells: [FieldCell]) {
		if draggedCells.count != Constatns.Tetramonio.numberOfCellsInTetramonio {
			return
		}
		removeAllSelectedCells()
		processGameFlow(cellData: draggedCells)
	}
	
    func startGame(completion: (StartGameConfig) -> Swift.Void) {

        var tetramonios = [Tetramonio]()
        if let storedIds = gameDbStore?.tetramoniosIndexes,
            !storedIds .isEmpty,
            let unwraprdTetramonios = tetramonioGenerator?.getTetramoniosFromIds(storedIds) {
            tetramonios = unwraprdTetramonios
            tetramonioGenerator?.currentTetramonios = tetramonios
            self.tetramonios = tetramonios
        } else {
            tetramonios = generateTetramoniosOf(.gameStart)
        }

        guard let field = gameDbStore?.field,
            let score = gameDbStore?.gameScore else {
                fatalError("Score or field cell can not be nil can not be nil")
        }

        let storedTetramonio = field.filter({$0.isSelected})

        if !storedTetramonio.isEmpty {
            currentTetramonio = storedTetramonio
        }

        self.fieldCells = field
        let config = StartGameConfig(tetramonios: tetramonios, fieldCells: field, score: score)
		completion(config)
    }

    func restartGame(callback: @escaping (GameScore, [FieldCell]) -> Void) {
        generateTetramoniosOf(.gameStart)
		
        gameDbStore?.restartGame(completion: { [weak self] (gameScore, field) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.fieldCells = field
            let gameScore = GameScore(current: gameScore.current, best: gameScore.best)
            callback(gameScore, field)
        })
    }
}

// MARK: - TetramonioMatcher

extension GameFlow: TetramonioMatcher {

}

// MARK: - GameOverChecker

extension GameFlow: GameOverChecker {

}

// MARK: - FieldCrossLineChecker

extension GameFlow: FieldCrossLineChecker {

}
