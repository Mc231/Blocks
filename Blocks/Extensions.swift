//
//  Extensions.swift
//  Blocks
//
//  Created by Volodya on 3/21/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

extension Int {
    
    static func randomNum(maxValue: Int) -> Int {
        let uintMaxValue = UInt32(maxValue)
        return Int(arc4random_uniform(uintMaxValue))
    }
}
