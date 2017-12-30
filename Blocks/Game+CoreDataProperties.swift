//
//  Game+CoreDataProperties.swift
//  Blocks
//
//  Created by Volodya on 6/5/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation
import CoreData

extension Game {

    @NSManaged public var firstTetramonio: Int16
    @NSManaged public var bestScore: Int32
    @NSManaged public var score: Int32
    @NSManaged public var secondTetramonio: Int16
    @NSManaged public var cells: NSOrderedSet?

}

// MARK: Generated accessors for cells
extension Game {

    @objc(insertObject:inCellsAtIndex:)
    @NSManaged public func insertIntoCells(_ value: Cell, at idx: Int)

    @objc(removeObjectFromCellsAtIndex:)
    @NSManaged public func removeFromCells(at idx: Int)

    @objc(insertCells:atIndexes:)
    @NSManaged public func insertIntoCells(_ values: [Cell], at indexes: NSIndexSet)

    @objc(removeCellsAtIndexes:)
    @NSManaged public func removeFromCells(at indexes: NSIndexSet)

    @objc(replaceObjectInCellsAtIndex:withObject:)
    @NSManaged public func replaceCells(at idx: Int, with value: Cell)

    @objc(replaceCellsAtIndexes:withCells:)
    @NSManaged public func replaceCells(at indexes: NSIndexSet, with values: [Cell])

    @objc(addCellsObject:)
    @NSManaged public func addToCells(_ value: Cell)

    @objc(removeCellsObject:)
    @NSManaged public func removeFromCells(_ value: Cell)

    @objc(addCells:)
    @NSManaged public func addToCells(_ values: NSOrderedSet)

    @objc(removeCells:)
    @NSManaged public func removeFromCells(_ values: NSOrderedSet)

}
