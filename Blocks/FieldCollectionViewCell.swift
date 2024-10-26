//
//  FieldCollectionViewCell.swift
//  Blocks
//
//  Created by Volodya on 2/19/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import UIKit

class FieldCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: FieldCollectionViewCell.self)

    private(set) var cellData: FieldCell!
    
    func apply(cellData: FieldCell) {
        self.cellData = cellData
        backgroundColor = cellData.state.backgroundColor
    }
}
