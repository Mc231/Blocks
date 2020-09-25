//
 //  CoreDataManager.swift
 //  Blocks
 //
 //  Created by Volodya on 5/3/17.
 //  Copyright © 2017 QuasarClaster. All rights reserved.
 //

 import Foundation
 import CoreData

 /// This class manage working of app with core data
 class CoreDataManager {
    
    // MARK: - Proeprties

    private let modelName: String
	
	// MARK: - CoreData Stack
	
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: modelName)
		container.loadPersistentStores { (description, error) in
			print(description)
			print(error as Any)
		}
		return container
	}()
	
	private lazy var context = {
		return persistentContainer.viewContext
	}()

    // MARK: - Inizialization

    init(modelName: String) {
        self.modelName = modelName
    }
 }

 // MARK: - CoreDataManagerProtocol

 extension CoreDataManager: CoreDataManagerProtocol {

    func create<T: NSManagedObject>(_ object: T.Type) -> T? {
        let object = NSEntityDescription.insertNewObject(forEntityName: object.entityName,
                                                         into: context)
        return object as? T
    }

    func save<T: NSManagedObject>(_ object: T?) {
        context.perform {
			try? object?.managedObjectContext?.save()
        }
    }

    func findFirstOrCreate<T: NSManagedObject>(_ object: T.Type, predicate: NSPredicate?) -> T? {
        let objects = fetch(object, predicate: predicate)
        return !objects.isEmpty ? objects.first : create(object)
    }

	// swiftlint:disable vertical_parameter_alignment
    func fetch<T: NSManagedObject>(_ object: T.Type,
								   predicate: NSPredicate? = nil,
								   sortDescriptors: [NSSortDescriptor]? = nil) -> [T] {
        let request = NSFetchRequest<T>(entityName: object.entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
		let objects = try! context.fetch(request) as [T]
		return objects
    }

    func delete<T: NSManagedObject>(_ object: T) {
        context.delete(object)
    }
 }

 // MARK: - Entity description

 extension NSManagedObject: EntityDescription {

 }
