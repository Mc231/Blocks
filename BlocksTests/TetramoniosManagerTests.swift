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

    let manager = TetramonioManager(tetramonioDataProvider: TetremonioDataLoader())

    func testTetramonioManagerGenerateTetramonios() {
        let tetramonios = manager.generateTetramonios()
        XCTAssertTrue(tetramonios.count == 2)
        XCTAssertNotEqual(tetramonios.first?.type, tetramonios.last?.type)
    }

    func testTetramonioManagerUpdateFirstTetramonio() {
        let tetramonios = manager.generateTetramonios()
        let updatedTetramonios = manager.generateTetramonios(.firtTetramonio)
        XCTAssertEqual(tetramonios.count, updatedTetramonios.count)
        XCTAssertNotEqual(tetramonios.first?.type, updatedTetramonios.first?.type)
        XCTAssertEqual(tetramonios.last?.type, updatedTetramonios.last?.type)
    }

    func testTetramonioManagerUpdateSecondTetramonio() {
        let tetramonios = manager.generateTetramonios()
        let updatedTetramonios = manager.generateTetramonios(.secondTetramonio)
        XCTAssertEqual(tetramonios.count, updatedTetramonios.count)
        XCTAssertNotEqual(tetramonios.last?.type, updatedTetramonios.last?.type)
        XCTAssertEqual(tetramonios.first?.type, updatedTetramonios.first?.type)
    }
}
