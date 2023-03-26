//
//  CoreDataManagerMock.swift
//  BlocksTests
//
//  Created by Volodymyr Shyrochuk on 26.03.2023.
//  Copyright © 2023 QuasarClaster. All rights reserved.
//

import CoreData
@testable import Blocks

class CoreDataManageMock: CoreDataManagerProtocol {
	
	var storedObjects: [NSManagedObject] = []
	private var context: NSManagedObjectContext
	
	init(context: NSManagedObjectContext) {
		self.context = context
	}
	
	var saveSuccess = false
	var deleteSuccess = false
	
	func create<T>(_ object: T.Type) -> T? where T : NSManagedObject {
		if object == Game.self {
			return Game(context: context) as? T
		}
		if object == Cell.self {
			return Cell(context: context) as? T
		}
		if object == Statistic.self {
			return Statistic(context: context)  as? T
		}
		return nil
	}
	
	func save<T>(_ object: T?) where T : NSManagedObject {
		if let object = object {
			storedObjects.append(object)
			saveSuccess.toggle()
		}
	}
	
	func findFirstOrCreate<T>(_ object: T.Type, predicate: NSPredicate?) -> T? where T : NSManagedObject {
		return create(object)
	}
	
	func fetch<T>(_ object: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [T] where T : NSManagedObject {
		return storedObjects.filter { (storedObject) -> Bool in
			return type(of: storedObject) == object
		} as! [T]
	}
	
	func delete<T>(_ object: T) where T : NSManagedObject {
		if let index = storedObjects.firstIndex(of: object) {
			storedObjects.remove(at: index)
			deleteSuccess.toggle()
		}
	}
}
