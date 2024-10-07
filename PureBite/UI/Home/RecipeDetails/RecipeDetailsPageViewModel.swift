import Combine
import UIKit
import SwiftUI

public final class RecipeDetailsPageViewModel: DefaultPageViewModel, @unchecked Sendable {

    public struct Config {
        public var recipeId: Int
        public var title: String
    }

    public enum Input {
        case favorite
    }

    public enum Event {
        case finish
    }
    
    var onEvent: ((Event) -> Void)?

    @Published var recipe: Recipe?
    @Published var isFavorite: Bool = false
    @Published var isNavigationTitleOnScreen: Bool = false

    public let config: Config

    // MARK: - Private Properties
    private let spoonacularNetworkService: SpoonacularNetworkServiceInterface
    private let favoritesService: FavoritesServiceInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(
        config: Config,
        spoonacularNetworkService: SpoonacularNetworkServiceInterface,
        favoritesService: FavoritesServiceInterface
    ) {
        self.config = config
        self.spoonacularNetworkService = spoonacularNetworkService
        self.favoritesService = favoritesService
        super.init()
        setInitialState()
        loadRecipeDetails(with: config.recipeId)
    }

    // MARK: - Public Methods

    public func handle(_ input: Input) {
        switch input {
        case .favorite:
            toggleFavorite()
        }
    }

    // MARK: - Private Methods

    private func setInitialState() {
        loadingStarted()
        do {
            isFavorite = try favoritesService.isFavorite(recipeWithId: config.recipeId)
        } catch {
            errorReceived(error, displayType: .snack)
        }
    }

    private func loadRecipeDetails(with id: Int) {
        if let savedRecipe = try? favoritesService.fetchRecipeById(id) {
            recipe = savedRecipe
        } else {
            Task { @MainActor in
                do {
                    recipe = try await spoonacularNetworkService.recipeInformation(id: id)
                } catch {
                    errorReceived(error, displayType: .page, action: { [weak self] in
                        self?.loadRecipeDetails(with: id)
                    })
                }
            }
        }
    }


    private func toggleFavorite() {
        guard let recipe else { return }
        do {
            if try favoritesService.isFavorite(recipeWithId: recipe.id) {
                try favoritesService.remove(recipeWithId: recipe.id)
                isFavorite = false
                showSnack(withModel: .init(title: "Recipe removed from Favorites"))
            } else {
                try favoritesService.save(recipe: recipe)
                isFavorite = true
                showSnack(withModel: .init(title: "Recipe saved to Favorites"))
            }
        } catch {
            errorReceived(error, displayType: .page)
        }
    }
}
