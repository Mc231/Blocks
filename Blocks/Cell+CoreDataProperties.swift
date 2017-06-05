//
//  Cell+CoreDataProperties.swift
//  Blocks
//
//  Created by Volodya on 6/4/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation
import CoreData


extension Cell {

    @NSManaged public var x: Int16
    @NSManaged public var y: Int16
    @NSManaged public var state: Int16
    @NSManaged public var game: Game?

}
