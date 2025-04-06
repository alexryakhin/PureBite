//
//  ShoppingListItem.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation

public struct ShoppingListItem: Identifiable {
    public let id: String
    public let isChecked: Bool
    public let groceryProduct: GroceryProduct?
    public let ingredient: Ingredient?

    public var name: String? {
        groceryProduct?.name ?? ingredient?.name
    }

    public init(
        id: String,
        isChecked: Bool,
        groceryProduct: GroceryProduct?,
        ingredient: Ingredient?
    ) {
        self.id = id
        self.isChecked = isChecked
        self.groceryProduct = groceryProduct
        self.ingredient = ingredient
    }
}
