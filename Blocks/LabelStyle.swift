//
//  TextStyle.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 13.11.2022.
//  Copyright © 2022 QuasarClaster. All rights reserved.
//

import UIKit

/**
 Style of the label
 */
enum LabelStyle {
    case scoreLabel
    
    var font: UIFont {
        switch self {
        case .scoreLabel:
            return UIFont.systemFont(ofSize: 15.0)
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .scoreLabel:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .scoreLabel:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    var textAlign: NSTextAlignment {
        switch self {
        case .scoreLabel:
            return .center
        }
    }
}
