//
//  Tetromonio.swift
//  Blocks
//
//  Created by Volodya on 2/3/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

/**
    This struct represent basic Tetramonios from clasic Teris
 */

struct Tetramonio {
    let identifier: TetramonioType
    let indexes: [Int16]
    let gameOverIndexes: [Int]
    let displayTetramonioIndexes: [Int]
}

extension Tetramonio {

    private enum TetramonioKeys: String {
        case identifier = "id"
        case tetramonioIndexes
        case gameOverIndexes
        case displayTetramonioIndexes
    }

    init(dictionary: NSDictionary) {
        self.identifier
			= TetramonioType(rawValue: dictionary.object(forKey: TetramonioKeys.identifier.rawValue)
				as? Int16 ?? -1) ?? .noneTetramonio
        self.indexes = dictionary.object(forKey: TetramonioKeys.tetramonioIndexes.rawValue) as? [Int16] ?? [Int16]()
        self.gameOverIndexes = dictionary.object(forKey: TetramonioKeys.gameOverIndexes.rawValue) as? [Int] ?? [Int]()
        self.displayTetramonioIndexes
			= dictionary.object(forKey: TetramonioKeys.displayTetramonioIndexes.rawValue) as? [Int] ?? [Int]()
    }
}
