//
//  CDRecipe+Extension.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 4/6/25.
//

import CoreData

extension CDRecipe {

    var _ingredients: [CDIngredient] {
        let sets = ingredients as? Set<CDIngredient> ?? []
        return sets.sorted {
            $0.name ?? .empty < $1.name ?? .empty
        }
    }
    
    var recipeCoreData: RecipeCoreData? {
        guard let recipeData = recipeData,
              let data = try? JSONDecoder().decode(RecipeCoreData.self, from: recipeData)
        else { return nil }
        return data
    }

    var coreModel: Recipe? {
        guard let recipeCoreData = recipeCoreData else { return nil }
        
        return recipeCoreData.toRecipe(ingredients: _ingredients.compactMap(\.coreModelFromRecipe))
    }
    
    func updateRecipeData(_ recipe: Recipe) {
        let recipeCoreData = RecipeCoreData(from: recipe)
        self.recipeData = try? JSONEncoder().encode(recipeCoreData)
        self.id = Int64(recipe.id)
        self.dateSaved = recipe.dateSaved
    }
    
    // Helper method to create a new CDRecipe from a Recipe
    static func create(from recipe: Recipe, in context: NSManagedObjectContext) -> CDRecipe {
        let cdRecipe = CDRecipe(context: context)
        cdRecipe.updateRecipeData(recipe)
        return cdRecipe
    }
}
