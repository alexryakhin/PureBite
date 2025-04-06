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
        guard let id else { return nil }

        return ShoppingListItem(
            id: id,
            isChecked: isChecked,
            groceryProduct: groceryProduct?.coreModel,
            ingredient: ingredient?.coreModel
        )
    }
}
