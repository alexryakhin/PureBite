import Combine
import UIKit
import SwiftUI

@MainActor
public final class RecipeDetailsPageViewModel: SwiftUIBaseViewModel {

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
    private let spoonacularNetworkService: SpoonacularNetworkService
    private let savedRecipesService: SavedRecipesService
    private let shoppingListRepository: ShoppingListRepository
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(recipeShortInfo: RecipeShortInfo) {
        self.recipeShortInfo = recipeShortInfo
        self.spoonacularNetworkService = SpoonacularNetworkService.shared
        self.savedRecipesService = SavedRecipesService.shared
        self.shoppingListRepository = ShoppingListRepository.shared
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
            SnackCenter.shared.showSnack(withConfig: .init(title: "Success", message: "Added successfully the ingredient to your shopping list"))
        }
    }

    // MARK: - Private Methods

    private func setInitialState() {
        setLoading(true)
        do {
            isFavorite = try savedRecipesService.isFavorite(recipeWithId: recipeShortInfo.id)
        } catch {
            handleError(error, showAsAlert: false)
        }
    }

    private func loadRecipeDetails(with id: Int) {
        if let savedRecipe = try? savedRecipesService.fetchRecipeById(id) {
            recipe = savedRecipe
            setLoading(false)
        } else {
            Task { @MainActor in
                do {
                    recipe = try await spoonacularNetworkService.recipeInformation(id: id).coreModel
                    setLoading(false)
                } catch {
                    handleError(error)
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
            handleError(error, showAsAlert: false)
        }
    }
}
