//
//  ShoppingListItem.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation

public struct ShoppingListItem: Identifiable, Hashable {
    public let id: String
    public let unit: String
    public let amount: Double
    public let dateSaved: Date
    public let ingredient: IngredientSearchInfo
    public let isChecked: Bool

    public var imageURL: URL? {
        ingredient.imageURL
    }

    public init(
        id: String,
        isChecked: Bool,
        dateSaved: Date,
        amount: Double,
        unit: String,
        ingredient: IngredientSearchInfo
    ) {
        self.id = id
        self.isChecked = isChecked
        self.dateSaved = dateSaved
        self.amount = amount
        self.unit = unit
        self.ingredient = ingredient
    }
}
