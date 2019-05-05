//
//  Typealiases.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 4/30/19.
//  Copyright © 2019 QuasarClaster. All rights reserved.
//

import Foundation

typealias Score = Int32
typealias TetramonioIndex = Int16
typealias GameScore = (current: Score, best: Score)
typealias StartGameConfig = (tetramonios: [Tetramonio], field: [CellData], score: GameScore)
typealias CrossLineCheckerCompletion = ([CellData]) -> Swift.Void
