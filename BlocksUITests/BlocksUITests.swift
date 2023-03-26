//
//  BlocksUITests.swift
//  BlocksUITests
//
//  Created by Volodymyr Shyrochuk on 03.12.2022.
//  Copyright © 2022 QuasarClaster. All rights reserved.
//

import XCTest

class AppRobot: Robot {
    
    private lazy var field = app.collectionViews["field"]
    private lazy var cells = field.cells
    
    func checkField() -> Self {
        assert(field, [.exists, .isHittable])
        return self
    }
    
    func tapCell(x: Int, y: Int) -> Self {
        let cell = cells["\(x):\(y)"]
        tap(cell)
        return self
    }
    
}

final class BlocksUITests: XCTestCase {


    func testExample() throws {
        let app = XCUIApplication()
        let robot = AppRobot(app).start().checkField()
            .tapCell(x: 1, y: 1)
            .tapCell(x: 2, y: 2)
            .tapCell(x: 3, y: 3)
            .tapCell(x: 4, y: 4)
            .tapCell(x: 5, y: 5)
            .tapCell(x: 6, y: 6)
            .tapCell(x: 7, y: 7)
            .tapCell(x: 8, y: 8)

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}
