//
//  FieldCell.swift
//  Blocks
//
//  Created by Volodya on 2/19/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import UIKit

class FieldCell: UICollectionViewCell {
    
    static let cellIdentifier = "FieldCell"
    
    var cellData: CellData! {
        didSet{
            switch cellData.state {
            case .empty:
                backgroundColor = UIColor.white
            case .placed:
                backgroundColor = UIColor.orange
            case .selected:
                backgroundColor = UIColor.red
                
            }
        }
    }
    
}
