//
//  CoreDataStatisticLogger.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 26.03.2023.
//  Copyright © 2023 QuasarClaster. All rights reserved.
//

import Foundation

final class CoreDataStatisticLogger: StatisticLogger {
	
	// MARK: - Properties

	private let coreDataManager: CoreDataManagerProtocol
	
	lazy private var statistic: Statistic? = {
		return self.coreDataManager.findFirstOrCreate(Statistic.self, predicate: nil)
	}()
	
	// MARK: - Inizialization
	
	init(coreDataManager: CoreDataManagerProtocol) {
		self.coreDataManager = coreDataManager
	}
	
	func log(_ event: StatisticEvent) {
		switch event {
		case .gameOver(let score):
			statistic?.allTimeTotalScore = allTimeTotalScore + score
			if score > bestScore {
				statistic?.bestScore = score
			}
			statistic?.playedGames = playedGames + 1
		case .lineWiped:
			statistic?.linesWiped = linesWiped + 1
		case .teramonioPlaced:
			statistic?.placedTetramonios = placedTetramonios + 1
		case .tetramonioDrawned:
			statistic?.tetramonioDrawned = tetramonioDrawned + 1
		case .tetramonioDragged:
			statistic?.tetramonioDragged = tetramonioDragged + 1
		case .restartGame:
			statistic?.gamesRestarted = restartedGames + 1
		}
		
		coreDataManager.save(statistic)
	}
	
	var allTimeTotalScore: Int64 {
		return statistic?.allTimeTotalScore ?? .zero
	}
	
	var bestScore: Int64 {
		return statistic?.bestScore ?? .zero
	}
	
	var linesWiped: Int64 {
		return statistic?.linesWiped ?? .zero
	}
	
	var placedTetramonios: Int64 {
		return statistic?.placedTetramonios ?? .zero
	}
	
	var playedGames: Int64 {
		return statistic?.playedGames ?? .zero
	}
	
	var tetramonioDragged: Int64 {
		return statistic?.tetramonioDragged ?? .zero
	}
	
	var tetramonioDrawned: Int64 {
		return statistic?.tetramonioDrawned ?? .zero
	}
	
	var restartedGames: Int64 {
		return statistic?.gamesRestarted ?? .zero
	}
}
