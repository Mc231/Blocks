//
//  Constatns.swift
//  Blocks
//
//  Created by Volodya on 6/9/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import UIKit

/// This struct represents basic game constatns
struct Constatns {

    struct Tetramonio {
        static let numberOfCellsInTetramonio = 4
    }

    struct Field {
        static let numberOfCellsOnField = 64
        static let numberOfCellsInRow = 8
    }

    struct Score {
        static let scorePerTetramonio: Int32 = 4
    }
	
	struct Sizes {
		
		static let fieldCellWidthCoof: CGFloat = 0.1173
		
		static func calculateFieldCellSize(screen: UIScreen = .main) -> CGSize {
			let size = Int((screen.bounds.size.width - screen.bounds.width * fieldCellWidthCoof) / CGFloat(Constatns.Field.numberOfCellsInRow))
			return CGSize(width: size, height: size)
		}
	}
}

