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
    func save<T: NSManagedObjectContext>(_ object: T, completion: CoreDataCompletionHandler)
    func update<T: NSManagedObjectContext>(_ object: T, completion: CoreDataCompletionHandler)
    func delete<T: NSManagedObjectContext>(_ object: T, completion: CoreDataCompletionHandler)
    func get<T: NSManagedObjectContext>(_ object: T, completion: CoreDataCompletionHandler)
}

class CoreDataManager {
    
    // MARK: - Constatns
    
    private let kBlocksDataModel = "Blocks"
    private let kBlocksDataModelExtension = "momd"
    
    // MARK: - Proeprties
    
    var managedObjectContext: NSManagedObjectContext
    
    // MARK: - Inizialization
    
    init(completionClosure: @escaping () -> ()) {
        //This resource is the same name as your xcdatamodeld contained in your project
        guard let modelURL = Bundle.main.url(forResource: kBlocksDataModel, withExtension: kBlocksDataModelExtension) else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        
        managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc
        
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        queue.async {
            guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                fatalError("Unable to resolve document directory")
            }
            let storeURL = docURL.appendingPathComponent("DataModel.sqlite")
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
                //The callback block is expected to complete the User Interface and therefore should be presented back on the main queue so that the user interface does not need to be concerned with which queue this call is coming from.
                DispatchQueue.main.sync(execute: completionClosure)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
}

// MARK: - CoreDataManagerPRotocol

extension CoreDataManager: CoreDataManagerProtocol {

    func save<T : NSManagedObjectContext>(_ object: T, completion: @escaping (NSManagedObjectContext?, Bool, Error?) -> Void) {
        object.perform {
            do {
                try object.save()
                completion(object, true, nil)
            } catch let error {
                debugPrint("Failed to save NSManagedObject")
                completion(object, false, error)
            }
        }
    }
    
    func update<T : NSManagedObjectContext>(_ object: T, completion: (NSManagedObjectContext?, Bool, Error?) -> Void) {
        
    }
    
    func delete<T : NSManagedObjectContext>(_ object: T, completion: (NSManagedObjectContext?, Bool, Error?) -> Void) {
        
    }
    
    func get<T : NSManagedObjectContext>(_ object: T, completion: (NSManagedObjectContext?, Bool, Error?) -> Void) {
        
    }
}
