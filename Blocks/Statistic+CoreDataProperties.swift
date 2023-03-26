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

    @NSManaged public var allTimeTotalScore: Int64
    @NSManaged public var bestScore: Int64
    @NSManaged public var gamesRestarted: Int64
    @NSManaged public var linesWiped: Int64
    @NSManaged public var placedTetramonios: Int64
    @NSManaged public var playedGames: Int64

}
