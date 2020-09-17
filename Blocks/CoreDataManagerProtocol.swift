//
//  CoreDataManagerProtocol.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 17.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import Foundation

import CoreData

protocol CoreDataManagerProtocol {
   func create<T: NSManagedObject>(_ object: T.Type) -> T?
   func save<T: NSManagedObject>(_ object: T?)
   func findFirstOrCreate<T: NSManagedObject>(_ object: T.Type, predicate: NSPredicate?)  -> T?
   func fetch<T: NSManagedObject>(_ object: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?)
	   -> [T]
   func delete<T: NSManagedObject>(_ object: T)
}
