import Foundation
import Combine

@MainActor
final class SavedRecipesPageViewModel: SwiftUIBaseViewModel {

    @Published var isSearchActive: Bool = false
    @Published var searchTerm: String = .empty
    @Published var groupedRecipes: [MealType: Set<RecipeShortInfo>] = [:]
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

        for recipe in recipes {
            let mealTypes = Array(Set(recipe.mealTypes))
            
            // If recipe hasn't been assigned yet
            if !usedRecipes.contains(recipe.id) {
                // Prioritize meal types (exclude .other if there are other options)
                let prioritizedMealTypes = mealTypes.filter { $0 != .other }
                let targetMealType = prioritizedMealTypes.first ?? .other
                
                groupedRecipes[targetMealType, default: []].insert(recipe.shortInfo)
                usedRecipes.insert(recipe.id)
            }
        }

        return groupedRecipes
    }
}
