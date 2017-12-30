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

    let manager = TetramonioManager(tetramonioDataProvider: TetremonioDataProvider())

    func testTetramonioManagerGenerateTetramonios() {
        let tetramonios = manager.generateTetramonios()
        XCTAssertTrue(tetramonios.count == 2)
        XCTAssertNotEqual(tetramonios.first?.identifier, tetramonios.last?.identifier)
    }

    func testTetramonioManagerUpdateFirstTetramonio() {
        let tetramonios = manager.generateTetramonios()
        let updatedTetramonios = manager.generateTetramonios(.firtTetramonio)
        XCTAssertEqual(tetramonios.count, updatedTetramonios.count)
        XCTAssertNotEqual(tetramonios.first?.identifier, updatedTetramonios.first?.identifier)
        XCTAssertEqual(tetramonios.last?.identifier, updatedTetramonios.last?.identifier)
    }

    func testTetramonioManagerUpdateSecondTetramonio() {
        let tetramonios = manager.generateTetramonios()
        let updatedTetramonios = manager.generateTetramonios(.secondTetramonio)
        XCTAssertEqual(tetramonios.count, updatedTetramonios.count)
        XCTAssertNotEqual(tetramonios.last?.identifier, updatedTetramonios.last?.identifier)
        XCTAssertEqual(tetramonios.first?.identifier, updatedTetramonios.first?.identifier)
    }
}
