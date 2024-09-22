import Combine
import UIKit

public final class RecipeDetailsViewModel: DefaultPageViewModel {

    public enum Input {
        case favorite
        case handleScroll(CGFloat)
    }

    public enum Event {
        case finish
        case handleScroll(CGFloat)
    }
    var onEvent: ((Event) -> Void)?

    @Published var recipe: Recipe?
    @Published var isFavorite: Bool = false

    // MARK: - Private Properties

    private let recipeId: Int
    private let spoonacularNetworkService: SpoonacularNetworkServiceInterface
    private let favoritesService: FavoritesServiceInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(
        recipeId: Int,
        spoonacularNetworkService: SpoonacularNetworkServiceInterface,
        favoritesService: FavoritesServiceInterface
    ) {
        self.recipeId = recipeId
        self.spoonacularNetworkService = spoonacularNetworkService
        self.favoritesService = favoritesService
        super.init()
        setInitialState()
        loadRecipeDetails(with: recipeId)
    }

    // MARK: - Public Methods

    public func retry() {
        loadRecipeDetails(with: recipeId)
    }

    public func handle(_ input: Input) {
        switch input {
        case .favorite:
            toggleFavorite()
        case .handleScroll(let offset):
            onEvent?(.handleScroll(offset))
        }
    }

    // MARK: - Private Methods

    private func setupBindings() {
    }

    private func setInitialState() {
        state.additionalState = .loading()
        do {
            isFavorite = try favoritesService.isFavorite(recipeWithId: recipeId)
        } catch {
            errorReceived(error, contentPreserved: true)
        }
    }

    private func loadRecipeDetails(with id: Int) {
        Task { @MainActor in
            do {
                if let savedRecipe = try? favoritesService.fetchRecipeById(id) {
                    recipe = savedRecipe
                } else {
                    recipe = try await spoonacularNetworkService.recipeInformation(id: id)
                }
                state.additionalState = nil
                setupBindings()
            } catch {
                errorReceived(error, contentPreserved: false)
            }
        }
    }

    private func toggleFavorite() {
        guard let recipe else { return }
        do {
            if try favoritesService.isFavorite(recipeWithId: recipe.id) {
                try favoritesService.remove(recipeWithId: recipe.id)
                isFavorite = false
                snacksDisplay?.showSnack(withConfig: .init(message: "Recipe removed from Favorites"))
            } else {
                try favoritesService.save(recipe: recipe)
                isFavorite = true
                snacksDisplay?.showSnack(withConfig: .init(message: "Recipe saved to Favorites"))
            }
        } catch {
            errorReceived(error, contentPreserved: true)
        }
    }
}
