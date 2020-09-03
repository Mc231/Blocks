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

    private var field = [CellData]() {
        didSet {
            gameDbStore?.storeField(field)
        }
    }
    // Tetramonio cells that user tap on field
    private var currentTetramonio = [CellData]()
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
			interractor?.gameFlow(self, didUpdate: cellsToUpdate)
		}
	}
	
	private func markTetramonioAsPartlySelected() {
		var cellsToUpdate: [CellData] = []
		
		currentTetramonio.forEach({ (cellData) in
			guard let cellIndex = field.firstIndex(of: cellData) else {
				fatalError("Index could not be nil")
			}
			
			let cell = field[cellIndex]
			if cell.isEmpty {
				field[cellIndex].chageState(newState: .selected)
				cellsToUpdate.append(field[cellIndex])
			}
		})
		
		if !cellsToUpdate.isEmpty {
			interractor?.gameFlow(self, didUpdate: cellsToUpdate)
		}
	}

    private func checkCroosLines() {
		checkForCroosLine(at: &field) { [unowned self] (updatedRows) in
			self.gameDbStore?.storeUpdatedCells(updatedRows)
			self.interractor?.gameFlow(self, didUpdate: updatedRows)
		}
    }

    private func checkGameOver() {
        if checkGameOver(for: tetramonios, at: field, with: self) {
            guard let score = gameDbStore?.currentScore else {
                fatalError("Manager can not be nil")
            }
            interractor?.gameOver(currentScore: score)
        }
    }
	
	private func removeAllSelectedCells() {
		currentTetramonio.removeAll()
		let cells = field.filter({$0.isSelected}).reduce(into: [CellData]()) { [unowned self] (result, cell) in
			if let index = field.firstIndex(of: cell) {
				self.field[index].chageState(newState: .empty)
				result.append(field[index])
			}
		}
		gameDbStore?.storeUpdatedCells(cells)
		interractor?.gameFlow(self, didUpdate: cells)
	}
	
	private func processGameFlow(cellData: [CellData]) {
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

    func updateField(with updatedCell: CellData) {
        if !currentTetramonio.contains(updatedCell) && updatedCell.isEmpty {
			processGameFlow(cellData: [updatedCell])
        }
    }
	
	func updateField(with draggedCells: [CellData]) {
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

        self.field = field
		completion((tetramonios, field, score))
    }

    func restartGame(callback: @escaping (GameScore, [CellData]) -> Void) {
        generateTetramoniosOf(.gameStart)
		
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

// MARK: - TetramonioMatcher

extension GameFlow: TetramonioMatcher {

}

// MARK: - GameOverChecker

extension GameFlow: GameOverChecker {

}

// MARK: - FieldCrossLineChecker

extension GameFlow: FieldCrossLineChecker {

}
