//
//  TableCollectionTestable.swift
//  BlocksUITests
//
//  Created by Volodymyr Shyrochuk on 09.12.2022.
//  Copyright © 2022 QuasarClaster. All rights reserved.
//

import Foundation
import XCTest


public protocol TableCollectionTestable {
    func refresh(inside element: XCUIElement, timeout: TimeInterval) -> Self
}

// MARK: - Default implementation

public extension TableCollectionTestable where Self: Robot {
    
    @discardableResult
    public func refresh(inside element: XCUIElement, timeout: TimeInterval = Robot.defaultTimeout) -> Self {
        guard [.table, .collectionView].contains(element.elementType) else {
            XCTFail("[\(self)] Cannot refresh inside element \(element.description)")
            return self
        }
        
        let cell = element.cells.firstMatch
        assert(cell, [.isHittable], timeout: timeout)
        
        let topCoordinate = cell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let bottomCoordinate = cell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 44))
        topCoordinate.press(forDuration: 0, thenDragTo: bottomCoordinate)
        
        return self
    }
}
