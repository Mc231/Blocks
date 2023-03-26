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
	private let statisticLogger: StatisticLogger

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
		 storage: GameStorage,
		 statisticLogger: StatisticLogger
	) {
        self.interactor = interactor
        self.tetramonioGenerator = tetramonioGenerator
        self.storage = storage
		self.statisticLogger = statisticLogger
    }
}

// MARK: - Private methods

private extension GameFlow {
	
	func processGameFlow(cellData: [FieldCell]) {
		currentTetramonio.append(contentsOf: cellData)
		checkCurrentTetramonio()
		checkCroosLines()
		checkGameOver()
	}
	
	func checkCurrentTetramonio() {
		let isFullTetramonio = currentTetramonio.count == Constatns.Tetramonio.numberOfCellsInTetramonio
		if isFullTetramonio {
			let tetramonio = matchTetramonio(from: currentTetramonio, with: tetramonios)
			updateFieldWithTetramonio(tetramonio)
			if tetramonio != nil,
               let tetramonioGenerateType = tetramonios.firstIndex(of: tetramonio!)
                .flatMap({GenerationType(rawValue: $0)}) {
                generateTetramoniosOf(tetramonioGenerateType)
				statisticLogger.log(.teramonioPlaced)
                storeScore()
			}
		}else{
			markTetramonioAsPartlySelected()
		}
	}

	func updateFieldWithTetramonio(_ tetramonio: Tetramonio?) {
		var cellsToUpdate: [FieldCell] = []
		currentTetramonio.forEach({ (cellData) in
			let cellIndex = fieldCells.firstIndex(of: cellData)!
			let state: FieldCell.State = tetramonio != nil ? .placed : .empty
			fieldCells[cellIndex].chageState(newState: state)
			cellsToUpdate.append(fieldCells[cellIndex])
		})
		
		currentTetramonio.removeAll()
		
		if !cellsToUpdate.isEmpty {
			interactor?.gameFlow(self, didUpdate: cellsToUpdate)
		}
	}

	func markTetramonioAsPartlySelected() {
		var cellsToUpdate: [FieldCell] = []
		
		currentTetramonio.forEach({ (cellData) in
			let cellIndex = fieldCells.firstIndex(of: cellData)!
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

	func checkCroosLines() {
        let updatedCells = checkForCroosLine(at: &fieldCells)
		let cells = updatedCells.cells
		if !cells.isEmpty {
			storage.storeUpdatedCells(cells)
			statisticLogger.log(.wipedRows(count: updatedCells.wipedRows))
            interactor?.gameFlow(self, didUpdate: cells)
        }
	}
	
	func storeScore() {
		let score = storage.increaseAndStoreScore(by: Constatns.Score.scorePerTetramonio)
		interactor?.gameFlow(self, didChange: score)
	}

	func checkGameOver() {
		let isGameOver = checkGameOver(for: tetramonios, at: fieldCells, with: self)
		if isGameOver {
			let score = storage.currentScore
			statisticLogger.log(.gameOver(score: Int64(score)))
			interactor?.gameOver(currentScore: score)
		}
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
		processGameFlow(cellData: draggedCells)
	}
	
    func startGame() -> StartGameConfig {
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
		// When we draw tetramonio on field then make current tetramonio with it
        let selctedCellsOnField = field.filter({$0.isSelected})
        if !selctedCellsOnField.isEmpty {
            currentTetramonio = selctedCellsOnField
        }
        self.fieldCells = field
        let config = StartGameConfig(tetramonios: tetramonios, fieldCells: field, score: score)
		return config
    }

    func restartGame() -> RestartGameConfig {
        generateTetramoniosOf(.gameStart)
		let restartConfig = storage.restartGame()
		self.fieldCells = restartConfig.field
		statisticLogger.log(.restartGame)
		return restartConfig
    }
    
    func invalidateSelectedCells() {
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
}

// MARK: - TetramonioMatcher

extension GameFlow: TetramonioMatcher { }

// MARK: - GameOverChecker

extension GameFlow: GameOverChecker { }

// MARK: - FieldCrossLineChecker

extension GameFlow: FieldCrossLineChecker { }
