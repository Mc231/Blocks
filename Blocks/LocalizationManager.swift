//
//  LocalizationManager.swift
//  Blocks
//
//  Created by Volodya on 6/8/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

protocol LocalizationProtocol {
    var localization: String {get}
}

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
    }
}
