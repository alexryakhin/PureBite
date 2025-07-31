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
              let recipeCoreData = recipe.recipeCoreData,
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
            recipeName: recipeCoreData.title
        )
    }

    var coreModelFromShoppingList: IngredientSearchInfo? {
        guard let name,
              let aisle
        else { 
            return nil 
        }

        return IngredientSearchInfo(
            aisle: aisle,
            id: id.int,
            imageUrlPath: imageUrlPath,
            name: name,
            possibleUnits: _possibleUnits
        )
    }
}
