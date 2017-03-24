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
    }
    
    func testTetramonioIh() {
        XCTAssertTrue(checkTetramonio(id: 1, firstIndex: 0, secondIndex: 8, thirdIndex: 16, fourthIndex: 24))
    }
    
    func testTetramonioO() {
        XCTAssertTrue(checkTetramonio(id: 2, firstIndex: 0, secondIndex: 1, thirdIndex: 8, fourthIndex: 9))
    }
    
    func testTetramonioL90() {
        XCTAssertTrue(checkTetramonio(id: 3, firstIndex: 0, secondIndex: 8, thirdIndex: 16, fourthIndex: 17))
    }
    
    func testTetramonioJ90() {
        XCTAssertTrue(checkTetramonio(id: 4, firstIndex: 0, secondIndex: 1, thirdIndex: 8, fourthIndex: 16))
    }
    
    func testTetramonioL180() {
        XCTAssertTrue(checkTetramonio(id: 5, firstIndex: 0, secondIndex: 1, thirdIndex: 2, fourthIndex: 8))
    }
    
    func testTetramonioJ() {
        XCTAssertTrue(checkTetramonio(id: 6, firstIndex: 0, secondIndex: 8, thirdIndex: 9, fourthIndex: 10))
    }
    
    func testTetramonioJ270() {
        XCTAssertTrue(checkTetramonio(id: 7, firstIndex: 1, secondIndex: 9, thirdIndex: 16, fourthIndex: 17))
    }
    
    func testTetramonioL270() {
        XCTAssertTrue(checkTetramonio(id: 8, firstIndex: 0, secondIndex: 1, thirdIndex: 9, fourthIndex: 17))
    }
 
    func testTetramonioJ180() {
        XCTAssertTrue(checkTetramonio(id: 9, firstIndex: 0, secondIndex: 1, thirdIndex: 2, fourthIndex: 10))
    }
    
    func testTetramonioL() {
        XCTAssertTrue(checkTetramonio(id: 10, firstIndex: 2, secondIndex: 8, thirdIndex: 9, fourthIndex: 10))
    }
    
    func testTetramonioS() {
        XCTAssertTrue(checkTetramonio(id: 11, firstIndex: 8, secondIndex: 9, thirdIndex: 1, fourthIndex: 2))
    }
    
    func testTetramonioS90() {
        XCTAssertTrue(checkTetramonio(id: 12, firstIndex: 0, secondIndex: 8, thirdIndex: 9, fourthIndex: 17))
    }
    
    func testTetramonioZ() {
        XCTAssertTrue(checkTetramonio(id: 13, firstIndex: 0, secondIndex: 1, thirdIndex: 9, fourthIndex: 10))
    }
    
    func testTetramonioZ90() {
        XCTAssertTrue(checkTetramonio(id: 14, firstIndex: 1, secondIndex: 8, thirdIndex: 9, fourthIndex: 16))
    }
    
    func testTetramonioT180() {
        XCTAssertTrue(checkTetramonio(id: 15, firstIndex: 0, secondIndex: 1, thirdIndex: 2, fourthIndex: 9))
    }
    
    func testTetramonioT() {
        XCTAssertTrue(checkTetramonio(id: 16, firstIndex: 1, secondIndex: 8, thirdIndex: 9, fourthIndex: 10))
    }
    
    func testTetramonioT90() {
        XCTAssertTrue(checkTetramonio(id: 17, firstIndex: 0, secondIndex: 8, thirdIndex: 9, fourthIndex: 16))
    }
    
    func testTetramonioT270() {
        XCTAssertTrue(checkTetramonio(id: 18, firstIndex: 8, secondIndex: 1, thirdIndex: 9, fourthIndex: 17))
    }
    
    // MARK: - Private methods
    
    func checkTetramonio(id: Int, firstIndex: Int, secondIndex: Int, thirdIndex: Int, fourthIndex: Int) -> Bool {
        gameLogic.setCurrentTetramonios([tetramonios[id]])
        debugPrint(tetramonios[id].id)
        let currentTetramonio = [field[firstIndex], field[secondIndex], field[thirdIndex], field[fourthIndex]]
        return gameLogic.checkTetramonio(with: currentTetramonio)?.id == tetramonios[id].id
    }
}
