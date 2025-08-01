//
//  AnalyticsExtensions.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 1/1/25.
//

import SwiftUI
import Foundation

// MARK: - View Extensions

extension View {
    func trackScreen(_ screen: ScreenEvent) -> some View {
        self.onAppear {
            AnalyticsService.shared.trackScreen(screen)
        }
    }
    
    func trackFeature(_ feature: AnalyticsFeature) -> some View {
        self.onTapGesture {
            AnalyticsService.shared.trackUserEngagement(.featureUsed(name: feature.rawValue))
        }
    }
}

// MARK: - Recipe Extensions

extension RecipeShortInfo {
    func trackViewed() {
        AnalyticsService.shared.trackRecipe(.viewed(id: id, title: title))
    }
    
    func trackSaved() {
        AnalyticsService.shared.trackRecipe(.saved(id: id, title: title))
    }
    
    func trackUnsaved() {
        AnalyticsService.shared.trackRecipe(.unsaved(id: id, title: title))
    }
    
    func trackShared() {
        AnalyticsService.shared.trackRecipe(.shared(id: id, title: title))
    }
}

extension Recipe {
    func trackViewed() {
        AnalyticsService.shared.trackRecipe(.viewed(id: id, title: title))
    }
    
    func trackSaved() {
        AnalyticsService.shared.trackRecipe(.saved(id: id, title: title))
    }
    
    func trackUnsaved() {
        AnalyticsService.shared.trackRecipe(.unsaved(id: id, title: title))
    }
    
    func trackShared() {
        AnalyticsService.shared.trackRecipe(.shared(id: id, title: title))
    }
}

// MARK: - ViewModel Extensions

extension SwiftUIBaseViewModel {
    func trackError(_ error: Error, context: String = "") {
        let contextName = context.isEmpty ? String(describing: type(of: self)) : context
        AnalyticsService.shared.trackError(.appError(description: error.localizedDescription, context: contextName))
    }
    
    func trackPerformance(operation: String, duration: TimeInterval, additionalParams: [String: Any] = [:]) {
        AnalyticsService.shared.trackPerformance(.measurement(operation: operation, duration: duration, additionalParams: additionalParams))
    }
}

// MARK: - Search Extensions

extension MainPageSearchViewModel {
    func trackSearch(query: String, resultCount: Int) {
        AnalyticsService.shared.trackSearch(.performed(query: query, resultCount: resultCount))
    }
    
    func trackFilterApplied(filterType: String, filterValue: String) {
        AnalyticsService.shared.trackSearch(.filterApplied(type: filterType, value: filterValue))
    }
}

extension SearchByIngredientsViewModel {
    func trackSearchByIngredients(ingredients: [String], resultCount: Int) {
        AnalyticsService.shared.trackSearch(.byIngredients(ingredients: ingredients, resultCount: resultCount))
    }
}

// MARK: - Shopping List Extensions

extension ShoppingListPageViewModel {
    func trackIngredientAdded(_ ingredientName: String, recipeTitle: String? = nil) {
        AnalyticsService.shared.trackShoppingList(.ingredientAdded(name: ingredientName, recipeTitle: recipeTitle))
    }
    
    func trackItemChecked(_ ingredientName: String, isChecked: Bool) {
        AnalyticsService.shared.trackShoppingList(.itemChecked(name: ingredientName, isChecked: isChecked))
    }
}

// MARK: - Recipe Details Extensions

extension RecipeDetailsPageViewModel {
    func trackRecipeLoadTime(_ loadTime: TimeInterval) {
        AnalyticsService.shared.trackRecipe(.loadTime(id: recipeShortInfo.id, duration: loadTime))
    }
    
    func trackIngredientAddedToShoppingList(_ ingredient: IngredientRecipeInfo) {
        AnalyticsService.shared.trackShoppingList(.ingredientAdded(name: ingredient.name, recipeTitle: recipeShortInfo.title))
    }
}

// MARK: - Main Page Extensions

extension MainPageViewModel {
    func trackRandomRecipeGenerated() {
        AnalyticsService.shared.trackCategory(.randomRecipeGenerated(mealType: nil))
    }
    
    func trackCategoryViewed(_ category: String) {
        AnalyticsService.shared.trackCategory(.viewed(name: category))
    }
}

// MARK: - App Lifecycle Extensions

extension PureBiteApp {
    func trackAppLifecycle() {
        // Track app open
        AnalyticsService.shared.trackUserEngagement(.appOpened)
        
        // Track session start
        AnalyticsService.shared.trackUserEngagement(.sessionStart)
    }
} 