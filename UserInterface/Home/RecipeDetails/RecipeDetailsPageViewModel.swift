import Combine
import UIKit
import SwiftUI
import Core
import CoreUserInterface
import Shared
import Services

public final class RecipeDetailsPageViewModel: DefaultPageViewModel {

    public enum Input {
        case favorite
        case ingredientSelected(IngredientDetailsPageViewModel.Config)
    }

    public enum Event {
        case finish
        case showIngredientInformation(IngredientDetailsPageViewModel.Config)
    }
    
    public var onEvent: ((Event) -> Void)?

    @Published var recipe: Recipe?
    @Published var isFavorite: Bool = false
    @Published var isNavigationTitleOnScreen: Bool = false

    public let recipeShortInfo: RecipeShortInfo

    // MARK: - Private Properties
    private let spoonacularNetworkService: SpoonacularNetworkServiceInterface
    private let favoritesService: FavoritesServiceInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(
        recipeShortInfo: RecipeShortInfo,
        spoonacularNetworkService: SpoonacularNetworkServiceInterface,
        favoritesService: FavoritesServiceInterface
    ) {
        self.recipeShortInfo = recipeShortInfo
        self.spoonacularNetworkService = spoonacularNetworkService
        self.favoritesService = favoritesService
        super.init()
        setInitialState()
        loadRecipeDetails(with: recipeShortInfo.id)
    }

    // MARK: - Public Methods

    public func handle(_ input: Input) {
        switch input {
        case .favorite:
            toggleFavorite()
        case .ingredientSelected(let config):
            onEvent?(.showIngredientInformation(config))
        }
    }

    // MARK: - Private Methods

    private func setInitialState() {
        loadingStarted()
        do {
            isFavorite = try favoritesService.isFavorite(recipeWithId: recipeShortInfo.id)
        } catch {
            errorReceived(error, displayType: .none)
        }
    }

    private func loadRecipeDetails(with id: Int) {
        if let savedRecipe = try? favoritesService.fetchRecipeById(id) {
            recipe = savedRecipe
        } else {
            Task { @MainActor in
                do {
                    recipe = try await spoonacularNetworkService.recipeInformation(id: id).coreModel
                } catch {
                    errorReceived(error, displayType: .page, action: { [weak self] in
                        self?.resetAdditionalState()
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
            } else {
                try favoritesService.save(recipe: recipe)
                isFavorite = true
            }
        } catch {
            errorReceived(error, displayType: .none)
        }
    }
}
