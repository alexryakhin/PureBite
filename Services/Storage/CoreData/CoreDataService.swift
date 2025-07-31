//
//  CoreDataService.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 8/25/24.
//

import CoreData
import Combine

@MainActor
final class CoreDataService: ObservableObject {
    static let shared = CoreDataService()
    
    @Published private(set) var isDataUpdated = false
    
    let dataUpdatedPublisher = PassthroughSubject<Void, Never>()
    
    private init() {
        setup()
    }
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() throws {
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
