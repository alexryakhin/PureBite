//
//  CDShoppingListItem+Extension.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

import Core
import CoreData

extension CDShoppingListItem {

    var coreModel: ShoppingListItem? {
        guard let id, let dateSaved, let unit, let ingredient = ingredient?.coreModelFromShoppingList else { return nil }

        return ShoppingListItem(
            id: id,
            isChecked: isChecked,
            dateSaved: dateSaved,
            amount: amount,
            unit: unit,
            ingredient: ingredient
        )
    }
}
