import Foundation
import Combine
import Core
import CoreUserInterface
import Shared
import Services

public final class SavedPageViewModel: DefaultPageViewModel {

    public enum Event {
        case openRecipeDetails(config: RecipeDetailsPageViewModel.Config)
        case openCategory(config: RecipeCollectionPageViewModel.Config)
    }
    public var onEvent: ((Event) -> Void)?

    @Published var isSearchActive: Bool = false
    @Published var searchTerm: String = .empty
    @Published var groupedRecipes: [MealType: Set<Recipe>] = [:]
    var allRecipes: [Recipe] = []

    // MARK: - Private Properties
    private let favoritesService: FavoritesServiceInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(favoritesService: FavoritesServiceInterface) {
        self.favoritesService = favoritesService
        super.init()

        setupBindings()
    }

    // MARK: - Private Methods

    private func setupBindings() {
        favoritesService.favoritesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.resetAdditionalState()
                    self?.errorReceived(error, displayType: .page)
                }
            } receiveValue: { [weak self] recipes in
                self?.allRecipes = recipes
                self?.groupedRecipes = self?.groupRecipesByMealTypes(recipes) ?? [:]
                self?.additionalState = recipes.isEmpty ? .placeholder() : nil
            }
            .store(in: &cancellables)
    }

    private func groupRecipesByMealTypes(_ recipes: [Recipe]) -> [MealType: Set<Recipe>] {
        var groupedRecipes: [MealType: Set<Recipe>] = [:]

        for recipe in recipes {
            if let dishTypes = recipe.dishTypes {
                var addedToGroup = false
                for dishType in dishTypes {
                    if let mealType = MealType(rawValue: dishType) {
                        groupedRecipes[mealType, default: []].insert(recipe)
                        addedToGroup = true
                    }
                }
                // If no valid MealType found, add to "Other"
                if !addedToGroup {
                    groupedRecipes[.other, default: []].insert(recipe)
                }
            } else {
                // Add to "Other" if dishTypes is nil
                groupedRecipes[.other, default: []].insert(recipe)
            }
        }

        return groupedRecipes
    }
}
