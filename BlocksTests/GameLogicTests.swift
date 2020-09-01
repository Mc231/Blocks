//
//  GameFlowTests.swift
//  Blocks
//
//  Created by Volodya on 3/24/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import XCTest
@testable import Blocks

class GameFlowTests: XCTestCase {

   // let GameFlow = GameFlowManager()
	let tetramonios = TetremonioDataLoader().tetramonios;
//   // let checkTetramonioManager = CheckTetramonioManager()
//    
//    lazy var field: [CellData] = {
//      //  let field = self.GameFlow.createField()
//        return field
//    }()
//    
    func testGameFlowCreateField() {
    //    XCTAssertEqual(field.count, 64)
    }

    func testBadTetramonio() {
		XCTAssertFalse(checkTetramonio(4, firstIndex: 0, secondIndex: 1, thirdIndex: 2, fourthIndex: 3))
    }

    func testTetramonioIv() {
		XCTAssertTrue(checkTetramonio(0, firstIndex: 0, secondIndex: 1, thirdIndex: 2, fourthIndex: 3))
		XCTAssertTrue(checkTetramonioGameOverIndexes(0))
    }

    func testTetramonioIh() {
		XCTAssertTrue(checkTetramonio(1, firstIndex: 0, secondIndex: 8, thirdIndex: 16, fourthIndex: 24))
		XCTAssertTrue(checkTetramonioGameOverIndexes(1))
    }

    func testTetramonioO() {
		XCTAssertTrue(checkTetramonio(2, firstIndex: 0, secondIndex: 1, thirdIndex: 8, fourthIndex: 9))
		XCTAssertTrue(checkTetramonioGameOverIndexes(2))
    }

    func testTetramonioL90() {
		XCTAssertTrue(checkTetramonio(3, firstIndex: 0, secondIndex: 8, thirdIndex: 16, fourthIndex: 17))
		XCTAssertTrue(checkTetramonioGameOverIndexes(3))
    }

    func testTetramonioJ90() {
		XCTAssertTrue(checkTetramonio(4, firstIndex: 0, secondIndex: 1, thirdIndex: 8, fourthIndex: 16))
		XCTAssertTrue(checkTetramonioGameOverIndexes(4))
    }

    func testTetramonioL180() {
		XCTAssertTrue(checkTetramonio(5, firstIndex: 0, secondIndex: 1, thirdIndex: 2, fourthIndex: 8))
		XCTAssertTrue(checkTetramonioGameOverIndexes(5))
    }

    func testTetramonioJ() {
		XCTAssertTrue(checkTetramonio(6, firstIndex: 0, secondIndex: 8, thirdIndex: 9, fourthIndex: 10))
		XCTAssertTrue(checkTetramonioGameOverIndexes(6))
    }

    func testTetramonioJ270() {
		XCTAssertTrue(checkTetramonio(7, firstIndex: 1, secondIndex: 9, thirdIndex: 16, fourthIndex: 17))
		XCTAssertTrue(checkTetramonioGameOverIndexes(7))
    }

    func testTetramonioL270() {
		XCTAssertTrue(checkTetramonio(8, firstIndex: 0, secondIndex: 1, thirdIndex: 9, fourthIndex: 17))
		XCTAssertTrue(checkTetramonioGameOverIndexes(8))
    }

    func testTetramonioJ180() {
		XCTAssertTrue(checkTetramonio(9, firstIndex: 0, secondIndex: 1, thirdIndex: 2, fourthIndex: 10))
		XCTAssertTrue(checkTetramonioGameOverIndexes(9))
    }

    func testTetramonioL() {
		XCTAssertTrue(checkTetramonio(10, firstIndex: 2, secondIndex: 8, thirdIndex: 9, fourthIndex: 10))
		XCTAssertTrue(checkTetramonioGameOverIndexes(10))
    }

    func testTetramonioS() {
		XCTAssertTrue(checkTetramonio(11, firstIndex: 8, secondIndex: 9, thirdIndex: 1, fourthIndex: 2))
		XCTAssertTrue(checkTetramonioGameOverIndexes(11))
    }

    func testTetramonioS90() {
		XCTAssertTrue(checkTetramonio(12, firstIndex: 0, secondIndex: 8, thirdIndex: 9, fourthIndex: 17))
		XCTAssertTrue(checkTetramonioGameOverIndexes(12))
    }

    func testTetramonioZ() {
		XCTAssertTrue(checkTetramonio(13, firstIndex: 0, secondIndex: 1, thirdIndex: 9, fourthIndex: 10))
		XCTAssertTrue(checkTetramonioGameOverIndexes(13))
    }

    func testTetramonioZ90() {
		XCTAssertTrue(checkTetramonio(14, firstIndex: 1, secondIndex: 8, thirdIndex: 9, fourthIndex: 16))
		XCTAssertTrue(checkTetramonioGameOverIndexes(14))
    }

    func testTetramonioT180() {
		XCTAssertTrue(checkTetramonio(15, firstIndex: 0, secondIndex: 1, thirdIndex: 2, fourthIndex: 9))
		XCTAssertTrue(checkTetramonioGameOverIndexes(15))
    }

    func testTetramonioT() {
		XCTAssertTrue(checkTetramonio(16, firstIndex: 1, secondIndex: 8, thirdIndex: 9, fourthIndex: 10))
		XCTAssertTrue(checkTetramonioGameOverIndexes(16))
    }

    func testTetramonioT90() {
		XCTAssertTrue(checkTetramonio(17, firstIndex: 0, secondIndex: 8, thirdIndex: 9, fourthIndex: 16))
		XCTAssertTrue(checkTetramonioGameOverIndexes(17))
    }

    func testTetramonioT270() {
		XCTAssertTrue(checkTetramonio(18, firstIndex: 8, secondIndex: 1, thirdIndex: 9, fourthIndex: 17))
		XCTAssertTrue(checkTetramonioGameOverIndexes(18))
    }

    // MARK: - Private methods
	// swiftlint:disable vertical_parameter_alignment
    func checkTetramonio(_ identifer: Int,
						 firstIndex: Int,
						 secondIndex: Int,
						 thirdIndex: Int,
						 fourthIndex: Int) -> Bool {
//        GameFlow.updateTetramonios([tetramonios[id]])
//        checkTetramonioManager.updateTetramonios([tetramonios[id]])
//        let currentTetramonio = [field[firstIndex], field[secondIndex], field[thirdIndex], field[fourthIndex]]
//        return checkTetramonioManager.checkTetramonio(with: currentTetramonio)?.id == tetramonios[id].id
        return true
    }

    func checkTetramonioGameOverIndexes(_ identifier: Int) -> Bool {
//        GameFlow.updateTetramonios([tetramonios[id]])
//        checkTetramonioManager.updateTetramonios([tetramonios[id]])
//        let gameOverIndexes = tetramonios[id].gameOverIndexes
//        let firstCell  = field[28]
//        let secondCell = field[28 + gameOverIndexes[0]]
//        let thirdCell  = field[28 + gameOverIndexes[1]]
//        let fourthCell = field[28 + gameOverIndexes[2]]
//        let possibleTetramonio = [firstCell, secondCell, thirdCell, fourthCell]

       // return checkTetramonioManager.checkTetramonio(with: possibleTetramonio)?.id == tetramonios[id].id
        return false
    }
}
