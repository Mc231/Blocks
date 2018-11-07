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
	
    let type: Type
    let indexes: [Int16]
    let gameOverIndexes: [Int]
    let displayTetramonioIndexes: [Int]
}

extension Tetramonio {
	
	/// This enum represent all tetramonio types
	enum `Type`: Int16 {
		case iH = 0
		case iV = 1
		case o  = 2
		case l90 = 3
		case j90 = 4
		case l180 = 5
		case j = 6
		case j270 = 7
		case l270  = 8
		case j180 = 9
		case l = 10
		case s = 11
		case s90  = 12
		case z = 13
		case z90 = 14
		case t180 = 15
		case t = 16
		case t90 = 17
		case t270 = 18
		case none = -1
	}

    private enum TetramonioKeys: String {
        case identifier = "id"
        case tetramonioIndexes
        case gameOverIndexes
        case displayTetramonioIndexes
    }

    init(dictionary: NSDictionary) {
        self.type
			= Type(rawValue: dictionary.object(forKey: TetramonioKeys.identifier.rawValue)
				as? Int16 ?? -1) ?? .none
        self.indexes = dictionary.object(forKey: TetramonioKeys.tetramonioIndexes.rawValue) as? [Int16] ?? [Int16]()
        self.gameOverIndexes = dictionary.object(forKey: TetramonioKeys.gameOverIndexes.rawValue) as? [Int] ?? [Int]()
        self.displayTetramonioIndexes
			= dictionary.object(forKey: TetramonioKeys.displayTetramonioIndexes.rawValue) as? [Int] ?? [Int]()
    }
}
