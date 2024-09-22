import Foundation
import Combine

public final class SavedViewModel: DefaultPageViewModel {

    public enum Event {
        case openRecipeDetails(config: RecipeDetailsViewModel.Config)
        case openCategory(config: RecipeCollectionViewModel.Config)
    }
    var onEvent: ((Event) -> Void)?

    @Published var groupedRecipes: [MealType: [Recipe]] = [:]

    // MARK: - Private Properties
    private let favoritesService: FavoritesServiceInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(favoritesService: FavoritesServiceInterface) {
        self.favoritesService = favoritesService
        super.init()

        setupBindings()
    }

    // MARK: - Public Methods

    public func retry() {

    }

    // MARK: - Private Methods

    private func setupBindings() {
        favoritesService.favoritesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] recipes in
                self?.groupedRecipes = self?.groupRecipesByMealTypes(recipes) ?? [:]
                self?.state.additionalState = recipes.isEmpty ? .empty(DefaultPlaceholderProps()) : nil
            }
            .store(in: &cancellables)
    }

    private func groupRecipesByMealTypes(_ recipes: [Recipe]) -> [MealType: [Recipe]] {
        var groupedRecipes: [MealType: [Recipe]] = [:]

        for recipe in recipes {
            if let dishTypes = recipe.dishTypes {
                var addedToGroup = false
                for dishType in dishTypes {
                    if let mealType = MealType(rawValue: dishType) {
                        groupedRecipes[mealType, default: []].append(recipe)
                        addedToGroup = true
                    }
                }
                // If no valid MealType found, add to "Other"
                if !addedToGroup {
                    groupedRecipes[.other, default: []].append(recipe)
                }
            } else {
                // Add to "Other" if dishTypes is nil
                groupedRecipes[.other, default: []].append(recipe)
            }
        }

        return groupedRecipes
    }
}
