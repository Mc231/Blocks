//
//  ButtonStyle.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 13.11.2022.
//  Copyright © 2022 QuasarClaster. All rights reserved.
//

import UIKit

/**
 Style of the button
 */
enum ButtonStyle {
    case actionButton
    
    var font: UIFont {
        switch self {
        case .actionButton:
            return UIFont.systemFont(ofSize: 15.0)
        }
    }
    
    var textColor: UIColor? {
        switch self {
        case .actionButton:
            return .pillText
        }
    }
    
    var backgroundColor: UIColor? {
        switch self {
        case .actionButton:
            return .pillBackground
        }
    }
}
