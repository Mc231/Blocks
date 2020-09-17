////
////  CoreDataManagerTests.swift
////  BlocksTests
////
////  Created by Volodymyr Shyrochuk on 17.09.2020.
////  Copyright © 2020 QuasarClaster. All rights reserved.
////
//
//import XCTest
//import CoreData
//@testable import Blocks
//
//private extension CoreDataManagerTests {
//
//    class CoreDataManagerDelegateMock: CoreDataManagerDelegate {
//
//        var producedErrorCompletion: ((Error) -> Swift.Void)!
//        var loadResultCompletion: ((Result<NSPersistentStoreDescription, Error>) -> Swift.Void)!
//
//        func coreDataManager(_ manager: CoreDataManager, didLoadPresistentContainerWithResult result: Result<NSPersistentStoreDescription, Error>) {
//            loadResultCompletion(result)
//        }
//
//        func coreDataManager(_ manager: CoreDataManager, didProduceError error: Error) {
//            producedErrorCompletion(error)
//        }
//    }
//}
//
//class CoreDataManagerTests: XCTestCase {
//
//    private var delegate = CoreDataManagerDelegateMock()
//
//
//    func testInitManagerWithError() {
//        // Given
//        let promise = expectation(description: "Wait for init error")
//        let modelName = "asd"
//        delegate.loadResultCompletion = { result in
//            // Then
//            if case .failure(let error) = result {
//                XCTAssertNotNil(error)
//                promise.fulfill()
//            }
//         }
//        let sut = CoreDataManager(modelName: modelName, delegate: delegate)
//
//        // When
//        sut.persistentContainer.newBackgroundContext()
//        wait(for: [promise], timeout: 5.0)
//    }
//
//}
