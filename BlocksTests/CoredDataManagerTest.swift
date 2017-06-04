//
//  CoredDataManagerTest.swift
//  Blocks
//
//  Created by Volodya on 5/10/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import XCTest
import CoreData

@testable import Blocks

class CoredDataManagerTest: XCTestCase {
    
    func testCoreDataManager() {
        let manager = CoreDataManager(modelName: "Blocks")
        debugPrint(manager.managedObjectContext)
        
        if let game = manager.create(Game.self) {
            game.firstFigure = 12
            game.maxScore = 231
            game.score = 100
            game.secondFigure = 121
            
            manager.save(game, completion: { (object, success, error) in
                debugPrint(object)
                debugPrint(success)
                debugPrint(error)
            })
        }
    }
}
