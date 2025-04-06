//
//  CDRecipe+Extension.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

import Core
import CoreData
import Shared

extension CDRecipe {

    var _ingredients: [CDIngredient] {
        let sets = ingredients as? Set<CDIngredient> ?? []
        return sets.sorted {
            $0.name ?? .empty < $1.name ?? .empty
        }
    }

    var coreModel: Recipe? {
        guard let title,
              let summary,
              let instructions,
              let cuisines,
              let diets,
              let mealTypes,
              let occasions
        else { return nil }

        return Recipe(
            id: id.int,
            title: title,
            summary: summary,
            instructions: instructions,
            dateSaved: dateSaved,
            cuisines: cuisines.toCuisines,
            diets: diets.toDiets,
            mealTypes: mealTypes.toMealTypes,
            occasions: occasions.toOccasions,
            ingredients: _ingredients.compactMap(\.coreModel),
            score: score,
            servings: servings.int,
            likes: likes.int,
            cookingMinutes: cookingMinutes.int,
            healthScore: healthScore.int,
            preparationMinutes: preparationMinutes.int,
            pricePerServing: pricePerServing,
            readyInMinutes: readyInMinutes.int,
            isCheap: isCheap,
            isVegan: isVegan,
            isSustainable: isSustainable,
            isVegetarian: isVegetarian,
            isVeryHealthy: isVeryHealthy,
            isVeryPopular: isVeryPopular,
            isGlutenFree: isGlutenFree,
            isDairyFree: isDairyFree
        )
    }
}
