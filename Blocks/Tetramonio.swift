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
    let id: TetramonioType
    let indexes: [Int]
    let gameOverIndexes: [Int]
    
    init(dictionary: NSDictionary) {
        self.id = TetramonioType(rawValue: dictionary.object(forKey: "id") as? Int ?? -1) ?? .None
        self.indexes = dictionary.object(forKey: "tetramonioIndexes") as? [Int] ?? [Int]()
        self.gameOverIndexes = dictionary.object(forKey: "gameOverIndexes") as? [Int] ?? [Int]()
    }
}
