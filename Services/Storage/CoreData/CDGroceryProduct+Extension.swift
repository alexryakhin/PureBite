//
//  CDGroceryProduct+Extension.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

import Core
import CoreData

extension CDGroceryProduct {

    var coreModel: GroceryProduct? {
        guard let name,
              let badges,
              let importantBadges,
              let ingredientList,
              let aisle,
              let servingUnit
        else { return nil }

        return GroceryProduct(
            id: id.int,
            name: name,
            badges: badges.toGroceryProductBadges,
            importantBadges: importantBadges.toGroceryProductBadges,
            ingredientCount: ingredientCount.int,
            ingredientList: ingredientList,
            aisle: aisle,
            price: price,
            servingsNumber: servingsNumber.int,
            servingSize: servingSize.int,
            servingUnit: servingUnit
        )
    }
}
