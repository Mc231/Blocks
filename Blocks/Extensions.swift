//
//  Extensions.swift
//  Blocks
//
//  Created by Volodya on 3/21/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation


extension Int16 {
    
    static func randomNum(maxValue: Int) -> Int16 {
        let uintMaxValue = UInt32(maxValue)
        return Int16(arc4random_uniform(uintMaxValue))
    }
}
