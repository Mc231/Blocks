//
//  CellInfo.swift
//  Blocks
//
//  Created by Volodya on 2/3/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

struct CellData {
    
    let id: Int
    var state: CellState
    
    mutating func chageState(newState: CellState) {
        self.state = newState
    }
}
