//
//  Localizable.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 29.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import Foundation


/// Localization protocol
protocol Localizable {
    var localized: String {get}
}

// MARK: - Default implementation

extension Localizable {
    func localized(key: String,
                   comment: String = "",
                   bundle: Bundle = .main) -> String {
        return NSLocalizedString(key, bundle: bundle, comment: comment)
    }
}
