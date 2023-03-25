//
//  LocalizationTests.swift
//  BlocksTests
//
//  Created by Volodymyr Shyrochuk on 29.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import XCTest
@testable import Blocks

class LocalizationTests: XCTestCase {

    func testScoreStrings() {
        // Given
        let score: Int32 = 12
        let expectedResult = ["Score:\n \(score)", "Best:\n \(score)"]
        // When
        let result = [
            Localization.Score.score(score),
            Localization.Score.best(score)
        ].map({$0.localized})
        // Then
        XCTAssertEqual(expectedResult, result)
    }
    
    func testGameOverAlertStrings() {
        // Given
        let score: Int32 = 12
        let expectedResult = ["Game Over", "Your score is \(score)", "Restart"]
        // When
        let result = [
            Localization.GameOverAlert.title.localized,
            Localization.GameOverAlert.message(score).localized,
            Localization.General.restart.localized
        ]
        // Then
        XCTAssertEqual(expectedResult, result)
    }
}
