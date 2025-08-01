//
//  AnalyticsEvent.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 1/1/25.
//

import Foundation
import FirebaseAnalytics

// MARK: - Analytics Event Protocol

protocol AnalyticsEvent {
    var name: String { get }
    var parameters: [String: Any] { get }
}

// MARK: - Screen Events

enum ScreenEvent: String, AnalyticsEvent {
    case welcome = "screen_welcome"
    case mainPage = "screen_main_page"
    case recipeDetails = "screen_recipe_details"
    case savedRecipes = "screen_saved_recipes"
    case search = "screen_search"
    case searchByIngredients = "screen_search_by_ingredients"
    case shoppingList = "screen_shopping_list"
    case profile = "screen_profile"
    case trending = "screen_trending"
    case quickMeals = "screen_quick_meals"
    case healthy = "screen_healthy"
    case desserts = "screen_desserts"
    case recommended = "screen_recommended"
    
    var name: String { rawValue }
    var parameters: [String: Any] {
        [
            AnalyticsParameterScreenName: rawValue,
            AnalyticsParameterScreenClass: rawValue
        ]
    }
}

// MARK: - Recipe Events

enum RecipeEvent: AnalyticsEvent {
    case viewed(id: Int, title: String)
    case saved(id: Int, title: String)
    case unsaved(id: Int, title: String)
    case shared(id: Int, title: String)
    case loadTime(id: Int, duration: TimeInterval)
    
    var name: String {
        switch self {
        case .viewed: return "recipe_viewed"
        case .saved: return "recipe_saved"
        case .unsaved: return "recipe_unsaved"
        case .shared: return "recipe_shared"
        case .loadTime: return "recipe_load_time"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .viewed(let id, let title):
            return ["recipe_id": id, "recipe_title": title]
        case .saved(let id, let title):
            return ["recipe_id": id, "recipe_title": title]
        case .unsaved(let id, let title):
            return ["recipe_id": id, "recipe_title": title]
        case .shared(let id, let title):
            return ["recipe_id": id, "recipe_title": title]
        case .loadTime(let id, let duration):
            return ["recipe_id": id, "load_time_seconds": duration]
        }
    }
}

// MARK: - Search Events

enum SearchEvent: AnalyticsEvent {
    case performed(query: String, resultCount: Int)
    case byIngredients(ingredients: [String], resultCount: Int)
    case filterApplied(type: String, value: String)
    case loadTime(query: String, duration: TimeInterval)
    
    var name: String {
        switch self {
        case .performed: return "search_performed"
        case .byIngredients: return "search_by_ingredients"
        case .filterApplied: return "filter_applied"
        case .loadTime: return "search_load_time"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .performed(let query, let resultCount):
            return ["search_query": query, "result_count": resultCount]
        case .byIngredients(let ingredients, let resultCount):
            return [
                "ingredients": ingredients.joined(separator: ","),
                "ingredient_count": ingredients.count,
                "result_count": resultCount
            ]
        case .filterApplied(let type, let value):
            return ["filter_type": type, "filter_value": value]
        case .loadTime(let query, let duration):
            return ["search_query": query, "load_time_seconds": duration]
        }
    }
}

// MARK: - Shopping List Events

enum ShoppingListEvent: AnalyticsEvent {
    case ingredientAdded(name: String, recipeTitle: String?)
    case itemChecked(name: String, isChecked: Bool)
    
    var name: String {
        switch self {
        case .ingredientAdded: return "ingredient_added_to_shopping_list"
        case .itemChecked: return "shopping_list_item_checked"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .ingredientAdded(let name, let recipeTitle):
            var params: [String: Any] = ["ingredient_name": name]
            if let recipeTitle = recipeTitle {
                params["source_recipe"] = recipeTitle
            }
            return params
        case .itemChecked(let name, let isChecked):
            return ["ingredient_name": name, "is_checked": isChecked]
        }
    }
}

// MARK: - Category Events

enum CategoryEvent: AnalyticsEvent {
    case viewed(name: String)
    case randomRecipeGenerated(mealType: String?)
    
    var name: String {
        switch self {
        case .viewed: return "category_viewed"
        case .randomRecipeGenerated: return "random_recipe_generated"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .viewed(let name):
            return ["category_name": name]
        case .randomRecipeGenerated(let mealType):
            var params: [String: Any] = [:]
            if let mealType = mealType {
                params["meal_type"] = mealType
            }
            return params
        }
    }
}

// MARK: - User Engagement Events

enum UserEngagementEvent: AnalyticsEvent {
    case appOpened
    case sessionStart
    case sessionEnd(duration: TimeInterval)
    case featureUsed(name: String)
    
    var name: String {
        switch self {
        case .appOpened: return AnalyticsEventAppOpen
        case .sessionStart: return "session_start"
        case .sessionEnd: return "session_end"
        case .featureUsed: return "feature_used"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .appOpened:
            return [:]
        case .sessionStart:
            return ["timestamp": Date().timeIntervalSince1970]
        case .sessionEnd(let duration):
            return ["session_duration": duration]
        case .featureUsed(let name):
            return ["feature_name": name]
        }
    }
}

// MARK: - Error Events

enum ErrorEvent: AnalyticsEvent {
    case appError(description: String, context: String)
    
    var name: String { "app_error" }
    var parameters: [String: Any] {
        switch self {
        case .appError(let description, let context):
            return [
                "error_description": description,
                "error_context": context
            ]
        }
    }
}

// MARK: - Performance Events

enum PerformanceEvent: AnalyticsEvent {
    case measurement(operation: String, duration: TimeInterval, additionalParams: [String: Any])
    
    var name: String { "performance_measurement" }
    var parameters: [String: Any] {
        switch self {
        case .measurement(let operation, let duration, let additionalParams):
            var params: [String: Any] = [
                "operation": operation,
                "duration_seconds": duration
            ]
            params.merge(additionalParams) { _, new in new }
            return params
        }
    }
}

// MARK: - Feature Enum

enum AnalyticsFeature: String, CaseIterable {
    case randomRecipe = "random_recipe"
    case searchByIngredients = "search_by_ingredients"
    case recipeSharing = "recipe_sharing"
    case shoppingList = "shopping_list"
    case recipeFavorites = "recipe_favorites"
    case offlineMode = "offline_mode"
    case recipeCategories = "recipe_categories"
    case recipeSearch = "recipe_search"
    case recipeDetails = "recipe_details"
    case savedRecipes = "saved_recipes"
} 