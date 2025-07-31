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
final class ShoppingListRepository: ObservableObject {
    static let shared = ShoppingListRepository()
    
    @Published private(set) var shoppingListItems: [ShoppingListItem] = []
    @Published private(set) var error: Error?
    
    let errorPublisher = PassthroughSubject<Error, Never>()
    var cancellables = Set<AnyCancellable>()
    
    private let coreDataService: CoreDataService
    
    private init() {
        self.coreDataService = CoreDataService.shared
        setupBindings()
        fetchAllItems()
    }
    
    func addIngredient(
        _ ingredient: IngredientSearchInfo,
        unit: String,
        amount: Double,
        category: ShoppingCategory = .uncategorized,
        notes: String? = nil,
        priority: ShoppingPriority = .normal
    ) {
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
        newShoppingListItem.category = category.rawValue
        newShoppingListItem.notes = notes
        newShoppingListItem.priority = priority.rawValue
        newShoppingListItem.isInCart = false
        newShoppingListItem.isChecked = false
        newShoppingListItem.ingredient = newCDIngredient

        newCDIngredient.shoppingListItem = newShoppingListItem

        save()
    }

    func toggleCheck(_ id: String) {
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
    
    func updateItem(
        id: String,
        amount: Double? = nil,
        unit: String? = nil,
        category: ShoppingCategory? = nil,
        notes: String? = nil,
        priority: ShoppingPriority? = nil
    ) {
        let context = coreDataService.context
        let fetchRequest = CDShoppingListItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            if let cdShoppingListItem = try context.fetch(fetchRequest).first {
                if let amount = amount {
                    cdShoppingListItem.amount = amount
                }
                if let unit = unit {
                    cdShoppingListItem.unit = unit
                }
                if let category = category {
                    cdShoppingListItem.category = category.rawValue
                }
                if let notes = notes {
                    cdShoppingListItem.notes = notes
                }
                if let priority = priority {
                    cdShoppingListItem.priority = priority.rawValue
                }
            }
        } catch {
            self.error = CoreError.storageError(.readFailed)
            errorPublisher.send(CoreError.storageError(.readFailed))
        }
        save()
    }

    func removeItem(_ id: String) {
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
    
    func clearCheckedItems() {
        let context = coreDataService.context
        let fetchRequest = CDShoppingListItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isChecked == YES")

        do {
            let checkedItems = try context.fetch(fetchRequest)
            checkedItems.forEach { context.delete($0) }
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
