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
    
    let x: Int16
    let y: Int16
    var state: CellState
    
    // MARK: - Mutating methods
    
    mutating func chageState(newState: CellState) {
        self.state = newState
    }
}

extension CellData {
    
    init (from cell: Cell){
        x = cell.x
        y = cell.y
        guard let storedState = CellState(rawValue: cell.state) else {
            fatalError("Impossible cell state")
        }
        state = storedState
    }
    
    func isCellPlaced() -> Bool {
        return self.state == .placed
    }
}
