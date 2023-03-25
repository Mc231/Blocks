//
//  UILabel+Additions.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 13.11.2022.
//  Copyright © 2022 QuasarClaster. All rights reserved.
//

import UIKit

extension UILabel {
    /**
      Apply style to the label
      - parameter style: Label style to apply
     */
    func applyStyle(_ style: LabelStyle) {
        font = style.font
        textColor = style.textColor
        textAlignment = style.textAlign
        backgroundColor = style.backgroundColor
    }
}
