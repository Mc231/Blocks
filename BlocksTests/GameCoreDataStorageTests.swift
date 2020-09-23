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
		private var context: NSManagedObjectContext = .init(concurrencyType: .mainQueueConcurrencyType)
		
		var saveSuccess = false
		var deleteSuccess = false
		
		func create<T>(_ object: T.Type) -> T? where T : NSManagedObject {
            if object == Game.self {
				NSEntityDescription.insertNewObject(forEntityName: Game.entity(), into: context)
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
            } as [T]
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
	
	private var coreDataManagerMock: CoreDataManageMock!
	private var sut: GameCoreDataStorage!
	private var coreDataManager = CoreDataManager(modelName: "Blocks")
	
	override func setUp() {
		super.setUp()
		_ = coreDataManager.persistentContainer
		coreDataManagerMock = CoreDataManageMock()
		sut = GameCoreDataStorage(coreDataManager: coreDataManagerMock)
	}
	
	override func tearDown() {
		coreDataManagerMock = nil
		sut = nil
		super.tearDown()
	}
	
	func testTetramonioIndexes() {
		// When
		let indexes = sut.tetramoniosIndexes
		// Then
		XCTAssertTrue(indexes.isEmpty)
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
		let score: Score = 32
		let promise = expectation(description: "Waiting for score increase")
		XCTAssertFalse(coreDataManagerMock.saveSuccess)
		// When
		sut.increaseAndStoreScore(score) { (storedScore) in
			XCTAssertEqual(storedScore.best, score)
			XCTAssertTrue(self.coreDataManagerMock.saveSuccess)
			promise.fulfill()
		}
		// Then
		wait(for: [promise], timeout: 1.0)
	}
	
	func testRestartGame() {
		// Given
		let promise = expectation(description: "Waiting for game restart")
		XCTAssertFalse(coreDataManagerMock.saveSuccess)
		_ = sut.createField()
		// When
		sut.restartGame { (score, field) in
			XCTAssertEqual(score.current, self.sut.currentScore)
			XCTAssertEqual(score.best, self.sut.bestScore)
			XCTAssertTrue(!field.contains(where: {$0.state == .placed}))
			promise.fulfill()
		}
		// Then
		wait(for: [promise], timeout: 1.0)
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
