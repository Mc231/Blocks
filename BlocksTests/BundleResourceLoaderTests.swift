//
//  BundleResourceLoaderTests.swift
//  Blocks
//
//  Created by Volodya on 3/24/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import XCTest
@testable import Blocks

class BundleResourceLoaderTests: XCTestCase {
    
    private var sut: ResourceLoadable!
    private var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
    
    override func setUp() {
        super.setUp()
        sut = BundleResourceLoader(bundle: bundle)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testLoadThrowsInvalidPath() {
        // Given
        let resource = "asd/"
        let type = "...."
        // When
        XCTAssertThrowsError(try sut.load(resource: resource, type: type),
                             "Throw Invalid path") { (error) in
                                // Then
                                XCTAssertEqual(error as? ResourceLoadingError, .invalidPath)
        }
    }
    
    func testLoadSuccess() {
        // Given
        let resource = "Tetramonios"
        let type = "plist"
        // When & Then
        XCTAssertNoThrow(try sut.load(resource: resource, type: type))
    }
}
