//
//  BlocksTests.swift
//  BlocksTests
//
//  Created by Volodya on 2/9/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import XCTest
@testable import Blocks

class BlocksTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - TetramonioDataPRoviderTest
    
    func testTetramonioDataProvider() {
       XCTAssertTrue(TetramonioDataProvider.sharedProvider.parseTetramonios().count == 19)
    }
    
    // MARK: - TetramonioManagerTests
    
    let manager = TetramonioManager()
    
    func testTetramonioManagerGenerateTetramonios() {
        let tetramonios = manager.generateTetramonios()
        XCTAssertTrue(tetramonios.count == 2)
        XCTAssertNotEqual(tetramonios.first?.id, tetramonios.last?.id)
    }
    
    func testTetramonioManagerUpdateFirstTetramonio() {
        
        for _ in 0...10000 {
            let tetramonios = manager.generateTetramonios()
            let updatedTetramonios = manager.generateTetramonios(.firtTetramonio)
            XCTAssertEqual(tetramonios.count, updatedTetramonios.count)
            XCTAssertNotEqual(tetramonios.first?.id, updatedTetramonios.first?.id)
            XCTAssertEqual(tetramonios.last?.id, updatedTetramonios.last?.id)
        }
    }
    
    func testTetramonioManagerUpdateSecondTetramonio() {
        let tetramonios = manager.generateTetramonios()
        let updatedTetramonios = manager.generateTetramonios(.secondTetramonio)
        XCTAssertEqual(tetramonios.count, updatedTetramonios.count)
        XCTAssertNotEqual(tetramonios.last?.id, updatedTetramonios.last?.id)
        XCTAssertEqual(tetramonios.first?.id, updatedTetramonios.first?.id)
    }
    
    // MARK: - GameLogicTests
    
    let gameLogic = GameLogicManager()
    
    func testGameLogicCreateField() {
        let field = gameLogic.createField()
        XCTAssertTrue(field.count == 64)
    }
    
    // MARK: - IntRandomNumberTest
    
    func testRandomFunc() {
        var result = Set<Int>()
        
        while result.count != 19 {
            let randomNum = Int.randomNum
            result.insert(randomNum)
        }
        XCTAssertTrue(result.count == 19)
    }
}
