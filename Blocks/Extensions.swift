//
//  Extensions.swift
//  Blocks
//
//  Created by Volodya on 3/21/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

extension Int {
    
    static var randomNum: Int {
        return Int(arc4random_uniform(19))
    }
}
