//
//  UIButton+Additions.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 13.11.2022.
//  Copyright © 2022 QuasarClaster. All rights reserved.
//

import UIKit

extension UIButton {
    
    /**
      Apply style to the button
      - parameter style: Button style to apply
      - parameter states: States of the button
     */
    func applyStyle(_ style: ButtonStyle, states: [UIControl.State] = [.normal, .highlighted]) {
        titleLabel?.font = style.font
        states.forEach({setTitleColor(style.textColor, for: $0)})
        backgroundColor = style.backgroundColor
    }
}
