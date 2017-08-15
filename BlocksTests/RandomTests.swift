//
//  RandomTest.swift
//  Blocks
//
//  Created by Volodya on 3/24/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import XCTest
@testable import Blocks

class RandomTests: XCTestCase {
    
    func testRandomFunc() {
        var result = Set<Int16>()
        
        while result.count != 19 {
            let randomNum = Int16.randomNum(maxValue: 19)
            result.insert(randomNum)
        }
        XCTAssertTrue(result.count == 19)
    }
}

