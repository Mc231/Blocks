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
    func findFirstOrCreate<T: NSManagedObject>(_ object: T.Type, predicate: NSPredicate?)  -> T?
    func fetch<T: NSManagedObject>(_ object: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?)
		-> [T]
    func delete<T: NSManagedObject>(_ object: T)
 }

protocol CoreDataManagerDelegate: class {
    func coreDataManager(_ manager: CoreDataManager, didLoadPresistentContainerWithResult result: Result<NSPersistentStoreDescription, Error>)
    func coreDataManager(_ manager: CoreDataManager, didProduceError error: Error)
}

 /// This class manage working of app with core data
 class CoreDataManager {
    
    // MARK: - Proeprties

    private let modelName: String
    private weak var delegate: CoreDataManagerDelegate?

    // MARK: - Inizialization

    init(modelName: String, delegate: CoreDataManagerDelegate? = nil) {
        self.modelName = modelName
        self.delegate = delegate
    }

    // MARK: - CoreData Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: handlePersistanceStoreLoad(description:error:))
        return container
    }()
    
    private func handlePersistanceStoreLoad(description: NSPersistentStoreDescription, error: Error?) {
        var result: Result<NSPersistentStoreDescription, Error>!
        if let error = error {
            result = .failure(error)
        }else{
            result = .success(description)
        }
        delegate?.coreDataManager(self, didLoadPresistentContainerWithResult: result)
    }
 }

 // MARK: - CoreDataManagerProtocol

 extension CoreDataManager: CoreDataManagerProtocol {

    func create<T: NSManagedObject>(_ object: T.Type) -> T? {
        let object = NSEntityDescription.insertNewObject(forEntityName: object.entityName,
                                                         into: persistentContainer.viewContext)
        return object as? T
    }

    func save<T: NSManagedObject>(_ object: T?) {
        persistentContainer.viewContext.perform {
            do {
                try object?.managedObjectContext?.save()
            }catch{
                print(error)
                self.delegate?.coreDataManager(self, didProduceError: error)
            }
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
        do {
            let objects = try persistentContainer.viewContext.fetch(request) as [T]
            return objects
        }catch{
            print(error)
            delegate?.coreDataManager(self, didProduceError: error)
        }
        return []
    }

    func delete<T: NSManagedObject>(_ object: T) {
        persistentContainer.viewContext.delete(object)
    }
 }

 // MARK: - Entity description

 extension NSManagedObject: EntityDescription {

 }
