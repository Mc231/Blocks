//
//  PlistDataProviderTests.swift
//  Blocks
//
//  Created by Volodya on 3/24/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import XCTest
@testable import Blocks

class PlistDataProviderTests: XCTestCase {

    func testPlistDataProviderGoodPlist() {
        // WARNING: - FIX THIS TEST
        let dataProvider = BundleResourceLoader(resource: "Tetramonios", type: "plist")
        XCTAssertNotNil(dataProvider.load())
    }

}
