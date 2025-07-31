import Foundation
import Combine

@MainActor
public final class SavedRecipesPageViewModel: SwiftUIBaseViewModel {

    public enum Event {
        case openRecipeDetails(recipeShortInfo: RecipeShortInfo)
        case openCategory(config: RecipeCollectionPageViewModel.Config)
    }
    public var onEvent: ((Event) -> Void)?

    @Published var isSearchActive: Bool = false
    @Published var searchTerm: String = .empty
    @Published var groupedRecipes: [MealType: Set<RecipeShortInfo>] = [:]
    var allRecipes: [RecipeShortInfo] = []

    // MARK: - Private Properties
    private let savedRecipesService: SavedRecipesService
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public override init() {
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

        for recipe in recipes {
            let mealTypes = Array(Set(recipe.mealTypes))
            if mealTypes == [.other] {
                groupedRecipes[.other, default: []].insert(recipe.shortInfo)
            } else {
                for mealType in mealTypes where mealType != .other {
                    groupedRecipes[mealType, default: []].insert(recipe.shortInfo)
                }
            }
        }

        return groupedRecipes
    }
}
