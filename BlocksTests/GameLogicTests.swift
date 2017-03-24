//
//  GameLogicTests.swift
//  Blocks
//
//  Created by Volodya on 3/24/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import XCTest
@testable import Blocks

class GameLogicTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - GameLogicTests
    
    let gameLogic = GameLogicManager()
    
    func testGameLogicCreateField() {
        let field = gameLogic.createField()
        XCTAssertTrue(field.count == 64)
    }
}
