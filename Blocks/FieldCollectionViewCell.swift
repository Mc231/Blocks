//
//  FieldCollectionViewCell.swift
//  Blocks
//
//  Created by Volodya on 2/19/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import UIKit

class FieldCollectionViewCell: UICollectionViewCell {

    var cellData: FieldCell!
    
    func applay(cellData: FieldCell) {
        self.cellData = cellData
        backgroundColor = cellData.state.backgroundColor
    }
	
	override func isEqual(_ object: Any?) -> Bool {
		if let cell = object as? FieldCollectionViewCell {
			return cell.cellData == cellData
		}
		return false
	}
}
