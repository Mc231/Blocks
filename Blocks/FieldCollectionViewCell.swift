//
//  FieldCollectionViewCell.swift
//  Blocks
//
//  Created by Volodya on 2/19/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import UIKit

class FieldCollectionViewCell: UICollectionViewCell {

    var cellData: FieldCell! {
        didSet {
            switch cellData.state {
            case .empty:
                backgroundColor = UIColor.CellBackgrounds.empty
            case .placed:
                backgroundColor = UIColor.CellBackgrounds.placed
            case .selected:
                backgroundColor = UIColor.CellBackgrounds.selected
			case .clear:
				backgroundColor = UIColor.clear
            }
        }
    }
	
	override func isEqual(_ object: Any?) -> Bool {
		if let cell = object as? FieldCollectionViewCell {
			return cell.cellData == cellData
		}
		return false
	}
}
