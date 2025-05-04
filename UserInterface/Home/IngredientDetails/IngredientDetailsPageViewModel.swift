import Combine
import UIKit
import SwiftUI
import Core
import CoreUserInterface
import Shared
import Services

public final class IngredientDetailsPageViewModel: DefaultPageViewModel {

    public struct Config {
        public var id: Int
        public var name: String
        public var amount: Double?
        public var unit: String?
    }

    public enum Input {
        case dismiss
    }

    public enum Event {
        case finish
    }
    
    public var onEvent: ((Event) -> Void)?

    @Published var ingredient: Ingredient?

    public let config: Config

    // MARK: - Private Properties
    private let spoonacularNetworkService: SpoonacularNetworkServiceInterface
    private let savedRecipesService: SavedRecipesServiceInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(
        config: Config,
        spoonacularNetworkService: SpoonacularNetworkServiceInterface,
        savedRecipesService: SavedRecipesServiceInterface
    ) {
        self.config = config
        self.spoonacularNetworkService = spoonacularNetworkService
        self.savedRecipesService = savedRecipesService
        super.init()
        loadIngredientDetails()
    }

    // MARK: - Public Methods

    public func handle(_ input: Input) {
        switch input {
        case .dismiss:
            onEvent?(.finish)
        }
    }

    // MARK: - Private Methods

    private func loadIngredientDetails() {
        Task { @MainActor in
            do {
                let ingredientResponse = try await spoonacularNetworkService.ingredientInformation(
                    params: .init(
                        id: config.id,
                        amount: config.amount,
                        unit: config.unit
                    )
                )
                self.ingredient = ingredientResponse.coreModel
            } catch {
                errorReceived(error, displayType: .page, action: { [weak self] in
                    self?.resetAdditionalState()
                    self?.loadIngredientDetails()
                })
            }
        }
    }


//    private func toggleFavorite() {
//        guard let ingredient else { return }
//        do {
//            if try savedRecipesService.isFavorite(recipeWithId: recipe.id) {
//                try savedRecipesService.remove(recipeWithId: recipe.id)
//                isFavorite = false
//            } else {
//                try savedRecipesService.save(recipe: recipe)
//                isFavorite = true
//            }
//        } catch {
//            errorReceived(error, displayType: .snack)
//        }
//    }
}
