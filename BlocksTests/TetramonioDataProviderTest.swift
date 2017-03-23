//
//  TetramonioDataProviderTest.swift
//  Blocks
//
//  Created by Volodya on 3/24/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import XCTest
@testable import Blocks

class TetramonioDataProviderTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTetramonioDataProvider() {
        XCTAssertTrue(TetramonioDataProvider.sharedProvider.parseTetramonios().count == 19)
    }
}
