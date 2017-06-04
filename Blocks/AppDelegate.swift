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
        let manager = CoreDataManager(modelName: "Blocks")
        let a = manager.create(Game.self)
        a?.firstFigure = 11
        a?.secondFigure = 2
        a?.maxScore = 231
        a?.score = 222
        manager.save(a!) { (status, error) in
//            debugPrint(result)
//            debugPrint(status)
//            debugPrint(error)
        }
        
        let result = manager.fetch(Game.self)
        debugPrint(result?.count)
        
        manager.delete(a!)
        
        let sortDesciptor = NSSortDescriptor(key: "score", ascending: true)
        let result2 = manager.fetch(Game.self, sortDescriptors: [sortDesciptor])
        
        for res in result2! {
            debugPrint(res.score)
        }
        return true
    }
}
