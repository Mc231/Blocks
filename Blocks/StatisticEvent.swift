//
//  StatisticEntry.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 26.03.2023.
//  Copyright © 2023 QuasarClaster. All rights reserved.
//

import Foundation

// Represents statistic event that will be logged
enum StatisticEvent {
	case gameOver(score: Int64)
	case lineWiped
	case teramonioPlaced
	case tetramonioDrawned
	case tetramonioDragged
	case restartGame
}