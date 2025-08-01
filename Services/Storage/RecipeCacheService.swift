//
//  RecipeCacheService.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 1/1/25.
//

import Foundation
import Combine

@MainActor
final class RecipeCacheService: ObservableObject {
    static let shared = RecipeCacheService()
    
    @Published private(set) var cachedRecipes: [Recipe] = []
    @Published private(set) var cachedRecipeLists: [String: [RecipeShortInfo]] = [:]
    
    private let userDefaults = UserDefaults.standard
    private let maxCachedRecipes = 50
    private let maxCachedLists = 10
    
    private init() {
        loadCachedData()
    }
    
    // MARK: - Recipe Caching
    
    func cacheRecipe(_ recipe: Recipe) {
        // Remove if already exists
        cachedRecipes.removeAll { $0.id == recipe.id }
        
        // Add to beginning
        cachedRecipes.insert(recipe, at: 0)
        
        // Limit cache size
        if cachedRecipes.count > maxCachedRecipes {
            cachedRecipes = Array(cachedRecipes.prefix(maxCachedRecipes))
        }
        
        saveCachedData()
    }
    
    func getCachedRecipe(id: Int) -> Recipe? {
        return cachedRecipes.first { $0.id == id }
    }
    
    func removeCachedRecipe(id: Int) {
        cachedRecipes.removeAll { $0.id == id }
        saveCachedData()
    }
    
    // MARK: - Recipe List Caching
    
    func cacheRecipeList(_ recipes: [RecipeShortInfo], forKey key: String) {
        cachedRecipeLists[key] = recipes
        
        // Limit number of cached lists
        if cachedRecipeLists.count > maxCachedLists {
            let oldestKey = cachedRecipeLists.keys.first
            if let key = oldestKey {
                cachedRecipeLists.removeValue(forKey: key)
            }
        }
        
        saveCachedData()
    }
    
    func getCachedRecipeList(forKey key: String) -> [RecipeShortInfo]? {
        return cachedRecipeLists[key]
    }
    
    func clearCache() {
        cachedRecipes.removeAll()
        cachedRecipeLists.removeAll()
        saveCachedData()
    }
    
    // MARK: - Private Methods
    
    private func saveCachedData() {
        // Save cached recipes
        if let recipesData = try? JSONEncoder().encode(cachedRecipes) {
            userDefaults.set(recipesData, forKey: "cached_recipes")
        }
        
        // Save cached recipe lists
        if let listsData = try? JSONEncoder().encode(cachedRecipeLists) {
            userDefaults.set(listsData, forKey: "cached_recipe_lists")
        }
    }
    
    private func loadCachedData() {
        // Load cached recipes
        if let recipesData = userDefaults.data(forKey: "cached_recipes"),
           let recipes = try? JSONDecoder().decode([Recipe].self, from: recipesData) {
            cachedRecipes = recipes
        }
        
        // Load cached recipe lists
        if let listsData = userDefaults.data(forKey: "cached_recipe_lists"),
           let lists = try? JSONDecoder().decode([String: [RecipeShortInfo]].self, from: listsData) {
            cachedRecipeLists = lists
        }
    }
} 