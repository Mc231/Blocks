//
//  GameCoreDataStorageTests.swift
//  BlocksTests
//
//  Created by Volodymyr Shyrochuk on 16.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import XCTest
import CoreData
@testable import Blocks

// MARK: - Mock

private extension GameCoreDataStorageTests {
	
	class CoreDataManageMock: CoreDataManagerProtocol {
        
        var storedObjects: [NSManagedObject] = []
		private var context: NSManagedObjectContext
		
		init(context: NSManagedObjectContext) {
			self.context = context
		}
		
		var saveSuccess = false
		var deleteSuccess = false
		
		func create<T>(_ object: T.Type) -> T? where T : NSManagedObject {
            if object == Game.self {
                return Game(context: context) as? T
            }
            if object == Cell.self {
                return Cell(context: context) as? T
            }
            return nil
		}
		
		func save<T>(_ object: T?) where T : NSManagedObject {
            if let object = object {
                storedObjects.append(object)
                saveSuccess.toggle()
            }
		}
		
		func findFirstOrCreate<T>(_ object: T.Type, predicate: NSPredicate?) -> T? where T : NSManagedObject {
			return create(object)
		}
		
		func fetch<T>(_ object: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [T] where T : NSManagedObject {
            return storedObjects.filter { (storedObject) -> Bool in
                return type(of: storedObject) == object
            } as! [T]
		}
		
		func delete<T>(_ object: T) where T : NSManagedObject {
            if let index = storedObjects.firstIndex(of: object) {
                storedObjects.remove(at: index)
                deleteSuccess.toggle()
            }
		}
	}
}

class GameCoreDataStorageTests: XCTestCase {
	
	private var context: NSManagedObjectContext!
	private var coreDataManagerMock: CoreDataManageMock!
	private var sut: GameCoreDataStorage!
	
	override func setUp() {
		super.setUp()
		context = NSManagedObjectContext.contextForTests
		coreDataManagerMock = CoreDataManageMock(context: context)
		sut = GameCoreDataStorage(coreDataManager: coreDataManagerMock)
	}
	
	override func tearDown() {
		context = nil
		coreDataManagerMock = nil
		sut = nil
		super.tearDown()
	}
	
	func testGameScore() {
		// Given
		let expectedScore = GameScore(current: 0, best: 0)
		// When
		let result = sut.gameScore
		// Then
		XCTAssertEqual(expectedScore, result)
	}
	
	func testGetFieldWhenStoredCellsIsNotEmpty() {
		// Given
		let expectedResult = sut.createField()
		// When
		let result = sut.field
		// Then
		XCTAssertEqual(expectedResult, result)
	}
	
	func testTetramonioIndexesIsEmptyForNotStoredGame() {
		// When
		let indexes = sut.tetramoniosIndexes
		// Then
		XCTAssertTrue(indexes.isEmpty)
	}
	
	func testTetramonioIndexesIsNotEmptyForNotStoredGame() {
		// Given
		let tetramonios: [Tetramonio] = [.emptyOfType(type: .iV), .emptyOfType(type: .j)]
		sut.store(current: tetramonios)
		let expectedIndexes: [Int16] = tetramonios.map({$0.id.rawValue})
		// When
		let indexes = sut.tetramoniosIndexes
		// Then
		XCTAssertEqual(indexes, expectedIndexes)
	}
	
	func testFieldCreatedWhenAccessFieldProperty() {
		// When
		let field = sut.field
		// Then
		XCTAssertFalse(field.isEmpty)
	}

    func testStoreInvalidNumberOfTetramoniosReturnFalse() {
		// Given
		let tetramonios: [Tetramonio] = []
		XCTAssertFalse(coreDataManagerMock.saveSuccess)
		// When
		let result = sut.store(current: tetramonios)
		// Then
		XCTAssertFalse(coreDataManagerMock.saveSuccess)
		XCTAssertFalse(result)
    }

    func testStoreInvalidNumberOfTetramoniosReturnTrue() {
		// Given
		XCTAssertFalse(coreDataManagerMock.saveSuccess)
		let tetramonios: [Tetramonio] = [.emptyOfType(type: .iH), .emptyOfType(type: .j)]
		// When
		let result = sut.store(current: tetramonios)
		// Then
		XCTAssertTrue(coreDataManagerMock.saveSuccess)
		XCTAssertTrue(result)
    }
	
	func testStoreField() {
		// Given
		XCTAssertFalse(coreDataManagerMock.saveSuccess)
		var field = sut.createField()
		field[0].chageState(newState: .clear)
		// When
		sut.storeField(field)
		// Then
		XCTAssertTrue(coreDataManagerMock.saveSuccess)
	}
	
	func testStoreUpdatedCells() {
		XCTAssertFalse(coreDataManagerMock.saveSuccess)
		var field = sut.createField()
		field[0].chageState(newState: .clear)
		let cellsToUpdate = [field[0]]
		// When
		sut.storeUpdatedCells(cellsToUpdate)
		// Then
		XCTAssertTrue(coreDataManagerMock.saveSuccess)
	}
	
	func testIncreaseAndStoreNewHeighScore() {
		// Given
		let expectedScore: Score = 32
		XCTAssertFalse(coreDataManagerMock.saveSuccess)
		// When
        let score = sut.increaseAndStoreScore(by: expectedScore)
		// Then
        XCTAssertEqual(score.best, expectedScore)
        XCTAssertTrue(coreDataManagerMock.saveSuccess)
	}
	
	func testRestartGame() {
		// Given
		XCTAssertFalse(coreDataManagerMock.saveSuccess)
		_ = sut.createField()
		// When
        let restartConfig = sut.restartGame()
		// Then
        XCTAssertEqual(restartConfig.score.current, sut.currentScore)
        XCTAssertEqual(restartConfig.score.best, sut.bestScore)
        XCTAssertTrue(!restartConfig.field.contains(where: {$0.state == .placed}))
	}
    
    func testCreateField() {
        // Given
        let expectedNumberOfCells = Constatns.Field.numberOfCellsOnField
        // When
        let field = sut.createField()
        // Then
        XCTAssertEqual(field.count, expectedNumberOfCells)
    }
}
