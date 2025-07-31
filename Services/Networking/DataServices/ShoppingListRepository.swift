//
//  ShoppingListSearchRepository.swift
//  PureBite
//  Class for getting shopping list items from core data.
//
//  Created by Aleksandr Riakhin on 4/27/25.
//

import Foundation
import Combine

@MainActor
public final class ShoppingListRepository: ObservableObject {
    public static let shared = ShoppingListRepository()
    
    @Published public private(set) var shoppingListItems: [ShoppingListItem] = []
    @Published public private(set) var error: Error?
    
    public let errorPublisher = PassthroughSubject<Error, Never>()
    public var cancellables = Set<AnyCancellable>()
    
    private let coreDataService: CoreDataService
    
    private init() {
        self.coreDataService = CoreDataService.shared
        setupBindings()
        fetchAllItems()
    }
    
    public func addIngredient(_ ingredient: IngredientSearchInfo, unit: String, amount: Double) {
        let newCDIngredient = CDIngredient(context: coreDataService.context)
        newCDIngredient.aisle = ingredient.aisle
        newCDIngredient.amount = amount
        newCDIngredient.id = ingredient.id.int64
        newCDIngredient.imageUrlPath = ingredient.imageUrlPath
        newCDIngredient.name = ingredient.name
        newCDIngredient.unit = unit

        let newShoppingListItem = CDShoppingListItem(context: coreDataService.context)
        newShoppingListItem.id = UUID().uuidString
        newShoppingListItem.dateSaved = .now
        newShoppingListItem.amount = amount
        newShoppingListItem.unit = unit
        newShoppingListItem.ingredient = newCDIngredient

        newCDIngredient.shoppingListItem = newShoppingListItem

        save()
    }

    public func toggleCheck(_ id: String) {
        let context = coreDataService.context
        let fetchRequest = CDShoppingListItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            if let cdShoppingListItem = try context.fetch(fetchRequest).first {
                cdShoppingListItem.isChecked.toggle()
            }
        } catch {
            self.error = CoreError.storageError(.readFailed)
            errorPublisher.send(CoreError.storageError(.readFailed))
        }
        save()
    }

    public func removeItem(_ id: String) {
        let context = coreDataService.context
        let fetchRequest = CDShoppingListItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            if let cdShoppingListItem = try context.fetch(fetchRequest).first {
                context.delete(cdShoppingListItem)
            }
        } catch {
            self.error = CoreError.storageError(.deleteFailed)
            errorPublisher.send(CoreError.storageError(.deleteFailed))
        }
        save()
    }
    
    private func save() {
        do {
            try coreDataService.saveContext()
        } catch {
            self.error = error
            errorPublisher.send(error)
        }
    }

    private func setupBindings() {
        coreDataService.dataUpdatedPublisher
            .sink { [weak self] _ in
                self?.fetchAllItems()
            }
            .store(in: &cancellables)
    }

    private func fetchAllItems() {
        let context = coreDataService.context
        let fetchRequest = CDShoppingListItem.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateSaved", ascending: false)]

        do {
            let results = try context.fetch(fetchRequest)
            let returnValue = results.compactMap(\.coreModel)
            shoppingListItems = returnValue
        } catch {
            self.error = CoreError.storageError(.readFailed)
            errorPublisher.send(CoreError.storageError(.readFailed))
        }
    }
}
