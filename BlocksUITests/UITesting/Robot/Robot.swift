//
//  Robot.swift
//  BlocksUITests
//
//  Created by Volodymyr Shyrochuk on 09.12.2022.
//  Copyright © 2022 QuasarClaster. All rights reserved.
//

import XCTest

/// https://github.com/jhandguy/SwiftKotlination/blob/master/ios/SwiftKotlination/SwiftKotlinationUITests/Sources/Robot/Robot.swift
open class Robot {
    
    public static let defaultTimeout: TimeInterval = 30
    
    // TODO: - Seperate this
    public static let kModule = "Robot.module"
    public static let kUITesting = "Robot.UITesting"
    public static let kNeedsNavigationController = "Robot.needsNavigationController"
    
    public lazy var navigationBar          = app.navigationBars.firstMatch
    public lazy var navigationBarButton    = navigationBar.buttons.firstMatch
    public lazy var navigationBarTitle     = navigationBar.staticTexts.firstMatch
    public lazy var alert                  = app.alerts.firstMatch
    public lazy var alertButton            = alert.buttons.firstMatch
    
    private(set) public var app: XCUIApplication
    private(set) public var safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
    
    public init(_ app: XCUIApplication) {
        self.app = app
    }
    
    
    @discardableResult
    public func start(needsNavigationController: Bool = false,
                      timeout: TimeInterval = Robot.defaultTimeout) -> Self {
        app.launchArguments.append(Robot.kUITesting)
        app.launchEnvironment[Robot.kNeedsNavigationController] = String(needsNavigationController)
        app.launch()
        assert(app, [.exists], timeout: timeout)
        return self
    }
    
    @discardableResult
    public func finish(timeout: TimeInterval = Robot.defaultTimeout) -> Self {
        app.terminate()
        assert(app, [.doesNotExist], timeout: timeout)
        return self
    }
    
    @discardableResult
    public func tap(_ element: XCUIElement,
               timeout: TimeInterval = Robot.defaultTimeout) -> Self {
        assert(element, [.isHittable], timeout: timeout)
        element.tap()
        return self
    }
    
    @discardableResult
    public func assert(_ element: XCUIElement,
                       _ predicates: [Predicate],
                       timeout: TimeInterval = Robot.defaultTimeout) -> Self {
        let predicate = NSPredicate(format: predicates.map {$0.format}.joined(separator: " AND "))
        let expecatation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        guard XCTWaiter.wait(for: [expecatation], timeout: timeout) == .completed else {
            XCTFail("\(self) Element: \(element.description) did not fulfill expectation \(predicate)")
            return self
        }
        return self
    }
    
    @discardableResult
    public func checkTitle(contains title: String, timeout: TimeInterval = Robot.defaultTimeout) -> Self {
        assert(navigationBar, [.isHittable], timeout: timeout)
        assert(navigationBarTitle, [.contains(title)], timeout: timeout)
        return self
    }
    
    @discardableResult
    public func back(timeout: TimeInterval = Robot.defaultTimeout) -> Self {
        tap(navigationBarButton, timeout: timeout)
        return self
    }
    
    @discardableResult
    public func takeScreenshot(named name: String, testCase: XCTestCase) -> Self {
        print("Take screenshoot nanmed: \(name)")
       // sleep(1)
        let screenshot = app.windows.firstMatch.screenshot()
        /// https://rderik.com/blog/understanding-xcuitest-screenshots-and-how-to-access-them/
        let attachment = XCTAttachment(uniformTypeIdentifier: "public.png",
                                       name: "Screenshoot-\(name)-\(UIDevice.current.name).png",
                                       payload: screenshot.pngRepresentation,
                                       userInfo: nil)
        attachment.lifetime = .keepAlways
        testCase.add(attachment)
        return self
    }
    
    @discardableResult
    public func performSafariAction(timeout: TimeInterval = Robot.defaultTimeout,
                                    action: ((Robot) -> Swift.Void)) -> Self {
        action(self)
        _ = safari.wait(for: .runningForeground, timeout: timeout)
        app.activate()
        return self
    }
}
