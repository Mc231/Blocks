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
    
    let x: Int
    let y: Int
    var state: CellState
    
    // MARK: - Mutating methods
    
    mutating func chageState(newState: CellState) {
        self.state = newState
    }
}

extension CellData {
    func isCellPlaced() -> Bool {
        return self.state == .placed
    }
}
