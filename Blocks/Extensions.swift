//
//  Extensions.swift
//  Blocks
//
//  Created by Volodya on 3/21/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import UIKit

extension Int16 {

    static func randomNum(maxValue: Int) -> Int16 {
        let uintMaxValue = UInt32(maxValue)
        return Int16(arc4random_uniform(uintMaxValue))
    }
}

extension UIColor {

    struct CellBackgrounds {
        static let empty = UIColor(red: 237.0 / 255.0, green: 234.0 / 255.0, blue: 216.0 / 255.0, alpha: 1.0)
        static let placed = UIColor(red: 253.0 / 255, green: 148.0 / 255, blue: 56.0 / 255, alpha: 1.0)
        static let selected = UIColor(red: 140.0 / 255, green: 155.0 / 255, blue: 42.0 / 255, alpha: 1.0)
    }
}

extension UICollectionViewCell {

    static var identifier: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
