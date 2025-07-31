//
//  ShoppingListItem.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation

struct ShoppingListItem: Identifiable, Hashable {
    let id: String
    let unit: String
    let amount: Double
    let dateSaved: Date
    let ingredient: IngredientSearchInfo
    let isChecked: Bool

    var imageURL: URL? {
        ingredient.imageURL
    }

    init(
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
