//
//  FieldCell+Additions.swift
//  BlocksTests
//
//  Created by Volodymyr Shyrochuk on 23.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import Foundation
@testable import Blocks


extension FieldCell {
	static var mockedField: [FieldCell] {
		var x: Int16 = 0
		var y: Int16 = 0
		var result: [FieldCell] = []
		(0..<Constatns.Field.numberOfCellsOnField)
			.enumerated()
			.forEach { (_) in
				x += 1
				if x % 10 == 9 {
					x += 2
				}
				y = x % 10
				let cell = FieldCell(xPosition: x, yPosition: y, state: .empty)
				result.append(cell)
			}
		return result
	}
}
