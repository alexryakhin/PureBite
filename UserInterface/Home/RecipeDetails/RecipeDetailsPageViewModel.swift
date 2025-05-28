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
        case ingredientSelected(IngredientRecipeInfo)
    }

    public enum Event {
        case finish
    }
    
    public var onEvent: ((Event) -> Void)?

    @Published var recipe: Recipe?
    @Published var isFavorite: Bool = false
    @Published var isNavigationTitleOnScreen: Bool = false

    public let recipeShortInfo: RecipeShortInfo

    // MARK: - Private Properties
    private let spoonacularNetworkService: SpoonacularNetworkServiceInterface
    private let savedRecipesService: SavedRecipesServiceInterface
    private let shoppingListRepository: ShoppingListRepositoryInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(
        recipeShortInfo: RecipeShortInfo,
        spoonacularNetworkService: SpoonacularNetworkServiceInterface,
        savedRecipesService: SavedRecipesServiceInterface,
        shoppingListRepository: ShoppingListRepositoryInterface
    ) {
        self.recipeShortInfo = recipeShortInfo
        self.spoonacularNetworkService = spoonacularNetworkService
        self.savedRecipesService = savedRecipesService
        self.shoppingListRepository = shoppingListRepository
        super.init()
        setInitialState()
        loadRecipeDetails(with: recipeShortInfo.id)
    }

    // MARK: - Public Methods

    public func handle(_ input: Input) {
        switch input {
        case .favorite:
            toggleFavorite()
        case .ingredientSelected(let ingredient):
            shoppingListRepository.addIngredient(
                .init(
                    aisle: ingredient.aisle,
                    id: ingredient.id,
                    imageUrlPath: ingredient.imageUrlPath,
                    name: ingredient.name,
                    possibleUnits: []
                ),
                unit: ingredient.unit,
                amount: ingredient.amount
            )
        }
    }

    // MARK: - Private Methods

    private func setInitialState() {
        loadingStarted()
        do {
            isFavorite = try savedRecipesService.isFavorite(recipeWithId: recipeShortInfo.id)
        } catch {
            errorReceived(error, displayType: .none)
        }
    }

    private func loadRecipeDetails(with id: Int) {
        if let savedRecipe = try? savedRecipesService.fetchRecipeById(id) {
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
            if try savedRecipesService.isFavorite(recipeWithId: recipe.id) {
                try savedRecipesService.remove(recipeWithId: recipe.id)
                isFavorite = false
            } else {
                try savedRecipesService.save(recipe: recipe)
                isFavorite = true
            }
        } catch {
            errorReceived(error, displayType: .none)
        }
    }
}
