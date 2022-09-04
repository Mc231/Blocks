//
//  Reusable.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 29.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import Foundation

protocol Reusable: AnyObject {
    static var identifier: String { get }
}

// MARK: - Default implementation

extension Reusable {
    static var identifier: String {
        return String(describing: self)
    }
}
