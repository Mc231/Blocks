//
//  RestartGameConfig.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 27.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import Foundation

struct RestartGameConfig: Equatable {
	let field: [FieldCell]
	let score: GameScore
}
