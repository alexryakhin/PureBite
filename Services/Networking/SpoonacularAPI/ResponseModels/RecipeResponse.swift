//
//  Recipe.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation
import Core
import Shared

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
            let length: Length?
        }

        let name: String
        let steps: [Step]
    }

    public struct ExtendedIngredient: Codable {

        public struct Measures: Codable {

            public struct Measurement: Codable {
                public let amount: Double?
                public let unitLong: String?
                public let unitShort: String?

                public init(amount: Double?, unitLong: String?, unitShort: String?) {
                    self.amount = amount
                    self.unitLong = unitLong
                    self.unitShort = unitShort
                }
            }

            public let metric: Measurement?
            public let us: Measurement?

            public init(metric: Measurement?, us: Measurement?) {
                self.metric = metric
                self.us = us
            }
        }

        let aisle: String?
        let amount: Double
        let id: Int
        let name: String
        let unit: String
        let image: String?
        let consistency: String?
        let measures: Measures?
    }

    public struct Nutrition: Codable {
        public struct Nutrient: Codable {
            let amount: Double
            let name: String
            let unit: Unit
            let percentOfDailyNeeds: Double?
        }

        public struct CaloricBreakdown: Codable {
            let percentCarbs: Double
            let percentFat: Double
            let percentProtein: Double
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
    let instructions: String?
    let summary: String
    let cuisines: [Cuisine]
    let diets: [Diet]
    let dishTypes: [MealType]
    let occasions: [Occasion]
    let nutrition: Nutrition?
    let analyzedInstructions: [AnalyzedInstruction]
    let extendedIngredients: [ExtendedIngredient]
    let aggregateLikes: Int
    let cookingMinutes: Double?
    let healthScore: Double
    let preparationMinutes: Double?
    let pricePerServing: Double
    let readyInMinutes: Double
    let servings: Double
    let spoonacularScore: Double
    let cheap: Bool
    let vegan: Bool
    let sustainable: Bool
    let vegetarian: Bool
    let veryHealthy: Bool
    let veryPopular: Bool
    let glutenFree: Bool
    let dairyFree: Bool
}

public extension RecipeResponse.ExtendedIngredient.Measures.Measurement {
    var coreModel: IngredientRecipeInfo.Measures.Measurement {
        .init(amount: amount, unitLong: unitLong, unitShort: unitShort)
    }
}

public extension RecipeResponse.ExtendedIngredient.Measures {
    var coreModel: IngredientRecipeInfo.Measures {
        .init(
            metric: metric?.coreModel,
            us: us?.coreModel
        )
    }
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
                IngredientRecipeInfo(
                    aisle: extendedIngredient.aisle.orEmpty,
                    amount: extendedIngredient.amount,
                    consistency: extendedIngredient.consistency,
                    id: extendedIngredient.id,
                    imageUrlPath: extendedIngredient.image,
                    measures: extendedIngredient.measures?.coreModel,
                    name: extendedIngredient.name,
                    unit: extendedIngredient.unit,
                    recipeID: id,
                    recipeName: title
                )
            },
            macros: Macros(
                proteinPercent: nutrition?.caloricBreakdown.percentProtein ?? .zero,
                carbohydratesPercent: nutrition?.caloricBreakdown.percentCarbs ?? .zero,
                fatPercent: nutrition?.caloricBreakdown.percentFat ?? .zero,
                proteinGrams: .zero,
                carbohydratesGrams: .zero,
                fatGrams: .zero
            ),
            score: spoonacularScore,
            servings: servings,
            likes: aggregateLikes,
            cookingMinutes: cookingMinutes,
            healthScore: healthScore,
            preparationMinutes: preparationMinutes,
            pricePerServing: pricePerServing,
            readyInMinutes: readyInMinutes,
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
