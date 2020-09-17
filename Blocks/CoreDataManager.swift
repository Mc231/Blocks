//
 //  CoreDataManager.swift
 //  Blocks
 //
 //  Created by Volodya on 5/3/17.
 //  Copyright © 2017 QuasarClaster. All rights reserved.
 //

 import Foundation
 import CoreData

 protocol CoreDataManagerProtocol {
    func create<T: NSManagedObject>(_ object: T.Type) -> T?
    func save<T: NSManagedObject>(_ object: T?)
    func findFirstOrCreate<T: NSManagedObject>(_ object: T.Type, predicate: NSPredicate?) -> T?
    func fetch<T: NSManagedObject>(_ object: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?)
		-> [T]?
    func delete<T: NSManagedObject>(_ object: T)
 }

 /// This class manage working of app with core data
 class CoreDataManager {

    // MARK: - Proeprties

    private let modelName: String

    // MARK: - Inizialization

    init(modelName: String) {
        self.modelName = modelName
    }

    // MARK: - CoreData Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
 }

 // MARK: - CoreDataManagerProtocol

 extension CoreDataManager: CoreDataManagerProtocol {

    func create<T: NSManagedObject>(_ object: T.Type) -> T? {
        guard let entityDescription
                = NSEntityDescription.entity(forEntityName: object.entityName, in: persistentContainer.viewContext) else {
            debugPrint("Failed to create nsmangedobject context")
            return nil
        }
        let object = NSManagedObject(entity: entityDescription, insertInto: persistentContainer.viewContext) as? T
        return object
    }

    func save<T: NSManagedObject>(_ object: T?) {
        persistentContainer.viewContext.perform {
            do {
                try object?.managedObjectContext?.save()
            } catch let error {
                debugPrint("\(self) \(error)")
            }
        }
    }

    func findFirstOrCreate<T: NSManagedObject>(_ object: T.Type, predicate: NSPredicate?) -> T? {
        if let objects = fetch(object, predicate: predicate), !objects.isEmpty {
            debugPrint("\(self) instance fetched")
            return objects.first
        }
        debugPrint("\(self) new instance created")
        return create(object)
    }

	// swiftlint:disable vertical_parameter_alignment
    func fetch<T: NSManagedObject>(_ object: T.Type,
								   predicate: NSPredicate? = nil,
								   sortDescriptors: [NSSortDescriptor]? = nil) -> [T]? {
        let request = NSFetchRequest<T>(entityName: object.entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        do {
           let objects = try persistentContainer.viewContext.fetch(request) as [T]
            return objects
        } catch {
                debugPrint("\(self) \(error)")
        }
        return nil
    }

    func delete<T: NSManagedObject>(_ object: T) {
        persistentContainer.viewContext.delete(object)
    }
 }

 // MARK: - Entity description

 extension NSManagedObject: EntityDescription {

 }
