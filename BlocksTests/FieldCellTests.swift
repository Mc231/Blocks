//
//  FieldCellTests.swift
//  BlocksTests
//
//  Created by Volodymyr Shyrochuk on 29.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import XCTest
@testable import Blocks

class FieldCellTests: XCTestCase {

    func testFieldCellStateEmptyBackground() {
        // Given
        let expectedColor = UIColor.emptyCellBackground
        // When
        let cell = FieldCell(state: .empty)
        // Then
        XCTAssertEqual(expectedColor, cell.state.backgroundColor)
    }
    
    func testFieldCellStatePlacedBackground() {
        // Given
        let expectedColor = UIColor.placedCellBackground
        // When
        let cell = FieldCell(state: .placed)
        // Then
        XCTAssertEqual(expectedColor, cell.state.backgroundColor)
    }
    
    func testFieldCellStateSelectedBackground() {
        // Given
        let expectedColor = UIColor.selectedCellBackground
        // When
        let cell = FieldCell(state: .selected)
        // Then
        XCTAssertEqual(expectedColor, cell.state.backgroundColor)
    }
    
    func testFieldCellStateClearBackground() {
        // Given
        let expectedColor: UIColor = .clear
        // When
        let cell = FieldCell(state: .clear)
        // Then
        XCTAssertEqual(expectedColor, cell.state.backgroundColor)
    }
}
