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
struct Tetramonio: Codable {
	
    let id: Type
    let tetramonioIndexes: [Int16]
    let gameOverIndexes: [Int]
    let displayTetramonioIndexes: [Int]
}

// MARK: - Equtable

extension Tetramonio: Equatable {
	
	static func == (lhs: Tetramonio, rhs: Tetramonio) -> Bool {
		return lhs.id == rhs.id
	}
}

extension Tetramonio {
	
	/// Represents  all tetramonio types
	enum `Type`: Int16, Codable {
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
}
