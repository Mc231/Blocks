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

private extension CoreDataManagerTests {
    
    class CoreDataManagerDelegateMock: CoreDataManagerDelegate {
        
        var producedErrorCompletion: ((Error) -> Swift.Void)!
        var loadResultCompletion: ((Result<NSPersistentStoreDescription, Error>) -> Swift.Void)!
        
        func coreDataManager(_ manager: CoreDataManager, didLoadPresistentContainerWithResult result: Result<NSPersistentStoreDescription, Error>) {
            loadResultCompletion(result)
        }
        
        func coreDataManager(_ manager: CoreDataManager, didProduceError error: Error) {
            producedErrorCompletion(error)
        }
    }
}

class CoreDataManagerTests: XCTestCase {
    
    private var delegate: CoreDataManagerDelegateMock!
    

    override func setUpWithError() throws {
        delegate = CoreDataManagerDelegateMock()
    }

    override func tearDownWithError() throws {
        delegate = nil
    }

    func testInitManagerWithError() {
        // Given
        let promise = expectation(description: "Wait for init error")
        let modelName = "asd"
        let sut = CoreDataManager(modelName: modelName, delegate: delegate)
        delegate.loadResultCompletion = { result in
            // Then
            if case .failure(let error) = result {
                XCTAssertNotNil(error)
                promise.fulfill()
            }
         }
        // When
        let _ = sut.persistentContainer
        wait(for: [promise], timeout: 3.0)
    }

}
