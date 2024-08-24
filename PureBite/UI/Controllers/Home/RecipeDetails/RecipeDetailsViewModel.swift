import Combine
import EnumsMacros
import EventSenderMacro
import UIKit

@EventSender
public final class RecipeDetailsViewModel: DefaultPageViewModel<RecipeDetailsContentProps> {

    @PlainedEnum
    public enum Event {
        case finish
    }

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

    // MARK: - Private Methods

    private func setupBindings() {
        state.contentProps.on { [weak self] event in
            switch event {
            case .finish:
                self?.send(event: .finish)
            case .favorite:
                break
            }
        }
    }

    private func setInitialState() {
        state.additionalState = .loading(DefaultLoaderProps())
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
