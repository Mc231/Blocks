//
//  AlertTestable.swift
//  BlocksUITests
//
//  Created by Volodymyr Shyrochuk on 09.12.2022.
//  Copyright © 2022 QuasarClaster. All rights reserved.
//

import Foundation
import XCTest

public protocol AlertTestable {
    func checkAlert(timeout: TimeInterval) -> Self
    func closeAlert(timeout: TimeInterval) -> Self
}

// MARK: - Default implementation

public extension AlertTestable where Self: Robot {
    
    @discardableResult
    func checkAlert(timeout: TimeInterval = Robot.defaultTimeout) -> Self {
        assert(alert, [.exists], timeout: timeout)
        return self
    }
    
    @discardableResult
    func closeAlert(timeout: TimeInterval = Robot.defaultTimeout) -> Self {
        assert(alert, [.exists])
        tap(alertButton)
        assert(alert, [.doesNotExist])
        return self
    }
}
