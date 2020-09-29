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
        let expectedColor = #colorLiteral(red: 0.9294117647, green: 0.9176470588, blue: 0.8470588235, alpha: 1)
        // When
        let cell = FieldCell(state: .empty)
        // Then
        XCTAssertEqual(expectedColor, cell.state.backgroundColor)
    }
    
    func testFieldCellStatePlacedBackground() {
        // Given
        let expectedColor = #colorLiteral(red: 0.9921568627, green: 0.5803921569, blue: 0.2196078431, alpha: 1)
        // When
        let cell = FieldCell(state: .placed)
        // Then
        XCTAssertEqual(expectedColor, cell.state.backgroundColor)
    }
    
    func testFieldCellStateSelectedBackground() {
        // Given
        let expectedColor = #colorLiteral(red: 0.5490196078, green: 0.6078431373, blue: 0.1647058824, alpha: 1)
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
