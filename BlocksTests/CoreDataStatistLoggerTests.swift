//
//  CoreDataStatistLoggerTests.swift
//  BlocksTests
//
//  Created by Volodymyr Shyrochuk on 26.03.2023.
//  Copyright © 2023 QuasarClaster. All rights reserved.
//

import XCTest
import CoreData
@testable import Blocks


class CoreDataStatistLoggerTests: XCTestCase {
	
	private var context: NSManagedObjectContext!
	private var coreDataManagerMock: CoreDataManageMock!
	private var sut: StatisticLogger!
	
	override func setUp() {
		super.setUp()
		context = NSManagedObjectContext.contextForTests
		coreDataManagerMock = CoreDataManageMock(context: context)
		sut = CoreDataStatisticLogger(coreDataManager: coreDataManagerMock)
	}
	
	override func tearDown() {
		context = nil
		coreDataManagerMock = nil
		sut = nil
		super.tearDown()
	}
	
	func testLogGameOver() {
		// Given
		XCTAssertEqual(sut.allTimeTotalScore, .zero)
		XCTAssertEqual(sut.bestScore, .zero)
		XCTAssertEqual(sut.playedGames, .zero)
		XCTAssertFalse(coreDataManagerMock.saveSuccess)
		// When
		sut.log(.gameOver(score: 32))
		// Then
		XCTAssertEqual(sut.allTimeTotalScore, 32)
		XCTAssertEqual(sut.bestScore, 32)
		XCTAssertEqual(sut.playedGames, 1)
		XCTAssertTrue(coreDataManagerMock.saveSuccess)
	}
	
	func testLogWipedRows() {
		// Given
		XCTAssertEqual(sut.linesWiped, .zero)
		// When
		sut.log(.wipedRows(count: 4))
		// Then
		XCTAssertEqual(sut.linesWiped, 4)
	}
	
	func testTetramonioPlaced() {
		// Given
		XCTAssertEqual(sut.placedTetramonios, .zero)
		// When
		sut.log(.teramonioPlaced)
		// Then
		XCTAssertEqual(sut.placedTetramonios, 1)
	}
	
	func testRestartGame() {
		// Given
		XCTAssertEqual(sut.restartedGames, .zero)
		// When
		sut.log(.restartGame)
		// Then
		XCTAssertEqual(sut.restartedGames, 1)
	}
}

