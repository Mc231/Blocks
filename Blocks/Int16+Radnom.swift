//
//  Int16+Radnom.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 01.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import Foundation

extension Int16 {

    static func randomNum(maxValue: Int) -> Int16 {
        let uintMaxValue = UInt32(maxValue)
        return Int16(arc4random_uniform(uintMaxValue))
    }
}
