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
    
    var textColor: UIColor? {
        switch self {
        case .scoreLabel:
            return .pillText
        }
    }
    
    var backgroundColor: UIColor? {
        switch self {
        case .scoreLabel:
            return .pillBackground
        }
    }
    
    var textAlign: NSTextAlignment {
        switch self {
        case .scoreLabel:
            return .center
        }
    }
}
