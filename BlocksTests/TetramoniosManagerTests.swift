//
//  TetramoniosManagerTests.swift
//  Blocks
//
//  Created by Volodya on 3/24/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import XCTest
@testable import Blocks

class TetramoniosManagerTests: XCTestCase {
    
    let manager = TetramonioManager()
    
    func testTetramonioManagerGenerateTetramonios() {
        let tetramonios = manager.generateTetramonios()
        XCTAssertTrue(tetramonios.count == 2)
        XCTAssertNotEqual(tetramonios.first?.id, tetramonios.last?.id)
    }
    
    func testTetramonioManagerUpdateFirstTetramonio() {
        let tetramonios = manager.generateTetramonios()
        let updatedTetramonios = manager.generateTetramonios(.firtTetramonio)
        XCTAssertEqual(tetramonios.count, updatedTetramonios.count)
        XCTAssertNotEqual(tetramonios.first?.id, updatedTetramonios.first?.id)
        XCTAssertEqual(tetramonios.last?.id, updatedTetramonios.last?.id)
    }
    
    func testTetramonioManagerUpdateSecondTetramonio() {
        let tetramonios = manager.generateTetramonios()
        let updatedTetramonios = manager.generateTetramonios(.secondTetramonio)
        XCTAssertEqual(tetramonios.count, updatedTetramonios.count)
        XCTAssertNotEqual(tetramonios.last?.id, updatedTetramonios.last?.id)
        XCTAssertEqual(tetramonios.first?.id, updatedTetramonios.first?.id)
    }
}
