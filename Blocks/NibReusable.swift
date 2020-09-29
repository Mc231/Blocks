//
//  NibReusable.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 29.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import UIKit

protocol NibReusable: Reusable {
    static var nib: UINib { get }
}

// MARK: - Default implementation

extension NibReusable {
    
    static var nib: UINib {
        let bundle = Bundle(for: Self.self)
        return UINib(nibName: Self.identifier, bundle: bundle)
    }
    
}

