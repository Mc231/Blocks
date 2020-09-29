//
//  NibReusableTests.swift
//  BlocksTests
//
//  Created by Volodymyr Shyrochuk on 29.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import XCTest
@testable import Blocks

// MARK: - Mock

fileprivate class MockNib: UIView, NibReusable { }

class NibReusableTests: XCTestCase {

    func testInitFromNib() {
        // When
        let identifier = MockNib.identifier
        let nib = MockNib.nib
        // Then
        XCTAssertNotNil(nib)
        XCTAssertEqual(identifier, String(describing: MockNib.self))
    }
}
