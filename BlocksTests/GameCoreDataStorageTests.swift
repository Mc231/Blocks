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
		
		var saveSuccess = false
		var deleteSuccess = false
		
		func create<T>(_ object: T.Type) -> T? where T : NSManagedObject {
            if object == Game.self {
                return Game(context: .init(concurrencyType: .mainQueueConcurrencyType)) as? T
            }
            if object == Cell.self {
                return Cell(context: .init(concurrencyType: .mainQueueConcurrencyType)) as? T
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
	
	override func setUp() {
		super.setUp()
		coreDataManagerMock = CoreDataManageMock()
		sut = GameCoreDataStorage(coreDataManager: coreDataManagerMock)
	}
	
	override func tearDown() {
		coreDataManagerMock = nil
		sut = nil
		super.tearDown()
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
    
    func testCreateField() {
        // Given
        let expectedNumberOfCells = Constatns.Field.numberOfCellsOnField
        // When
        let field = sut.createField()
        // Then
        XCTAssertEqual(field.count, expectedNumberOfCells)
    }
}
