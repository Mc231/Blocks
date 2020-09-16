//
//  Tetramonio+Additions.swift
//  BlocksTests
//
//  Created by Volodymyr Shyrochuk on 16.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import Foundation
@testable import Blocks

extension Tetramonio {
	/// Create tetamonio with empty indexes
	static func emptyOfType(type: Tetramonio.`Type`) -> Tetramonio {
		return .init(id: type, tetramonioIndexes: [], gameOverIndexes: [], displayTetramonioIndexes: [])
	}
}
