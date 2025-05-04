import Foundation
import Combine
import Core
import CoreUserInterface
import Shared
import Services

public final class SavedRecipesPageViewModel: DefaultPageViewModel {

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
    private let savedRecipesService: SavedRecipesServiceInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(savedRecipesService: SavedRecipesServiceInterface) {
        self.savedRecipesService = savedRecipesService
        super.init()

        setupBindings()
    }

    // MARK: - Private Methods

    private func setupBindings() {
        savedRecipesService.savedRecipesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.resetAdditionalState()
                    self?.errorReceived(error, displayType: .page)
                }
            } receiveValue: { [weak self] recipes in
                self?.allRecipes = recipes.map(\.shortInfo)
                self?.groupedRecipes = self?.groupRecipesByMealTypes(recipes) ?? [:]
                self?.additionalState = recipes.isEmpty ? .placeholder() : nil
            }
            .store(in: &cancellables)
    }

    private func groupRecipesByMealTypes(_ recipes: [Recipe]) -> [MealType: Set<RecipeShortInfo>] {
        var groupedRecipes: [MealType: Set<RecipeShortInfo>] = [:]

        for recipe in recipes {
            var addedToGroup = false
            for mealType in recipe.mealTypes {
                groupedRecipes[mealType, default: []].insert(recipe.shortInfo)
                addedToGroup = true
            }
            // If no valid MealType found, add to "Other"
            if !addedToGroup {
                groupedRecipes[.other, default: []].insert(recipe.shortInfo)
            }
        }

        return groupedRecipes
    }
}
