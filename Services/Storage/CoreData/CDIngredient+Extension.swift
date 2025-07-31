//
//  CDIngredient+Extension.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

import CoreData

extension CDIngredient {

    var _possibleUnits: [String] {
        guard let possibleUnitsData = possibleUnits,
              let units = try? JSONDecoder().decode([String].self, from: possibleUnitsData)
        else { return [] }
        return units
    }

    var coreModelFromRecipe: IngredientRecipeInfo? {
        guard let imageUrlPath,
              let unit,
              let name,
              let aisle,
              let recipe,
              let recipeName = recipe.title,
              let measures
        else { return nil }

        return IngredientRecipeInfo(
            aisle: aisle,
            amount: amount,
            consistency: consistency,
            id: id.int,
            imageUrlPath: imageUrlPath,
            measures: try? JSONDecoder().decode(IngredientRecipeInfo.Measures.self, from: measures),
            name: name,
            unit: unit,
            recipeID: recipe.id.int,
            recipeName: recipeName
        )
    }

    var coreModelFromShoppingList: IngredientSearchInfo? {
        guard let imageUrlPath,
              let name,
              let aisle
        else { return nil }

        return IngredientSearchInfo(
            aisle: aisle,
            id: id.int,
            imageUrlPath: imageUrlPath,
            name: name,
            possibleUnits: [],
        )
    }
}
