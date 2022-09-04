//
//  ResourceLoadable.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 02.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import Foundation

protocol ResourceLoadable: AnyObject {
    /**
     Loads resource
     - parameter resource: Name of resource
     - parameter type: Type of resource
     - Returns: Data representation of resource
     */
    func load(resource named: String, type: String) throws -> Data 
}
