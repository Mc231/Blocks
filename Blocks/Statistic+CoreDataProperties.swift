//
//  Statistic+CoreDataProperties.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 26.03.2023.
//  Copyright © 2023 QuasarClaster. All rights reserved.
//
//

import Foundation
import CoreData


extension Statistic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Statistic> {
        return NSFetchRequest<Statistic>(entityName: "Statistic")
    }

    @NSManaged public var allTimeTotalScore: Int64
    @NSManaged public var bestScore: Int64
    @NSManaged public var linesWiped: Int64
    @NSManaged public var placedTetramonios: Int64
    @NSManaged public var playedGames: Int64
    @NSManaged public var tetramonioDragged: Int64
    @NSManaged public var tetramonioDrawned: Int64
	@NSManaged public var gamesRestarted: Int64
}
