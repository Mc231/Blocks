//
//  XCUIElement+Additions.swift
//  BlocksUITests
//
//  Created by Volodymyr Shyrochuk on 09.12.2022.
//  Copyright © 2022 QuasarClaster. All rights reserved.
//

import XCTest


public extension XCUIElement {
    
    static var defaultScrollOffset: CGFloat {
        return -44
    }
    
    //https://stackoverflow.com/questions/32897757/is-there-a-way-to-find-if-the-xcuielement-has-focus-or-not
    var hasFocus: Bool {
        let hasKeyboardFocus = (self.value(forKey: "hasKeyboardFocus") as? Bool) ?? false
        return hasKeyboardFocus
    }
    
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clear() {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        
        if !self.hasFocus {
            self.tap()
        }

        let deleteString = stringValue.map { _ in XCUIKeyboardKey.delete.rawValue }.joined(separator: "")
        self.typeText(deleteString)
    }
    
    /// https://stackoverflow.com/questions/32646539/scroll-until-element-is-visible-ios-ui-automation-with-xcode7
    func scrollToElement(element: XCUIElement, scrollOffset: CGFloat = XCUIElement.defaultScrollOffset) {
        while !element.visible {
            let app = XCUIApplication()
            // TODO: - ADd generic solution
            let startCoord = app.tables.element.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
            let endCoord = startCoord.withOffset(CGVector(dx: 0.0, dy: scrollOffset));
            startCoord.press(forDuration: 0.01, thenDragTo: endCoord)
        }
    }

    var visible: Bool {
        guard self.exists && !self.frame.isEmpty else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
    }
}
