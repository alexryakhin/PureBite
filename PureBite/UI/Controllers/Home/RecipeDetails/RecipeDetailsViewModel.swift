import Combine
import UIKit

public final class RecipeDetailsViewModel: DefaultPageViewModel<RecipeDetailsContentProps> {

    public enum Input {
        case favorite
    }

    public enum Event {
        case finish
    }
    var onEvent: ((Event) -> Void)?

    // MARK: - Private Properties

    private let recipeId: Int
    private let spoonacularNetworkService: SpoonacularNetworkServiceInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(
        recipeId: Int,
        spoonacularNetworkService: SpoonacularNetworkServiceInterface
    ) {
        self.recipeId = recipeId
        self.spoonacularNetworkService = spoonacularNetworkService
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
            break
        }
    }

    // MARK: - Private Methods

    private func setupBindings() {
    }

    private func setInitialState() {
        state.additionalState = .loading()
    }

    private func loadRecipeDetails(with id: Int) {
        Task { @MainActor in
            do {
                let response = try await spoonacularNetworkService.recipeInformation(id: id)
                state.contentProps.recipe = response
                state.additionalState = nil
                setupBindings()
            } catch {
                errorReceived(error, contentPreserved: false)
            }
        }
    }
}
