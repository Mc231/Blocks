//
//  UICollectionViewCell+Resuable.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 01.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import UIKit

extension UICollectionViewCell {

    static var identifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
