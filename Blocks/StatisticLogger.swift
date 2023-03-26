//
//  StatisticLogger.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 26.03.2023.
//  Copyright © 2023 QuasarClaster. All rights reserved.
//

import Foundation

/**
 Used to log statistic event
 */
protocol StatisticLogger {
	/**
	 Log statistic event
	 - parameter event: Event to log
	 */
	func log(_ event: StatisticEvent)
	
	// All time Score
	var allTimeTotalScore: Int64 { get }
	// Best score
	var bestScore: Int64 { get }
	// Number of wiped lines
	var linesWiped: Int64 { get }
	// Number of placed teramonios
	var placedTetramonios: Int64 { get }
	// Number of played games
	var playedGames: Int64 { get }
	//Number of restarted games
	var restartedGames: Int64 { get }
}
