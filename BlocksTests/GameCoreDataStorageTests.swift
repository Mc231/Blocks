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
		
		var objectToCreate: NSManagedObject?
		var saveSuccess = false
		var findFirsOrCreateObject: NSManagedObject?
		var fetchResult: [NSManagedObject]?
		var deleteSuccess = false
		
		func create<T>(_ object: T.Type) -> T? where T : NSManagedObject {
			return objectToCreate as? T
		}
		
		func save<T>(_ object: T?) where T : NSManagedObject {
			saveSuccess.toggle()
		}
		
		func findFirstOrCreate<T>(_ object: T.Type, predicate: NSPredicate?) -> T? where T : NSManagedObject {
			return objectToCreate as? T
		}
		
		func fetch<T>(_ object: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [T]? where T : NSManagedObject {
			return fetchResult as? [T]
		}
		
		func delete<T>(_ object: T) where T : NSManagedObject {
			deleteSuccess.toggle()
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

}
