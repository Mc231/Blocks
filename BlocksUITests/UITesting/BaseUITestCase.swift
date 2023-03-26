//
//  BaseUITestCase.swift
//  BlocksUITests
//
//  Created by Volodymyr Shyrochuk on 09.12.2022.
//  Copyright © 2022 QuasarClaster. All rights reserved.
//

import XCTest

/// Base class for UI tests with single method
open class BaseUITestCase: XCTestCase {
    
    /// Application identifier to lunch override this if needed
    open var app: XCUIApplication {
        return XCUIApplication(bundleIdentifier: "com.voldymyrs.blocks")
    }
}
