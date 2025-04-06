//
//  CoreDataService.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 8/25/24.
//

import CoreData
import Core
import Combine

public protocol CoreDataServiceInterface {
    var dataUpdatedPublisher: PassthroughSubject<Void, Never> { get }

    var context: NSManagedObjectContext { get }
    func saveContext() throws(CoreError)
}

public class CoreDataService: CoreDataServiceInterface {

    public let dataUpdatedPublisher = PassthroughSubject<Void, Never>()

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PureBite")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    public var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private var cancellables: Set<AnyCancellable> = []

    public init() {
        setupBindings()
    }

    public func saveContext() throws(CoreError) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw .storageError(.saveFailed)
            }
        }
    }

    private func setupBindings() {
        NotificationCenter.default.eventChangedPublisher
            .combineLatest(NotificationCenter.default.coreDataDidSaveObjectIDsPublisher)
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.dataUpdatedPublisher.send()
            }
            .store(in: &cancellables)
    }
}
