//
//  CellInfo.swift
//  Blocks
//
//  Created by Volodya on 2/3/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import UIKit

struct FieldCell: Hashable {
    
    enum State: Int16, Hashable {
        case empty = 0
        case selected = 1
        case placed = 2
        case clear = 3
        
        var backgroundColor: UIColor? {
            switch self {
            case .empty:
                return .emptyCellBackground
            case .selected:
                return .selectedCellBackground
            case .placed:
                return .placedCellBackground
            case .clear:
                return .clear
            }
        }
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

    init(from cell: Cell) {
        xPosition = cell.xPosition
        yPosition = cell.yPosition
        let storedState = State(rawValue: cell.state)
        // TODO: - Check force unwrap
        state = storedState!
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
