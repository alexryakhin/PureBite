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
            imageExtension: imageExtension,
            badges: badges.toGroceryProductBadges,
            importantBadges: importantBadges.toGroceryProductBadges,
            ingredientCount: ingredientCount,
            ingredientList: ingredientList,
            aisle: aisle,
            price: price,
            servingsNumber: servingsNumber,
            servingSize: servingSize,
            servingUnit: servingUnit
        )
    }
}
