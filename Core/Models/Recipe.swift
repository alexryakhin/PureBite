//
//  Recipe.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

import Foundation

struct Recipe: Identifiable, Hashable, Codable {
    let id: Int
    let title: String
    let summary: String
    let instructions: String?
    let dateSaved: Date?
    let cuisines: [Cuisine]
    let diets: [Diet]
    let mealTypes: [MealType]
    let occasions: [Occasion]
    let ingredients: [IngredientRecipeInfo]
    let macros: Macros
    let score: Double
    let servings: Double
    let likes: Int
    let cookingMinutes: Double?
    let healthScore: Double
    let preparationMinutes: Double?
    let pricePerServing: Double
    let readyInMinutes: Double
    let isCheap: Bool
    let isVegan: Bool
    let isSustainable: Bool
    let isVegetarian: Bool
    let isVeryHealthy: Bool
    let isVeryPopular: Bool
    let isGlutenFree: Bool
    let isDairyFree: Bool
    let imageUrl: URL?
    
    // Computed properties for easy access
    var imageUrlPath: String? {
        imageUrl?.absoluteString
    }
    
    var macrosPercent: MacrosPercent {
        MacrosPercent(
            proteinPercent: macros.proteinPercent,
            carbohydratesPercent: macros.carbohydratesPercent,
            fatPercent: macros.fatPercent
        )
    }
    
    var macrosGrams: MacrosGrams {
        MacrosGrams(
            proteinGrams: macros.proteinGrams,
            carbohydratesGrams: macros.carbohydratesGrams,
            fatGrams: macros.fatGrams
        )
    }
    
    var shortInfo: RecipeShortInfo {
        RecipeShortInfo(
            id: id,
            title: title,
            imageUrl: imageUrl,
            score: score,
            readyInMinutes: readyInMinutes,
            likes: likes
        )
    }
}

// MARK: - Optimized Data Structures for Core Data

struct RecipeCoreData: Codable {
    let id: Int
    let title: String
    let summary: String
    let instructions: String?
    let dateSaved: Date?
    let cuisines: [Cuisine]
    let diets: [Diet]
    let mealTypes: [MealType]
    let occasions: [Occasion]
    let macros: Macros
    let score: Double
    let servings: Double
    let likes: Int
    let cookingMinutes: Double?
    let healthScore: Double
    let preparationMinutes: Double?
    let pricePerServing: Double
    let readyInMinutes: Double
    let isCheap: Bool
    let isVegan: Bool
    let isSustainable: Bool
    let isVegetarian: Bool
    let isVeryHealthy: Bool
    let isVeryPopular: Bool
    let isGlutenFree: Bool
    let isDairyFree: Bool
    let imageUrl: String?
    
    init(from recipe: Recipe) {
        self.id = recipe.id
        self.title = recipe.title
        self.summary = recipe.summary
        self.instructions = recipe.instructions
        self.dateSaved = recipe.dateSaved
        self.cuisines = recipe.cuisines
        self.diets = recipe.diets
        self.mealTypes = recipe.mealTypes
        self.occasions = recipe.occasions
        self.macros = recipe.macros
        self.score = recipe.score
        self.servings = recipe.servings
        self.likes = recipe.likes
        self.cookingMinutes = recipe.cookingMinutes
        self.healthScore = recipe.healthScore
        self.preparationMinutes = recipe.preparationMinutes
        self.pricePerServing = recipe.pricePerServing
        self.readyInMinutes = recipe.readyInMinutes
        self.isCheap = recipe.isCheap
        self.isVegan = recipe.isVegan
        self.isSustainable = recipe.isSustainable
        self.isVegetarian = recipe.isVegetarian
        self.isVeryHealthy = recipe.isVeryHealthy
        self.isVeryPopular = recipe.isVeryPopular
        self.isGlutenFree = recipe.isGlutenFree
        self.isDairyFree = recipe.isDairyFree
        self.imageUrl = recipe.imageUrl?.absoluteString
    }
    
    func toRecipe(ingredients: [IngredientRecipeInfo]) -> Recipe {
        Recipe(
            id: id,
            title: title,
            summary: summary,
            instructions: instructions,
            dateSaved: dateSaved,
            cuisines: cuisines,
            diets: diets,
            mealTypes: mealTypes,
            occasions: occasions,
            ingredients: ingredients,
            macros: macros,
            score: score,
            servings: servings,
            likes: likes,
            cookingMinutes: cookingMinutes,
            healthScore: healthScore,
            preparationMinutes: preparationMinutes,
            pricePerServing: pricePerServing,
            readyInMinutes: readyInMinutes,
            isCheap: isCheap,
            isVegan: isVegan,
            isSustainable: isSustainable,
            isVegetarian: isVegetarian,
            isVeryHealthy: isVeryHealthy,
            isVeryPopular: isVeryPopular,
            isGlutenFree: isGlutenFree,
            isDairyFree: isDairyFree,
            imageUrl: imageUrl.flatMap { URL(string: $0) }
        )
    }
}

struct Macros: Codable, Hashable {
    let proteinPercent: Double
    let carbohydratesPercent: Double
    let fatPercent: Double
    let proteinGrams: Double
    let carbohydratesGrams: Double
    let fatGrams: Double
    
    var calories: Double {
        // 4 calories per gram of protein and carbs, 9 calories per gram of fat
        return (proteinGrams * 4) + (carbohydratesGrams * 4) + (fatGrams * 9)
    }
    
    var isNotEmpty: Bool {
        proteinPercent != 0 &&
        carbohydratesPercent != 0 &&
        fatPercent != 0
    }
}

struct MacrosPercent: Codable, Hashable {
    let proteinPercent: Double
    let carbohydratesPercent: Double
    let fatPercent: Double
}

struct MacrosGrams: Codable, Hashable {
    let proteinGrams: Double
    let carbohydratesGrams: Double
    let fatGrams: Double
}
