//
//  PersistenceController.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 8.08.2026.
//

import CoreData
import Foundation

final class PersistenceController {
    // MARK: - Persistent Container
    let container: NSPersistentContainer
    
    //MARK: - View Context
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    init(inMemory: Bool = false) throws {
        container = NSPersistentContainer(name: "LuminaFlow")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        var loadError: Error?
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                loadError = error
            }
        }
        
        if let loadError {
            throw loadError
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    static var preview: PersistenceController {
        do {
            return try PersistenceController(inMemory: true)
        } catch {
            fatalError("In-memory Core Data store failed: \(error)")
        }
    }
    func newBackgroundContext() -> NSManagedObjectContext {
        container.newBackgroundContext()
    }
    
    func save() throws {
        let context = container.viewContext
        guard context.hasChanges else { return }
        try context.save()
    }
}
