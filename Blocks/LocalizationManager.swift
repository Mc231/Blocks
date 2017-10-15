//
//  LocalizationManager.swift
//  Blocks
//
//  Created by Volodya on 6/8/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

/// Localization protocol
protocol LocalizationProtocol {
    var localization: String {get}
}

/// This enum represents localized strings used in app
enum Localization {
    enum Game {
        enum Score: LocalizationProtocol {
            case best(Int32)
            case current(Int32)
            
            var localization: String {
                switch self {
                case .current(let currentScore):
                    return String(format: NSLocalizedString("Score:_d", comment: "current score"), currentScore)
                case .best(let bestScore):
                    return String(format: NSLocalizedString("Best:_d", comment: "best score"), bestScore)
                }
            }
        }
        enum GameOverAlert: LocalizationProtocol {
            case title
            case message(Int32)
            case restartTitle
            case cancelTitle
            
            var localization: String {
                switch self {
                case .title:
                    return NSLocalizedString("Game_Over", comment: "Game Over alert title")
                case .message(let currentScore):
                    return String(format: NSLocalizedString("Your_Score_is_d", comment: "Your score title"), currentScore)
                case .restartTitle:
                    return NSLocalizedString("Restart", comment: "Restart title")
                case .cancelTitle:
                    return NSLocalizedString("Cancel", comment: "Cancel title")
                }
            }
        }
    }
}
