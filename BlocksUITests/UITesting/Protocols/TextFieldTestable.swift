//
//  TextFieldTestable.swift
//  BlocksUITests
//
//  Created by Volodymyr Shyrochuk on 09.12.2022.
//  Copyright © 2022 QuasarClaster. All rights reserved.
//

import Foundation
import XCTest

public protocol TextFieldTestable {
    func typeText(_ element: XCUIElement, text: String, timeout: TimeInterval) -> Self
    func clearText(_ element: XCUIElement, timeout: TimeInterval) -> Self
}

// MARK: - Default implementation

public extension TextFieldTestable where Self: Robot {
    
    @discardableResult
    func typeText(_ element: XCUIElement,
                         text: String,
                         timeout: TimeInterval = Robot.defaultTimeout) -> Self {
        assert(element, [.isHittable], timeout: timeout)
        element.typeText(text)
        return self
    }
    
    @discardableResult
    func clearText(_ element: XCUIElement,
                         timeout: TimeInterval = Robot.defaultTimeout) -> Self {
        assert(element, [.isHittable], timeout: timeout)
        element.clear()
        return self
    }
}
