//
//  CellInfo.swift
//  Blocks
//
//  Created by Volodya on 2/3/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

struct FieldCell: Hashable {
    
    enum State: Int16, Hashable {
        case empty = 0
        case selected = 1
        case placed = 2
        case clear = 3
    }

    // MARK: - Properties

    let xPosition: Int16
    let yPosition: Int16
    private(set) var state: State

    // MARK: - Mutating methods

    mutating func chageState(newState: State) {
        self.state = newState
    }
	
	static func == (lhs: FieldCell, rhs: FieldCell) -> Bool {
		return lhs.xPosition == rhs.xPosition
			&& rhs.yPosition == rhs.yPosition
			&& rhs.state == rhs.state
	}
}

extension FieldCell {

    init(state: State) {
        xPosition = 0
        yPosition = 0
        self.state = state
    }

    init (from cell: Cell) {
        xPosition = cell.xPosition
        yPosition = cell.yPosition
        guard let storedState = State(rawValue: cell.state) else {
            fatalError("Impossible cell state")
        }
        state = storedState
    }

    var isPlaced: Bool {
        return state == .placed
    }
	
	var isEmpty: Bool {
		return state == .empty
	}
	
	var isSelected: Bool {
		return state == .selected
	}
}
