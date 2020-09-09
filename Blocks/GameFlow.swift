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

    private weak var interactor: GameFlowOutput?
    private(set) var tetramonioGenerator: TetramonioGeneratable
    private(set) var storage: GameStorage

    private(set) var fieldCells = [FieldCell]() {
        didSet {
			storage.storeField(fieldCells)
        }
    }
    // Tetramonio cells that user tap on field
    private(set) var currentTetramonio = [FieldCell]()
    private(set) var tetramonios = [Tetramonio]() {
        didSet {
			storage.store(current: tetramonios)
        }
    }

    // MARK: - Inizialization
	// swiftlint:disable vertical_parameter_alignment
    init(interactor: GameFlowOutput?,
		 tetramonioGenerator: TetramonioGeneratable,
		 storage: GameStorage) {
        self.interactor = interactor
        self.tetramonioGenerator = tetramonioGenerator
        self.storage = storage
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
		storage
			.increaseAndStoreScore(Constatns.Score.scorePerTetramonio,
								   completion: { [weak self] score in
									guard let strongSelf = self else { return }
				
									strongSelf.interactor?.gameFlow(strongSelf, didChange: score)
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
			interactor?.gameFlow(self, didUpdate: cellsToUpdate)
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
			interactor?.gameFlow(self, didUpdate: cellsToUpdate)
		}
	}

    private func checkCroosLines() {
		checkForCroosLine(at: &fieldCells) { [unowned self] (updatedRows) in
			self.storage.storeUpdatedCells(updatedRows)
			self.interactor?.gameFlow(self, didUpdate: updatedRows)
		}
    }

    private func checkGameOver() {
		let isGameOver = checkGameOver(for: tetramonios, at: fieldCells, with: self)
        if isGameOver {
			let score = storage.currentScore
            interactor?.gameOver(currentScore: score)
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
		storage.storeUpdatedCells(cells)
		interactor?.gameFlow(self, didUpdate: cells)
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
		let tetramonios = tetramonioGenerator.generateTetramonios(of: type)
        interactor?.gameFlow(self, didUpdate: tetramonios)
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
		let storedIds = storage.tetramoniosIndexes
		if !storedIds.isEmpty {
			let generatedTetramonios = tetramonioGenerator.getTetramoniosFromIds(storedIds)
            tetramonios = generatedTetramonios
			tetramonioGenerator.currentTetramonios = tetramonios
            self.tetramonios = tetramonios
        }else{
            tetramonios = generateTetramoniosOf(.gameStart)
        }

		let field = storage.field
		let score = storage.gameScore
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
		storage.restartGame(completion: { [weak self] (gameScore, field) in
            self?.fieldCells = field
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
