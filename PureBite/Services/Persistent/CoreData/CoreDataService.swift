//
//  CoreDataService.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 8/25/24.
//

import CoreData

public protocol CoreDataServiceInterface {
    var context: NSManagedObjectContext { get }
    func saveContext() throws
}

public class CoreDataService: CoreDataServiceInterface {
    public static let shared: CoreDataServiceInterface = CoreDataService()

    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CDDataModel")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    public var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    public func saveContext() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                throw DefaultError.coreDataError("Error saving data to the storage, \(error.localizedDescription)")
            }
        }
    }
}
