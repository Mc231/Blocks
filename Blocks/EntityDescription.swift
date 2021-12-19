//
//  EntityDescription.swift
//  Blocks
//
//  Created by Volodya on 10/15/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation

protocol EntityDescription: AnyObject {
    static var entityName: String {get}
}

extension EntityDescription {
    static var entityName: String {
        return String(describing: self)
    }
}
