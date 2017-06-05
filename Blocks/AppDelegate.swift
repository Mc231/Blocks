//
//  AppDelegate.swift
//  Blocks
//
//  Created by Volodya on 2/3/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        let manager = CoreDataManager(modelName: "Blocks")
//        let a = manager.findFirstOrCreate(Game.self, predicate: nil)
//        a?.bestScore = 252555
//        debugPrint(a?.bestScore)
//        manager.save(a, completion: nil)
//        let b = manager.fetch(Game.self)
//        debugPrint(b?.count)
        
//        debugPrint(a?.cells?.count)
////        let cell = manager.create(Cell.self)
////        a?.addToCells(cell!)
////        manager.save(a!) { (result, error) in
////            debugPrint(result)
////            debugPrint(error)
////        }
//        debugPrint(a?.cells?.count)
        return true
    }
}
