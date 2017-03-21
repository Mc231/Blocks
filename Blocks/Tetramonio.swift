//
//  Tetromonio.swift
//  Blocks
//
//  Created by Volodya on 2/3/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

/**
    This struct represent basic Tetramonio from Teris
 */

struct Tetramonio {
    // WARNING: - Pay attention
   // let id: TetramonioType
    let id: Int
    let indexes: [Int]
    let gameOverIndexes: [Int]
    
    init(dictionary: NSDictionary) {
        self.id = dictionary.object(forKey: "id") as? Int ?? 0
        self.indexes = dictionary.object(forKey: "tetramonioIndexes") as? [Int] ?? [Int]()
        self.gameOverIndexes = dictionary.object(forKey: "gameOverIndexes") as? [Int] ?? [Int]()
    }
}
