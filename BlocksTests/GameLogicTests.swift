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
    
    let gameLogic = GameLogicManager()
    let tetramonios = TetremonioDataProvider().getTetramonios()
    let checkTetramonioManager = CheckTetramonioManager()
    
    lazy var field: [CellData] = {
        let field = self.gameLogic.createField()
        return field
    }()
    
    func testGameLogicCreateField() {
        XCTAssertEqual(field.count, 64)
    }
    
    func testBadTetramonio() {
        XCTAssertFalse(checkTetramonio(id: 4, firstIndex: 0, secondIndex: 1, thirdIndex: 2, fourthIndex: 3))
    }
    
    func testTetramonioIv() {
        XCTAssertTrue(checkTetramonio(id: 0, firstIndex: 0, secondIndex: 1, thirdIndex: 2, fourthIndex: 3))
        XCTAssertTrue(checkTetramonioGameOverIndexes(id: 0))
    }
    
    func testTetramonioIh() {
        XCTAssertTrue(checkTetramonio(id: 1, firstIndex: 0, secondIndex: 8, thirdIndex: 16, fourthIndex: 24))
        XCTAssertTrue(checkTetramonioGameOverIndexes(id: 1))
    }
    
    func testTetramonioO() {
        XCTAssertTrue(checkTetramonio(id: 2, firstIndex: 0, secondIndex: 1, thirdIndex: 8, fourthIndex: 9))
        XCTAssertTrue(checkTetramonioGameOverIndexes(id: 2))
    }
    
    func testTetramonioL90() {
        XCTAssertTrue(checkTetramonio(id: 3, firstIndex: 0, secondIndex: 8, thirdIndex: 16, fourthIndex: 17))
        XCTAssertTrue(checkTetramonioGameOverIndexes(id: 3))
    }
    
    func testTetramonioJ90() {
        XCTAssertTrue(checkTetramonio(id: 4, firstIndex: 0, secondIndex: 1, thirdIndex: 8, fourthIndex: 16))
        XCTAssertTrue(checkTetramonioGameOverIndexes(id: 4))
    }
    
    func testTetramonioL180() {
        XCTAssertTrue(checkTetramonio(id: 5, firstIndex: 0, secondIndex: 1, thirdIndex: 2, fourthIndex: 8))
        XCTAssertTrue(checkTetramonioGameOverIndexes(id: 5))
    }
    
    func testTetramonioJ() {
        XCTAssertTrue(checkTetramonio(id: 6, firstIndex: 0, secondIndex: 8, thirdIndex: 9, fourthIndex: 10))
        XCTAssertTrue(checkTetramonioGameOverIndexes(id: 6))
    }
    
    func testTetramonioJ270() {
        XCTAssertTrue(checkTetramonio(id: 7, firstIndex: 1, secondIndex: 9, thirdIndex: 16, fourthIndex: 17))
        XCTAssertTrue(checkTetramonioGameOverIndexes(id: 7))
    }
    
    func testTetramonioL270() {
        XCTAssertTrue(checkTetramonio(id: 8, firstIndex: 0, secondIndex: 1, thirdIndex: 9, fourthIndex: 17))
        XCTAssertTrue(checkTetramonioGameOverIndexes(id: 8))
    }
 
    func testTetramonioJ180() {
        XCTAssertTrue(checkTetramonio(id: 9, firstIndex: 0, secondIndex: 1, thirdIndex: 2, fourthIndex: 10))
        XCTAssertTrue(checkTetramonioGameOverIndexes(id: 9))
    }
    
    func testTetramonioL() {
        XCTAssertTrue(checkTetramonio(id: 10, firstIndex: 2, secondIndex: 8, thirdIndex: 9, fourthIndex: 10))
        XCTAssertTrue(checkTetramonioGameOverIndexes(id: 10))
    }
    
    func testTetramonioS() {
        XCTAssertTrue(checkTetramonio(id: 11, firstIndex: 8, secondIndex: 9, thirdIndex: 1, fourthIndex: 2))
        XCTAssertTrue(checkTetramonioGameOverIndexes(id: 11))
    }
    
    func testTetramonioS90() {
        XCTAssertTrue(checkTetramonio(id: 12, firstIndex: 0, secondIndex: 8, thirdIndex: 9, fourthIndex: 17))
        XCTAssertTrue(checkTetramonioGameOverIndexes(id: 12))
    }
    
    func testTetramonioZ() {
        XCTAssertTrue(checkTetramonio(id: 13, firstIndex: 0, secondIndex: 1, thirdIndex: 9, fourthIndex: 10))
        XCTAssertTrue(checkTetramonioGameOverIndexes(id: 13))
    }
    
    func testTetramonioZ90() {
        XCTAssertTrue(checkTetramonio(id: 14, firstIndex: 1, secondIndex: 8, thirdIndex: 9, fourthIndex: 16))
        XCTAssertTrue(checkTetramonioGameOverIndexes(id: 14))
    }
    
    func testTetramonioT180() {
        XCTAssertTrue(checkTetramonio(id: 15, firstIndex: 0, secondIndex: 1, thirdIndex: 2, fourthIndex: 9))
        XCTAssertTrue(checkTetramonioGameOverIndexes(id: 15))
    }
    
    func testTetramonioT() {
        XCTAssertTrue(checkTetramonio(id: 16, firstIndex: 1, secondIndex: 8, thirdIndex: 9, fourthIndex: 10))
        XCTAssertTrue(checkTetramonioGameOverIndexes(id: 16))
    }
    
    func testTetramonioT90() {
        XCTAssertTrue(checkTetramonio(id: 17, firstIndex: 0, secondIndex: 8, thirdIndex: 9, fourthIndex: 16))
        XCTAssertTrue(checkTetramonioGameOverIndexes(id: 17))
    }
    
    func testTetramonioT270() {
        XCTAssertTrue(checkTetramonio(id: 18, firstIndex: 8, secondIndex: 1, thirdIndex: 9, fourthIndex: 17))
        XCTAssertTrue(checkTetramonioGameOverIndexes(id: 18))
    }
    
    // MARK: - Private methods
    
    func checkTetramonio(id: Int, firstIndex: Int, secondIndex: Int, thirdIndex: Int, fourthIndex: Int) -> Bool {
        gameLogic.updateTetramonios([tetramonios[id]])
        checkTetramonioManager.updateTetramonios([tetramonios[id]])
        let currentTetramonio = [field[firstIndex], field[secondIndex], field[thirdIndex], field[fourthIndex]]
        return checkTetramonioManager.checkTetramonio(with: currentTetramonio)?.id == tetramonios[id].id
    }
    
    func checkTetramonioGameOverIndexes(id: Int) -> Bool {
        gameLogic.updateTetramonios([tetramonios[id]])
        checkTetramonioManager.updateTetramonios([tetramonios[id]])
        let gameOverIndexes = tetramonios[id].gameOverIndexes
        let firstCell  = field[28]
        let secondCell = field[28 + gameOverIndexes[0]]
        let thirdCell  = field[28 + gameOverIndexes[1]]
        let fourthCell = field[28 + gameOverIndexes[2]]
        let possibleTetramonio = [firstCell, secondCell, thirdCell, fourthCell]
        
        return checkTetramonioManager.checkTetramonio(with: possibleTetramonio)?.id == tetramonios[id].id
    }
}
