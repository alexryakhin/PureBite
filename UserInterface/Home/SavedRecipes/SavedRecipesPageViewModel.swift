import Foundation
import Combine

@MainActor
final class SavedRecipesPageViewModel: SwiftUIBaseViewModel {

    @Published var isSearchActive: Bool = false
    @Published var searchTerm: String = .empty
    @Published var groupedRecipes: [MealType: Set<RecipeShortInfo>] = [:]
    @Published var mealTypeTitles: [MealType: String] = [:] // Store custom titles for combined categories
    var allRecipes: [RecipeShortInfo] = []

    // MARK: - Private Properties
    private let savedRecipesService: SavedRecipesService
    private var cancellables = Set<AnyCancellable>()


    override init() {
        self.savedRecipesService = SavedRecipesService.shared
        super.init()

        setupBindings()
    }

    // MARK: - Private Methods

    private func setupBindings() {
        savedRecipesService.$savedRecipes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] recipes in
                self?.allRecipes = recipes.map(\.shortInfo)
                self?.groupedRecipes = self?.groupRecipesByMealTypes(recipes) ?? [:]
            }
            .store(in: &cancellables)
    }

    private func groupRecipesByMealTypes(_ recipes: [Recipe]) -> [MealType: Set<RecipeShortInfo>] {
        var groupedRecipes: [MealType: Set<RecipeShortInfo>] = [:]
        var usedRecipes: Set<Int> = [] // Track which recipes have been assigned
        var mealTypeTitles: [MealType: String] = [:] // Store custom titles

        info("[SAVED_RECIPES] Grouping \(recipes.count) recipes using original API meal type order")

        for recipe in recipes {
            // If recipe hasn't been assigned yet
            if !usedRecipes.contains(recipe.id) {
                // Use the original meal types order from the API
                let recipeMealTypes = recipe.mealTypes
                
                // Find the first non-other meal type, or use .other if none found
                let targetMealType = recipeMealTypes.first { $0 != .other } ?? .other
                
                // Create a combined title if recipe has multiple relevant meal types
                let relevantMealTypes = recipeMealTypes.filter { $0 != .other }
                let combinedTitle = createCombinedTitle(for: relevantMealTypes, primaryType: targetMealType)
                
                info("[SAVED_RECIPES] Recipe '\(recipe.title)' has meal types: \(recipeMealTypes.map(\.rawValue)) → assigned to: \(targetMealType.rawValue) with title: \(combinedTitle)")

                groupedRecipes[targetMealType, default: []].insert(recipe.shortInfo)
                mealTypeTitles[targetMealType] = combinedTitle
                usedRecipes.insert(recipe.id)
            }
        }

        // Update the published property
        self.mealTypeTitles = mealTypeTitles

        // Log final grouping results
        info("[SAVED_RECIPES] Final grouping:")
        for (mealType, recipes) in groupedRecipes.sorted(by: { $0.key.rawValue < $1.key.rawValue }) {
            let title = mealTypeTitles[mealType] ?? mealType.title
            info("[SAVED_RECIPES] - \(title): \(recipes.count) recipes")
        }

        return groupedRecipes
    }
    
    private func createCombinedTitle(for mealTypes: [MealType], primaryType: MealType) -> String {
        // If only one meal type, use its standard title
        if mealTypes.count == 1 {
            return primaryType.title
        }
        
        // For multiple meal types, create a combined title
        let sortedTypes = mealTypes.sorted { $0.rawValue < $1.rawValue }
        
        // Common combinations
        if sortedTypes.contains(.lunch) && sortedTypes.contains(.dinner) {
            return "Lunch & Dinner"
        }
        if sortedTypes.contains(.lunch) && sortedTypes.contains(.soup) {
            return "Lunch & Soup"
        }
        if sortedTypes.contains(.dinner) && sortedTypes.contains(.soup) {
            return "Dinner & Soup"
        }
        if sortedTypes.contains(.salad) && sortedTypes.contains(.appetizer) {
            return "Salad & Appetizer"
        }
        if sortedTypes.contains(.breakfast) && sortedTypes.contains(.lunch) {
            return "Breakfast & Lunch"
        }
        
        // For other combinations, join with "&"
        let titles = sortedTypes.map(\.title)
        return titles.joined(separator: " & ")
    }
}
