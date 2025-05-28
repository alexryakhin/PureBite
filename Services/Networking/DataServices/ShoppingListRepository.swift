//
//  ShoppingListSearchRepository.swift
//  PureBite
//  Class for getting shopping list items from core data.
//
//  Created by Aleksandr Riakhin on 4/27/25.
//

import Foundation
import Core
import Combine
import Shared

public protocol ShoppingListRepositoryInterface {
    var shoppingListItemsPublisher: CurrentValueSubject<[ShoppingListItem], Never> { get }
    var errorPublisher: PassthroughSubject<Error, Never> { get }

    func addIngredient(_ ingredient: IngredientSearchInfo, unit: String, amount: Double)
    func toggleCheck(_ id: String)
    func removeItem(_ id: String)
}

public final class ShoppingListRepository: ShoppingListRepositoryInterface {

    public let shoppingListItemsPublisher = CurrentValueSubject<[ShoppingListItem], Never>([])
    public let errorPublisher = PassthroughSubject<Error, Never>()
    public var cancellables = Set<AnyCancellable>()

    private let coreDataService: CoreDataServiceInterface

    public init(
        coreDataService: CoreDataServiceInterface
    ) {
        self.coreDataService = coreDataService
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
            errorPublisher.send(CoreError.storageError(.deleteFailed))
        }
        save()
    }
    
    private func save() {
        do {
            try coreDataService.saveContext()
        } catch {
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
            shoppingListItemsPublisher.send(returnValue)
        } catch {
            errorPublisher.send(CoreError.storageError(.readFailed))
        }
    }
}
