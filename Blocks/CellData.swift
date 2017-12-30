//
//  CellInfo.swift
//  Blocks
//
//  Created by Volodya on 2/3/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

struct CellData {
    
    // MARK: - Properties
    
    let xPosition: Int16
    let yPosition: Int16
    var state: CellState
    
    // MARK: - Mutating methods
    
    mutating func chageState(newState: CellState) {
        self.state = newState
    }
}

extension CellData {
    
    init(state: CellState) {
        xPosition = 0
        yPosition = 0
        self.state = state
    }
    
    init (from cell: Cell){
        xPosition = cell.xPosition
        yPosition = cell.yPosition
        guard let storedState = CellState(rawValue: cell.state) else {
            fatalError("Impossible cell state")
        }
        state = storedState
    }
    
    var isCellPlaced: Bool {
        return self.state == .placed
    }
}
