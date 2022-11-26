//
//  LocalizationManager.swift
//  Blocks
//
//  Created by Volodya on 6/8/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

/// This enum represents localized strings used in app
enum Localization {
    
    // swiftlint:disable nesting
    enum General: Localizable {
        case menu
        case restart
        
        var localized: String {
            switch self {
            case .menu:
                return localized(key: "Menu")
            case .restart:
                return localized(key: "Restart")
            }
        }
    }
    
    // swiftlint:disable nesting
    enum Score: Localizable {
        case score(Int32)
        case best(Int32)
        
        var localized: String {
            switch self {
            case .score(let currentScore):
                let key = localized(key: "Score:_d")
                return String(format: key, currentScore)
            case .best(let bestScore):
                let key = localized(key: "Best:_d")
                return String(format: key, bestScore)
            }
        }
    }
    // swiftlint:disable nesting
    enum GameOverAlert: Localizable {
        case title
        case message(Int32)

        var localized: String {
            switch self {
            case .title:
                return localized(key: "Game_Over")
            case .message(let currentScore):
                let key = localized(key: "Your_Score_is_d")
                return String(format: key, currentScore)
            }
        }
    }
}
