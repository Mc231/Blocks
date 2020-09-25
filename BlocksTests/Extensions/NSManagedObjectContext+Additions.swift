//
//  NSManagedObjectContext+Additions.swift
//  BlocksTests
//
//  Created by Volodymyr Shyrochuk on 25.09.2020.
//  Copyright © 2020 QuasarClaster. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
	
	class var contextForTests: NSManagedObjectContext {
		// Get the model
		let model = NSManagedObjectModel.mergedModel(from: Bundle.allBundles)!
		
		// Create and configure the coordinator
		let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
		try! coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
		
		// Setup the context
		let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		context.persistentStoreCoordinator = coordinator
		return context
	}
	
}
