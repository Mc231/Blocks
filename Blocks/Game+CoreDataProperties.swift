//
//  Game+CoreDataProperties.swift
//  Blocks
//
//  Created by Volodya on 6/4/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation
import CoreData


extension Game {

    @NSManaged public var firstFigure: Int16
    @NSManaged public var maxScore: Int32
    @NSManaged public var score: Int32
    @NSManaged public var secondFigure: Int16
    @NSManaged public var cells: NSSet?

}

// MARK: Generated accessors for cells
extension Game {

    @objc(addCellsObject:)
    @NSManaged public func addToCells(_ value: Cell)

    @objc(removeCellsObject:)
    @NSManaged public func removeFromCells(_ value: Cell)

    @objc(addCells:)
    @NSManaged public func addToCells(_ values: NSSet)

    @objc(removeCells:)
    @NSManaged public func removeFromCells(_ values: NSSet)

}
