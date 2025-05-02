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

    func addGroceryProduct(_ product: GroceryProduct)
    func addIngredient(_ ingredient: Ingredient)
    func removeItem(_ id: String)
}

public final class ShoppingListRepository: ShoppingListRepositoryInterface {

    public let shoppingListItemsPublisher = CurrentValueSubject<[ShoppingListItem], Never>([])
    public let errorPublisher = PassthroughSubject<Error, Never>()

    private let coreDataService: CoreDataServiceInterface

    public init(
        coreDataService: CoreDataServiceInterface
    ) {
        self.coreDataService = coreDataService
    }

    public func addGroceryProduct(_ product: GroceryProduct) {

    }

    public func addIngredient(_ ingredient: Ingredient) {

    }

    public func removeItem(_ id: String) {
        
    }
}
