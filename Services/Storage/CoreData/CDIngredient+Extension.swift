//
//  CDIngredient+Extension.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

import Core
import CoreData

extension CDIngredient {

    var _recipes: [CDRecipe] {
        let sets = recipes as? Set<CDRecipe> ?? []
        return sets.sorted {
            $0.dateSaved ?? .now < $1.dateSaved ?? .now
        }
    }

    var coreModel: Ingredient? {
        guard let imageUrlPath,
              let unit,
              let name,
              let aisle
        else { return nil }

        return Ingredient(
            id: id.int,
            amount: amount,
            imageUrlPath: imageUrlPath,
            unit: unit,
            name: name,
            aisle: aisle
        )
    }
}
