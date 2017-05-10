//
//  CoreDataManager.swift
//  Blocks
//
//  Created by Volodya on 5/3/17.
//  Copyright © 2017 QuasarClaster. All rights reserved.
//

import Foundation
import CoreData

typealias CoreDataCompletionHandler = (_ object: NSManagedObjectContext? ,_ success: Bool, _ error: Error?) -> Void

protocol CoreDataManagerProtocol {
    func save<T: NSManagedObject>(_ object: T, completion: @escaping CoreDataCompletionHandler)
    func update<T: NSManagedObject>(_ object: T, completion: CoreDataCompletionHandler)
    func delete<T: NSManagedObject>(_ object: T, completion: CoreDataCompletionHandler)
    func get<T: NSManagedObject>(_ object: T, completion: CoreDataCompletionHandler)
}

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
    
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
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
