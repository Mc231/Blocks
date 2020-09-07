//
//  StartGameConfig.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 07.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import Foundation

struct StartGameConfig: Equatable {
    let tetramonios: [Tetramonio]
    let fieldCells: [FieldCell]
    let score: GameScore
}
