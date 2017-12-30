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
    func fetch<T: NSManagedObject>(_ object: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [T]?
    func delete<T: NSManagedObject>(_ object: T)
 }
 
 /// This class manage working of app with core data
 class CoreDataManager {
    
    // MARK: - Constatns
    
    private let kBlocksDataModelExtension = "momd"
    private let kSqliteExtensionWithDot = ".sqlite"
    
    // MARK: - Proeprties
    
    private let modelName: String
    
    // MARK: - Inizialization
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    // MARK: - CoreData Stack
    
    fileprivate lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: self.kBlocksDataModelExtension) else {
            fatalError("Unable to find Data model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to load data model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let fileManager = FileManager.default
        let storeName = self.modelName + self.kSqliteExtensionWithDot
        
        guard let documentDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Failed to find document directory")
        }
        
        let persistentStoreURL = documentDirectoryURL.appendingPathComponent(storeName)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL)
        } catch  {
            fatalError("Failed to load persistent store")
        }
        
        return persistentStoreCoordinator
        
    }()
 }
 
 // MARK: - CoreDataManagerProtocol
 
 extension CoreDataManager: CoreDataManagerProtocol {

    func create<T : NSManagedObject>(_ object: T.Type) -> T? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: object.entityName, in: managedObjectContext) else {
            debugPrint("Failed to create nsmangedobject context")
            return nil
        }
        let object = NSManagedObject(entity: entityDescription, insertInto: managedObjectContext) as? T
        return object
    }
    
    func save<T : NSManagedObject>(_ object: T?) {
        managedObjectContext.perform {
            do {
                try object?.managedObjectContext?.save()
            } catch let error {
                debugPrint("\(self) \(error)")
            }
        }
    }
    
    func findFirstOrCreate<T : NSManagedObject>(_ object: T.Type, predicate: NSPredicate?) -> T? {
        if let objects = fetch(object, predicate: predicate), !objects.isEmpty {
            debugPrint("\(self) instance fetched")
            return objects.first
        }
        debugPrint("\(self) new instance created")
        return create(object)
    }
    
    func fetch<T : NSManagedObject>(_ object: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [T]? {
        let request = NSFetchRequest<T>(entityName: object.entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        do {
           let objects = try managedObjectContext.fetch(request) as [T] 
            return objects
        } catch {
                debugPrint("\(self) \(error)")
        }
        return nil
    }
    
    func delete<T : NSManagedObject>(_ object: T) {
        managedObjectContext.delete(object)
    }
 }
 
 // MARK: - Entity description
 
 extension NSManagedObject: EntityDescription {
    
 }
