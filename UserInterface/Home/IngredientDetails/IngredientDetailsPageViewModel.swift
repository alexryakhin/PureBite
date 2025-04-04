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

    @Published var ingredient: IngredientFull?

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
                ingredient = try await spoonacularNetworkService.ingredientInformation(
                    params: .init(
                        id: config.id,
                        amount: config.amount,
                        unit: config.unit
                    )
                )
            } catch {
                errorReceived(error, displayType: .page, action: { [weak self] in
                    self?.loadIngredientDetails()
                })
            }
        }
    }


//    private func toggleFavorite() {
//        guard let ingredient else { return }
//        do {
//            if try favoritesService.isFavorite(recipeWithId: recipe.id) {
//                try favoritesService.remove(recipeWithId: recipe.id)
//                isFavorite = false
//            } else {
//                try favoritesService.save(recipe: recipe)
//                isFavorite = true
//            }
//        } catch {
//            errorReceived(error, displayType: .snack)
//        }
//    }
}
