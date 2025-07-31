//
//  CDShoppingListItem+Extension.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

import CoreData

extension CDShoppingListItem {

    var coreModel: ShoppingListItem? {
        guard let id, let dateSaved, let unit, let ingredient = ingredient?.coreModelFromShoppingList else { 
            return nil 
        }
        
        let category = ShoppingCategory(rawValue: category ?? "Uncategorized") ?? .uncategorized
        let priority = ShoppingPriority(rawValue: priority ?? "Normal") ?? .normal

        return ShoppingListItem(
            id: id,
            isChecked: isChecked,
            dateSaved: dateSaved,
            amount: amount,
            unit: unit,
            ingredient: ingredient,
            category: category,
            notes: notes,
            priority: priority,
            isInCart: isInCart
        )
    }
}
