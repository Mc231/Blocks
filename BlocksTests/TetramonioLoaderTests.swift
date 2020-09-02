//
//  TetramonioLoaderTests.swift
//  Blocks
//
//  Created by Volodya on 3/24/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import XCTest
@testable import Blocks

private extension TetramonioLoaderTests {
    class MockResourceLoader: ResourceLoadable {
        
        var loadSuccess = true
        
        func load(resource named: String, type: String) throws -> Data {
            if loadSuccess {
                let result: [Tetramonio] = []
                return try PropertyListEncoder().encode(result)
            }
            throw ResourceLoadingError.invalidPath
        }
    }
}

class TetramonioLoaderTests: XCTestCase {
    
    private var sut: TetremonioLoader!
    private var mockResourceLoader = MockResourceLoader()
    private let plistDecoder = PropertyListDecoder()
    
    override func setUp() {
        super.setUp()
        sut = TetremonioLoader(resourceLoader: mockResourceLoader, plistDecoder: plistDecoder)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testLoadSuccess() {
        // Given
        mockResourceLoader.loadSuccess = true
        // When & then
        XCTAssertNoThrow(try sut.load())
    }
    
    func testLoadFailed() {
        // Given
        mockResourceLoader.loadSuccess = false
        // When
        XCTAssertThrowsError(try sut.load(), "Throw Invalid path") { (error) in
            // Then
            XCTAssertEqual(error as? ResourceLoadingError, .invalidPath)
        }
    }
}
