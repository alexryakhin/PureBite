//
//  CoreDataService.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 8/25/24.
//

import CoreData
import Combine

@MainActor
public final class CoreDataService: ObservableObject {
    public static let shared = CoreDataService()
    
    @Published public private(set) var isDataUpdated = false
    
    public let dataUpdatedPublisher = PassthroughSubject<Void, Never>()
    
    private init() {
        setup()
    }
    
    public var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    public func saveContext() throws {
        if context.hasChanges {
            try context.save()
            dataUpdatedPublisher.send()
            isDataUpdated.toggle()
        }
    }
    
    // MARK: - Core Data stack
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PureBite")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    private func setup() {
        // Any additional setup if needed
    }
}
