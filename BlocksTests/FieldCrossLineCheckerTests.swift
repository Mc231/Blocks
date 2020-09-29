//
//  FieldCrossLineCheckerTests.swift
//  BlocksTests
//
//  Created by Volodymyr Shyrochuk on 29.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import XCTest
@testable import Blocks

// MARK: - Mocks

fileprivate class MockFieldCrossLineChecker: FieldCrossLineChecker { }

class FieldCrossLineCheckerTests: XCTestCase {
    
    private var sut: FieldCrossLineChecker!

    override func setUp() {
        super.setUp()
        sut = MockFieldCrossLineChecker()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testCheckForCroosLineReturnEmptyArray() {
        // Given
        var field: [FieldCell] = []
        // When
        let result = sut.checkForCroosLine(at: &field)
        // Then
        XCTAssertTrue(result.isEmpty)
    }
    
    func testChecForVerticalAndHorizontalLineReturnsResult() {
        // Given
        var field: [FieldCell] = FieldCell.mockedField
        let indexes = [0, 1, 2, 3, 4, 5, 6, 7, 8, 16, 24, 32, 40, 48, 56, 63]
        indexes.forEach({field[$0].chageState(newState: .placed)})
        let expectedUpdatedCells = 15
        //let expectedResult = in
        // When
        let result = sut.checkForCroosLine(at: &field)
        // Then
        XCTAssertEqual(result.count, expectedUpdatedCells)
    }
}
