//
//  CoredDataManagerTest.swift
//  Blocks
//
//  Created by Volodya on 5/10/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import XCTest
@testable import Blocks

class CoredDataManagerTest: XCTestCase {
    
    func testCoreDataManager() {
        let data = CoreDataManager(modelName: "Blocks")
        debugPrint(data.managedObjectContext)
    }
}
