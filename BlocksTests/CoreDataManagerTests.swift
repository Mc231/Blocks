//
//  CoreDataManagerTests.swift
//  BlocksTests
//
//  Created by Volodymyr Shyrochuk on 17.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import XCTest
import CoreData
@testable import Blocks

class CoreDataManagerTests: XCTestCase {

	private var sut: CoreDataManager!
	
	override func setUp() {
		super.setUp()
		sut = CoreDataManager(modelName: "")
	}
	
	override func tearDown() {
		sut = nil
		super.tearDown()
	}

	func testCreate() {
		// Given
		let modelType = Game.self
		// When
		let object = sut.create(modelType)
		// Then
		XCTAssertNotNil(object)
	}
	
	func testSaveSuccess() {
		// Given
		let game = Game()
		// When & Then
		sut.save(game)
	}
	
	func testFindFirstOrCrateCreateObject() {
		// Given
		let type = Game.self
		// When
		let object = sut.findFirstOrCreate(type, predicate: nil)
		// Then
		XCTAssertNotNil(object)
	}
	
	func testFindFirstOrCrateFetchObject() {
		// Given
		let type = Game.self
		let object1 = sut.create(type)
		// When
		let object2 = sut.findFirstOrCreate(type, predicate: nil)
		// Then
		XCTAssertEqual(object1, object2)
	}
	
	func testFetchObjectsReturnEmptyArray() {
		// Given
		let type = Game.self
		// When
		let result = sut.fetch(type)
		// Then
		XCTAssertTrue(result.isEmpty)
	}
	
	func testFetchObjectsReturnNonEmptyArray() {
		// Given
		let type = Game.self
		let object = sut.create(type)
		// When
		let result = sut.fetch(type)
		// Then
		XCTAssertFalse(result.isEmpty)
		XCTAssertTrue(result.contains(object!))
	}
	
	func testDelete() {
		// Given
		let object = Game()
		// When % Then
		sut.delete(object)
	}

}

