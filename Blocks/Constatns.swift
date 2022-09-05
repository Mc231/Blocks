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
		
		static func calculateFieldCellSize(frame: CGRect) -> CGSize {
			let size = (frame.size.width - 16)  / CGFloat(Constatns.Field.numberOfCellsInRow)
			return CGSize(width: size, height: size)
		}
	}
}

