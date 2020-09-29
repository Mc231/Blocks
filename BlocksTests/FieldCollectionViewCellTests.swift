//
//  FieldCollectionViewCellTests.swift
//  BlocksTests
//
//  Created by Volodymyr Shyrochuk on 29.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import XCTest
@testable import Blocks

class FieldCollectionViewCellTests: XCTestCase {
    
    func testTwoCellsAreEquals() {
        // Given
        let cellData = FieldCell(state: .empty)
        let cell1 = FieldCollectionViewCell()
        cell1.apply(cellData: cellData)
        // When
        let cell2 = cell1
        // Then
        XCTAssertEqual(cell1, cell2)
    }
    
    func testTwoCellsAreNotEquals() {
        // Given
        let cellData1 = FieldCell(state: .empty)
        let cell1 = FieldCollectionViewCell()
        cell1.apply(cellData: cellData1)
        // When
        let cellData2 = FieldCell(xPosition: 1, yPosition: 1, state: .clear)
        let cell2 = FieldCollectionViewCell()
        cell2.apply(cellData: cellData2)
        // Then
        XCTAssertNotEqual(cell1, cell2)
    }
}
