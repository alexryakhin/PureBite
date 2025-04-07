//
//  Recipe.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation
import Core

// MARK: - Recipe

public struct RecipeResponse: Codable {

    public struct AnalyzedInstruction: Codable {
        public struct Step: Codable {
            public struct StepItem: Codable {
                let id: Int
                let image: String
                let localizedName: String
                let name: String
            }

            public struct Length: Codable {
                let number: Int
                let unit: String
            }

            let equipment, ingredients: [StepItem]
            let number: Int
            let step: String
            let length: Length
        }

        let name: String
        let steps: [Step]
    }

    public struct ExtendedIngredient: Codable {
        let aisle: String
        let amount: Decimal
        let id: Int
        let name: String
        let unit: String
        let image: String
    }

    public struct Nutrition: Codable {
        public struct Nutrient: Codable {
            let amount: Decimal
            let name: String
            let unit: Unit
            let percentOfDailyNeeds: Decimal
        }

        public struct CaloricBreakdown: Codable {
            let percentCarbs: Decimal
            let percentFat: Decimal
            let percentProtein: Decimal
        }

        public enum Unit: String, Codable {
            case empty = ""
            case g = "g"
            case iu = "IU"
            case kcal = "kcal"
            case mg = "mg"
            case percent = "%"
            case µg = "µg"
        }

        public struct WeightPerServing: Codable {
            let amount: Int
            let unit: Unit
        }

        let caloricBreakdown: CaloricBreakdown
        let nutrients: [Nutrient]
        let properties: [Nutrient]
        let weightPerServing: WeightPerServing
    }

    let id: Int
    let title: String
    let instructions: String
    let summary: String
    let cuisines: [Cuisine]
    let diets: [Diet]
    let dishTypes: [MealType]
    let occasions: [Occasion]
    let nutrition: Nutrition?
    let analyzedInstructions: [AnalyzedInstruction]
    let extendedIngredients: [ExtendedIngredient]
    let aggregateLikes: Int
    let cookingMinutes: Decimal?
    let healthScore: Decimal
    let preparationMinutes: Decimal
    let pricePerServing: Decimal
    let readyInMinutes: Decimal
    let servings: Decimal
    let spoonacularScore: Decimal
    let cheap: Bool
    let vegan: Bool
    let sustainable: Bool
    let vegetarian: Bool
    let veryHealthy: Bool
    let veryPopular: Bool
    let glutenFree: Bool
    let dairyFree: Bool
}

public extension RecipeResponse {
    var coreModel: Core.Recipe {
        .init(
            id: id,
            title: title,
            summary: summary,
            instructions: instructions,
            dateSaved: nil,
            cuisines: cuisines,
            diets: diets,
            mealTypes: dishTypes,
            occasions: occasions,
            ingredients: extendedIngredients.map { extendedIngredient in
                Ingredient(
                    id: extendedIngredient.id,
                    amount: extendedIngredient.amount.double,
                    imageUrlPath: extendedIngredient.image,
                    unit: extendedIngredient.unit,
                    name: extendedIngredient.name,
                    aisle: extendedIngredient.aisle
                )
            },
            macros: Macros(
                protein: nutrition?.caloricBreakdown.percentProtein.double ?? .zero,
                carbohydrates: nutrition?.caloricBreakdown.percentCarbs.double ?? .zero,
                fat: nutrition?.caloricBreakdown.percentFat.double ?? .zero
            ),
            score: spoonacularScore.double,
            servings: servings.int,
            likes: aggregateLikes,
            cookingMinutes: cookingMinutes?.int,
            healthScore: healthScore.int,
            preparationMinutes: preparationMinutes.int,
            pricePerServing: pricePerServing.double,
            readyInMinutes: readyInMinutes.int,
            isCheap: cheap,
            isVegan: vegan,
            isSustainable: sustainable,
            isVegetarian: vegetarian,
            isVeryHealthy: veryHealthy,
            isVeryPopular: veryPopular,
            isGlutenFree: glutenFree,
            isDairyFree: dairyFree
        )
    }
}
